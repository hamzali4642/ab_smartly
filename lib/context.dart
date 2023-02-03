 import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:ab_smartly/variable_parser.dart';
import 'audience_matcher.dart';

import 'context_config.dart';
import 'context_data.dart';
import 'context_data_provider.dart';
import 'context_event_handler.dart';
import 'context_event_logger.dart';
import 'internal/variant_assigner.dart';
import 'java/time/clock.dart';
import 'java_system_classes/closeable.dart';
import 'json/attribute.dart';
import 'json/exposure.dart';
import 'json/goal_achievement.dart';

class Context implements Closeable {


  static Context create(Clock clock,  ContextConfig config,
       ScheduledExecutorService scheduler,
       Future<ContextData> dataFuture,  ContextDataProvider dataProvider,
       ContextEventHandler eventHandler, ContextEventLogger eventLogger,
       VariableParser variableParser,  AudienceMatcher audienceMatcher) {

    clock_ = clock;
    


    return new Context(clock, config, scheduler, dataFuture, dataProvider, eventHandler, eventLogger,
        variableParser, audienceMatcher);
  }

  Context(Clock clock, ContextConfig config, ScheduledExecutorService scheduler,
      CompletableFuture<ContextData> dataFuture, ContextDataProvider dataProvider,
      ContextEventHandler eventHandler, ContextEventLogger eventLogger, VariableParser variableParser,
      AudienceMatcher audienceMatcher) {
    clock_ = clock;
    publishDelay_ = config.getPublishDelay();
    refreshInterval_ = config.getRefreshInterval();
    eventHandler_ = eventHandler;
    eventLogger_ = config.getEventLogger() != null ? config.getEventLogger() : eventLogger;
    dataProvider_ = dataProvider;
    variableParser_ = variableParser;
    audienceMatcher_ = audienceMatcher;
    scheduler_ = scheduler;

    units_ = Map<String, String>();

    final Map<String, String> units = config.getUnits();
    if (units != null) {
      setUnits(units);
    }

    assigners_ = new HashMap<String, VariantAssigner>(units_.size());
    hashedUnits_ = new HashMap<String, byte[]>(units_.size());

    final Map<String, dynamic> attributes = config.getAttributes();
    if (attributes != null) {
    setAttributes(attributes);
    }

    final Map<String, int> overrides = config.getOverrides();
    overrides_ = (overrides != null) ? Map<String, int>(overrides) : Map<String, int>();

    final Map<String, int> cassignments = config.getCustomAssignments();
    cassignments_ = (cassignments != null) ? new HashMap<String, Integer>(cassignments)
        : new HashMap<String, Integer>();

    if (dataFuture.isDone()) {
    dataFuture.thenAccept(new Consumer<ContextData>() {
    @Override
    public void accept(ContextData data) {
    Context.this.setData(data);
    Context.this.logEvent(ContextEventLogger.EventType.Ready, data);
    }
    }).exceptionally(new Function<Throwable, Void>() {
    @Override
    public Void apply(Throwable exception) {
    Context.this.setDataFailed(exception);
    Context.this.logError(exception);
    return null;
    }
    });
    } else {
    readyFuture_ = new CompletableFuture<Void>();
    dataFuture.thenAccept(new Consumer<ContextData>() {
    @Override
    public void accept(ContextData data) {
    Context.this.setData(data);
    readyFuture_.complete(null);
    readyFuture_ = null;

    Context.this.logEvent(ContextEventLogger.EventType.Ready, data);

    if (Context.this.getPendingCount() > 0) {
    Context.this.setTimeout();
    }
    }
    }).exceptionally(new Function<Throwable, Void>() {
    @Override
    public Void apply(Throwable exception) {
    Context.this.setDataFailed(exception);
    readyFuture_.complete(null);
    readyFuture_ = null;

    Context.this.logError(exception);

    return null;
    }
    });
    }
  }

  bool isReady() {
    return data_ != null;
  }

  bool isFailed() {
    return failed_;
  }

  bool isClosed() {
    return closed_.get();
  }

  bool isClosing() {
    return !closed_.get() && closing_.get();
  }

  public CompletableFuture<Context> waitUntilReadyAsync() {
    if (data_ != null) {
      return CompletableFuture.completedFuture(this);
    } else {
      return readyFuture_.thenApply(new Function<Void, Context>() {
          @Override
          public Context apply(Void k) {
        return Context.this;
  }
  });
  }
  }

  Context waitUntilReady() {
    if (data_ == null) {
      final CompletableFuture<Void> future = readyFuture_; // cache here to avoid locking
      if (future != null && !future.isDone()) {
        future.join();
      }
    }
    return this;
  }

  List<String> getExperiments() {
    checkReady(true);

    try {
      dataLock_.readLock().lock();
      final List<String> experimentNames = new String[data_.experiments.length];

      int index = 0;
      for (final Experiment experiment : data_.experiments) {
        experimentNames[index++] = experiment.name;
      }

      return experimentNames;
    } finally {
      dataLock_.readLock().unlock();
    }
  }

  ContextData getData() {
    checkReady(true);

    try {
      dataLock_.readLock().lock();
      return data_;
    } finally {
      dataLock_.readLock().unlock();
    }
  }

  void setOverride( final String experimentName, final int variant) {
    checkNotClosed();

    Concurrency.putRW(contextLock_, overrides_, experimentName, variant);
  }

  int getOverride( final String experimentName) {
    return Concurrency.getRW(contextLock_, overrides_, experimentName);
  }

  void setOverrides( Map<String, int> overrides) {

    for (Map.Entry<String, int> entry : overrides.entrySet()) {
    String key = entry.getKey();
    int value = entry.getValue();
    setOverride(key, value);
    }
  }

  void setCustomAssignment( String experimentName, int variant) {
    checkNotClosed();

    Concurrency.putRW(contextLock_, cassignments_, experimentName, variant);
  }

  int getCustomAssignment( String experimentName) {
    return Concurrency.getRW(contextLock_, cassignments_, experimentName);
  }

  void setCustomAssignments( Map<String, int> customAssignments) {
    for (Map.Entry<String, Integer> entry : customAssignments.entrySet()) {
    String key = entry.getKey();
    int value = entry.getValue();
    setCustomAssignment(key, value);
    }
  }

  String getUnit( final String unitType) {
    final ReentrantReadWriteLock.ReadLock readLock = contextLock_.readLock();
    try {
      readLock.lock();
      return units_.get(unitType);
    } finally {
      readLock.unlock();
    }
  }

  void setUnit( final String unitType,  final String uid) {
    checkNotClosed();

    final ReentrantReadWriteLock.WriteLock writeLock = contextLock_.writeLock();
    try {
      writeLock.lock();

      final String previous = units_.get(unitType);
      if ((previous != null) && !previous.equals(uid)) {
        throw new IllegalArgumentException(String.format("Unit '%s' already set.", unitType));
      }

      final String trimmed = uid.trim();
      if (trimmed.isEmpty()) {
        throw new IllegalArgumentException(String.format("Unit '%s' UID must not be blank.", unitType));
      }

      units_.put(unitType, trimmed);
    } finally {
      writeLock.unlock();
    }
  }

  Map<String, String> getUnits() {
    final ReentrantReadWriteLock.ReadLock readLock = contextLock_.readLock();
    try {
      readLock.lock();
      return Map<String, String>(units_);
    } finally {
      readLock.unlock();
    }
  }

  void setUnits( Map<String, String> units) {
    for (Map.Entry<String, String> entry : units.entrySet()) {
    String key = entry.getKey();
    String value = entry.getValue();
    setUnit(key, value);
    }
  }

  dynamic getAttribute( final String name) {
    final ReentrantReadWriteLock.ReadLock readLock = contextLock_.readLock();
    try {
      readLock.lock();
      for (int i = attributes_.size(); i-- > 0;) {
        final Attribute attr = attributes_.get(i);
        if (name == attr.name) {
          return attr.value;
        }
      }

      return null;
    } finally {
      readLock.unlock();
    }
  }

  void setAttribute( String name, dynamic value) {
    checkNotClosed();

    Concurrency.addRW(contextLock_, attributes_, new Attribute(name, value, clock_.millis()));
  }

  Map<String, dynamic> getAttributes() {
    final Map<String, dynamic> result = Map<String, dynamic>(attributes_.size());
    final ReentrantReadWriteLock.ReadLock readLock = contextLock_.readLock();
    try {
      readLock.lock();
      for (final Attribute attr : attributes_) {
        result.put(attr.name, attr.value);
      }
      return result;
    } finally {
      readLock.unlock();
    }
  }

  void setAttributes( final Map<String, dynamic> attributes) {
    for (Map.Entry<String, dynamic> entry : attributes.entrySet()) {
    String key = entry.getKey();
    Object value = entry.getValue();
    setAttribute(key, value);
    }
  }

  public int getTreatment( final String experimentName) {
    checkReady(true);

    final Assignment assignment = getAssignment(experimentName);
    if (!assignment.exposed.get()) {
      queueExposure(assignment);
    }

    return assignment.variant;
  }

  void queueExposure(final Assignment assignment) {
    if (assignment.exposed.compareAndSet(false, true)) {
      final Exposure exposure = Exposure();
      exposure.id = assignment.id;
      exposure.name = assignment.name;
      exposure.unit = assignment.unitType;
      exposure.variant = assignment.variant;
      exposure.exposedAt = clock_.millis();
      exposure.assigned = assignment.assigned;
      exposure.eligible = assignment.eligible;
      exposure.overridden = assignment.overridden;
      exposure.fullOn = assignment.fullOn;
      exposure.custom = assignment.custom;
      exposure.audienceMismatch = assignment.audienceMismatch;

      try {
        eventLock_.lock();
        pendingCount_.incrementAndGet();
        exposures_.add(exposure);
      } finally {
        eventLock_.unlock();
      }

      logEvent(ContextEventLogger.EventType.Exposure, exposure);

      setTimeout();
    }
  }

  int peekTreatment( final String experimentName) {
    checkReady(true);

    return getAssignment(experimentName).variant;
  }

  Map<String, List<String>> getVariableKeys() {
    checkReady(true);

    final Map<String, List<String>> variableKeys = new HashMap<String, List<String>>(indexVariables_.size());

    try {
      dataLock_.readLock().lock();
      for (Map.Entry<String, List<ExperimentVariables>> entry : indexVariables_.entrySet()) {
    final String key = entry.getKey();
    final List<ExperimentVariables> keyExperimentVariables = entry.getValue();
    final List<String> values = new ArrayList<String>(keyExperimentVariables.size());

    for (final ExperimentVariables experimentVariables : keyExperimentVariables) {
    values.add(experimentVariables.data.name);
    }
    variableKeys.put(key, values);
    }
    } finally {
    dataLock_.readLock().unlock();
    }
    return variableKeys;
  }

  dynamic getVariableValue( final String key, final dynamic defaultValue) {
    checkReady(true);

    final Assignment assignment = getVariableAssignment(key);
    if (assignment != null) {
      if (assignment.variables != null) {
        if (!assignment.exposed.get()) {
          queueExposure(assignment);
        }

        if (assignment.variables.containsKey(key)) {
          return assignment.variables.get(key);
        }
      }
    }
    return defaultValue;
  }

  Object peekVariableValue( final String key, final Object defaultValue) {
    checkReady(true);

    final Assignment assignment = getVariableAssignment(key);
    if (assignment != null) {
      if (assignment.variables != null) {
        if (assignment.variables.containsKey(key)) {
          return assignment.variables.get(key);
        }
      }
    }
    return defaultValue;
  }

  public void track( final String goalName, final Map<String, Object> properties) {
    checkNotClosed();

    final GoalAchievement achievement = GoalAchievement();
    achievement.achievedAt = clock_.millis();
    achievement.name = goalName;
    achievement.properties = (properties == null) ? null : new TreeMap<String, Object>(properties);

    try {
      eventLock_.lock();
      pendingCount_.incrementAndGet();
      achievements_.add(achievement);
    } finally {
      eventLock_.unlock();
    }

    logEvent(ContextEventLogger.EventType.Goal, achievement);

    setTimeout();
  }

  public CompletableFuture<Void> publishAsync() {
    checkNotClosed();

    return flush();
  }

  public void publish() {
    publishAsync().join();
  }

  public int getPendingCount() {
    return pendingCount_.get();
  }

  public CompletableFuture<Void> refreshAsync() {
    checkNotClosed();

    if (refreshing_.compareAndSet(false, true)) {
      refreshFuture_ = new CompletableFuture<Void>();

      dataProvider_.getContextData().thenAccept(new Consumer<ContextData>() {
      @Override
      public void accept(ContextData data) {
      Context.this.setData(data);
      refreshing_.set(false);
      refreshFuture_.complete(null);

      Context.this.logEvent(ContextEventLogger.EventType.Refresh, data);
      }
      }).exceptionally(new Function<Throwable, Void>() {
          @Override
          public Void apply(Throwable exception) {
        refreshing_.set(false);
        refreshFuture_.completeExceptionally(exception);

        Context.this.logError(exception);
    return null;
    }
    });
    }

    final CompletableFuture<Void> future = refreshFuture_;
    if (future != null) {
    return future;
    }

    return CompletableFuture.completedFuture(null);
  }

  public void refresh() {
    refreshAsync().join();
  }

  public CompletableFuture<Void> closeAsync() {
    if (!closed_.get()) {
      if (closing_.compareAndSet(false, true)) {
        clearRefreshTimer();

        if (pendingCount_.get() > 0) {
          closingFuture_ = new CompletableFuture<Void>();

          flush().thenAccept(new Consumer<Void>() {
          @Override
          public void accept(Void x) {
          closed_.set(true);
          closing_.set(false);
          closingFuture_.complete(null);

          Context.this.logEvent(ContextEventLogger.EventType.Close, null);
          }
          }).exceptionally(new Function<Throwable, Void>() {
              @Override
              public Void apply(Throwable exception) {
            closed_.set(true);
            closing_.set(false);
            closingFuture_.completeExceptionally(exception);
            // event logger gets this error during publish

            return null;
          }
        });

    return closingFuture_;
    } else {
    closed_.set(true);
    closing_.set(false);

    Context.this.logEvent(ContextEventLogger.EventType.Close, null);
    }
    }

    final CompletableFuture<Void> future = closingFuture_;
    if (future != null) {
    return future;
    }
    }

    return CompletableFuture.completedFuture(null);
    }

  @Override
  public void close() {
    closeAsync().join();
  }

  CompletableFuture<Void> flush() {
    clearTimeout();

    if (!failed_) {
      if (pendingCount_.get() > 0) {
        Exposure[] exposures = null;
        GoalAchievement[] achievements = null;
        int eventCount;

        try {
          eventLock_.lock();
          eventCount = pendingCount_.get();

          if (eventCount > 0) {
            if (!exposures_.isEmpty()) {
              exposures = exposures_.toArray(new Exposure[0]);
              exposures_.clear();
            }

            if (!achievements_.isEmpty()) {
              achievements = achievements_.toArray(new GoalAchievement[0]);
              achievements_.clear();
            }

            pendingCount_.set(0);
          }
        } finally {
          eventLock_.unlock();
        }

        if (eventCount > 0) {
          final PublishEvent event = new PublishEvent();
          event.hashed = true;
          event.publishedAt = clock_.millis();
          event.units = Algorithm.mapSetToArray(units_.entrySet(), new Unit[0],
              new Function<Map.Entry<String, String>, Unit>() {
              @Override
              public Unit apply(Map.Entry<String, String> entry) {
              return new Unit(entry.getKey(),
              new String(getUnitHash(entry.getKey(), entry.getValue()),
              StandardCharsets.US_ASCII));
              }
              });
          event.attributes = attributes_.isEmpty() ? null : attributes_.toArray(new Attribute[0]);
          event.exposures = exposures;
          event.goals = achievements;

          final CompletableFuture<Void> result = new CompletableFuture<Void>();

          eventHandler_.publish(this, event).thenRunAsync(new Runnable() {
          @Override
          public void run() {
          Context.this.logEvent(ContextEventLogger.EventType.Publish, event);
          result.complete(null);
          }
          }).exceptionally(new Function<Throwable, Void>() {
              @Override
              public Void apply(Throwable throwable) {
            Context.this.logError(throwable);

    result.completeExceptionally(throwable);
    return null;
    }
    });

    return result;
    }
    }
    } else {
    try {
    eventLock_.lock();
    exposures_.clear();
    achievements_.clear();
    pendingCount_.set(0);
    } finally {
    eventLock_.unlock();
    }
    }

    return CompletableFuture.completedFuture(null);
  }

  void checkNotClosed() {
    if (closed_.get()) {
      throw new IllegalStateException("ABSmartly Context is closed");
    } else if (closing_.get()) {
      throw new IllegalStateException("ABSmartly Context is closing");
    }
  }

  void checkReady(final boolean expectNotClosed) {
    if (!isReady()) {
      throw new IllegalStateException("ABSmartly Context is not yet ready");
    } else if (expectNotClosed) {
      checkNotClosed();
    }
  }

  boolean experimentMatches(final Experiment experiment, final Assignment assignment) {
    return experiment.id == assignment.id &&
        experiment.unitType.equals(assignment.unitType) &&
        experiment.iteration == assignment.iteration &&
        experiment.fullOnVariant == assignment.fullOnVariant &&
        Arrays.equals(experiment.trafficSplit, assignment.trafficSplit);
  }

  static class Assignment {
  int id;
  int iteration;
  int fullOnVariant;
  String name;
  String unitType;
  double[] trafficSplit;
  int variant;
  boolean assigned;
  boolean overridden;
  boolean eligible;
  boolean fullOn;
  boolean custom;

  boolean audienceMismatch;
  Map<String, Object> variables = Collections.emptyMap();

  final AtomicBoolean exposed = new AtomicBoolean(false);
  }

  Assignment getAssignment(final String experimentName) {
  final ReentrantReadWriteLock.ReadLock readLock = contextLock_.readLock();
  try {
  readLock.lock();

  final Assignment assignment = assignmentCache_.get(experimentName);

  if (assignment != null) {
  final Integer custom = cassignments_.get(experimentName);
  final Integer override = overrides_.get(experimentName);
  final ExperimentVariables experiment = Context.this.getExperiment(experimentName);

  if (override != null) {
  if (assignment.overridden && assignment.variant == override) {
  // override up-to-date
  return assignment;
  }
  } else if (experiment == null) {
  if (!assignment.assigned) {
  // previously not-running experiment
  return assignment;
  }
  } else if ((custom == null) || custom == assignment.variant) {
  if (experimentMatches(experiment.data, assignment)) {
  // assignment up-to-date
  return assignment;
  }
  }
  }
  } finally {
  readLock.unlock();
  }

  // cache miss or out-dated
  final ReentrantReadWriteLock.WriteLock writeLock = contextLock_.writeLock();
  try {
  writeLock.lock();

  final Integer custom = cassignments_.get(experimentName);
  final Integer override = overrides_.get(experimentName);
  final ExperimentVariables experiment = Context.this.getExperiment(experimentName);

  final Assignment assignment = new Assignment();
  assignment.name = experimentName;
  assignment.eligible = true;

  if (override != null) {
  if (experiment != null) {
  assignment.id = experiment.data.id;
  assignment.unitType = experiment.data.unitType;
  }

  assignment.overridden = true;
  assignment.variant = override;
  } else {
  if (experiment != null) {
  final String unitType = experiment.data.unitType;

  if (experiment.data.audience != null && experiment.data.audience.length() > 0) {
  final Map<String, Object> attrs = new HashMap<String, Object>(attributes_.size());
  for (final Attribute attr : attributes_) {
  attrs.put(attr.name, attr.value);
  }

  final AudienceMatcher.Result match = audienceMatcher_
      .evaluate(experiment.data.audience, attrs);
  if (match != null) {
  assignment.audienceMismatch = !match.get();
  }
  }

  if (experiment.data.audienceStrict && assignment.audienceMismatch) {
  assignment.variant = 0;
  } else if (experiment.data.fullOnVariant == 0) {
  final String uid = units_.get(experiment.data.unitType);
  if (uid != null) {
  final byte[] unitHash = Context.this.getUnitHash(unitType, uid);

  final VariantAssigner assigner = Context.this.getVariantAssigner(unitType,
  unitHash);
  final boolean eligible = assigner.assign(experiment.data.trafficSplit,
  experiment.data.trafficSeedHi,
  experiment.data.trafficSeedLo) == 1;
  if (eligible) {
  if (custom != null) {
  assignment.variant = custom;
  assignment.custom = true;
  } else {
  assignment.variant = assigner.assign(experiment.data.split,
  experiment.data.seedHi,
  experiment.data.seedLo);
  }
  } else {
  assignment.eligible = false;
  assignment.variant = 0;
  }
  assignment.assigned = true;
  }
  } else {
  assignment.assigned = true;
  assignment.variant = experiment.data.fullOnVariant;
  assignment.fullOn = true;
  }

  assignment.unitType = unitType;
  assignment.id = experiment.data.id;
  assignment.iteration = experiment.data.iteration;
  assignment.trafficSplit = experiment.data.trafficSplit;
  assignment.fullOnVariant = experiment.data.fullOnVariant;
  }
  }

  if ((experiment != null) && (assignment.variant < experiment.data.variants.length)) {
  assignment.variables = experiment.variables.get(assignment.variant);
  }

  assignmentCache_.put(experimentName, assignment);

  return assignment;
  } finally {
  writeLock.unlock();
  }
  }

  Assignment getVariableAssignment(final String key) {
  final List<ExperimentVariables> keyExperimentVariables = getVariableExperiments(key);

  if (keyExperimentVariables != null) {
  for (final ExperimentVariables experimentVariables : keyExperimentVariables) {
  final Assignment assignment = getAssignment(experimentVariables.data.name);
  if (assignment.assigned || assignment.overridden) {
  return assignment;
  }
  }
  }
  return null;
  }

  ExperimentVariables getExperiment(final String experimentName) {
  try {
  dataLock_.readLock().lock();
  return index_.get(experimentName);
  } finally {
  dataLock_.readLock().unlock();
  }
  }

  List<ExperimentVariables> getVariableExperiments(final String key) {
  return Concurrency.getRW(dataLock_, indexVariables_, key);
  }

  byte[] getUnitHash(final String unitType, final String unitUID) {
  return Concurrency.computeIfAbsentRW(contextLock_, hashedUnits_, unitType, new Function<String, byte[]>() {
  @Override
  public byte[] apply(String key) {
  return Hashing.hashUnit(unitUID);
  }
  });
  }

  VariantAssigner getVariantAssigner(final String unitType, final byte[] unitHash) {
  return Concurrency.computeIfAbsentRW(contextLock_, assigners_, unitType,
  new Function<String, VariantAssigner>() {
  @Override
  public VariantAssigner apply(String key) {
  return new VariantAssigner(unitHash);
  }
  });
  }

  void setTimeout() {
  if (isReady()) {
  if (timeout_ == null) {
  try {
  timeoutLock_.lock();
  if (timeout_ == null) {
  timeout_ = scheduler_.schedule(new Runnable() {
  @Override
  public void run() {
  Context.this.flush();
  }
  }, publishDelay_, TimeUnit.MILLISECONDS);
  }
  } finally {
  timeoutLock_.unlock();
  }
  }
  }
  }

  void clearTimeout() {
  if (timeout_ != null) {
  try {
  timeoutLock_.lock();
  if (timeout_ != null) {
  timeout_.cancel(false);
  timeout_ = null;
  }
  } finally {
  timeoutLock_.unlock();
  }
  }
  }

  void setRefreshTimer() {
  if ((refreshInterval_ > 0) && (refreshTimer_ == null)) {
  refreshTimer_ = scheduler_.scheduleWithFixedDelay(new Runnable() {
  @Override
  public void run() {
  Context.this.refreshAsync();
  }
  }, refreshInterval_, refreshInterval_, TimeUnit.MILLISECONDS);
  }
  }

  void clearRefreshTimer() {
  if (refreshTimer_ != null) {
  refreshTimer_.cancel(false);
  refreshTimer_ = null;
  }
  }

  static class ExperimentVariables {
  Experiment data;
  ArrayList<Map<String, Object>> variables;
  }

  void setData(final ContextData data) {
  final Map<String, ExperimentVariables> index = new HashMap<String, ExperimentVariables>();
  final Map<String, List<ExperimentVariables>> indexVariables = new HashMap<String, List<ExperimentVariables>>();

  for (final Experiment experiment : data.experiments) {
  final ExperimentVariables experimentVariables = new ExperimentVariables();
  experimentVariables.data = experiment;
  experimentVariables.variables = new ArrayList<Map<String, Object>>(experiment.variants.length);

  for (final ExperimentVariant variant : experiment.variants) {
  if ((variant.config != null) && !variant.config.isEmpty()) {
  final Map<String, Object> variables = variableParser_.parse(this, experiment.name, variant.name,
  variant.config);
  for (final String key : variables.keySet()) {
  List<ExperimentVariables> keyExperimentVariables = indexVariables.get(key);
  if (keyExperimentVariables == null) {
  keyExperimentVariables = new ArrayList<ExperimentVariables>();
  indexVariables.put(key, keyExperimentVariables);
  }

  int at = Collections.binarySearch(keyExperimentVariables, experimentVariables,
  new Comparator<ExperimentVariables>() {
  @Override
  public int compare(ExperimentVariables a, ExperimentVariables b) {
  return Integer.valueOf(a.data.id).compareTo(b.data.id);
  }
  });

  if (at < 0) {
  at = -at - 1;
  keyExperimentVariables.add(at, experimentVariables);
  }
  }

  experimentVariables.variables.add(variables);
  } else {
  experimentVariables.variables.add(Collections.<String, Object> emptyMap());
  }
  }

  index.put(experiment.name, experimentVariables);
  }

  try {
  dataLock_.writeLock().lock();

  index_ = index;
  indexVariables_ = indexVariables;
  data_ = data;

  setRefreshTimer();
  } finally {
  dataLock_.writeLock().unlock();
  }
  }

  void setDataFailed(final Throwable exception) {
  try {
  dataLock_.writeLock().lock();
  index_ = new HashMap<String, ExperimentVariables>();
  indexVariables_ = new HashMap<String, List<ExperimentVariables>>();
  data_ = new ContextData();
  failed_ = true;
  } finally {
  dataLock_.writeLock().unlock();
  }
  }

  void logEvent(ContextEventLogger.EventType event, Object data) {
  if (eventLogger_ != null) {
  eventLogger_.handleEvent(this, event, data);
  }
  }

  void logError(Throwable error) {
  if (eventLogger_ != null) {
  while (error instanceof CompletionException) {
  error = error.getCause();
  }
  eventLogger_.handleEvent(this, ContextEventLogger.EventType.Error, error);
  }
  }

  late Clock clock_;
  int publishDelay_;
  int refreshInterval_;
  ContextEventHandler eventHandler_;
  ContextEventLogger eventLogger_;
  ContextDataProvider dataProvider_;
  VariableParser variableParser_;
  AudienceMatcher audienceMatcher_;
  ScheduledExecutorService scheduler_;
  Map<String, String> units_;
  bool failed_;

  final ReentrantReadWriteLock dataLock_ = ReentrantReadWriteLock();
  ContextData data_;
  Map<String, ExperimentVariables> index_;
  Map<String, List<ExperimentVariables>> indexVariables_;

  final ReentrantReadWriteLock contextLock_ = new ReentrantReadWriteLock();

  final Map<String, Uint8List> hashedUnits_;
  final Map<String, VariantAssigner> assigners_;
  final Map<String, Assignment> assignmentCache_ = Map<String, Assignment>();

  final ReentrantLock eventLock_ = new ReentrantLock();
  final List<Exposure> exposures_ = [];
  final List<GoalAchievement> achievements_ = [];

  final List<Attribute> attributes_ = [];
  late Map<String, int> overrides_;
  late Map<String, int> cassignments_;

  final AtomicInteger pendingCount_ = AtomicInteger(0);
  final AtomicBoolean closing_ = AtomicBoolean(false);
  final AtomicBoolean closed_ = AtomicBoolean(false);
  final AtomicBoolean refreshing_ = AtomicBoolean(false);

  volatile late Future<void> readyFuture_;
  volatile late Future<void> closingFuture_;
  volatile late Future<void> refreshFuture_;

  final ReentrantLock timeoutLock_ = new ReentrantLock();
  volatile ScheduledFuture<?> timeout_ = null;
  volatile ScheduledFuture<?> refreshTimer_ = null;

}