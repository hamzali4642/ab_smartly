import 'dart:core';
import 'dart:js';
import 'dart:typed_data';

import 'package:ab_smartly/helper/mutex/mutex.dart';
import 'package:ab_smartly/variable_parser.dart';
import 'audience_matcher.dart';

import 'audience_matcher.dart';
import 'context_config.dart';
import 'context_data_provider.dart';
import 'context_event_handler.dart';
import 'context_event_logger.dart';
import 'context_event_logger.dart';
import 'context_event_logger.dart';
import 'helper/mutex/read_write_mutex.dart';
import 'internal/concurrency.dart';
import 'internal/variant_assigner.dart';
import 'java/time/clock.dart';
import 'java_system_classes/closeable.dart';
import 'json/attribute.dart';
import 'json/context_data.dart';
import 'json/experiment.dart';
import 'json/experiment_varient.dart';
import 'json/exposure.dart';
import 'json/goal_achievement.dart';

class Context implements Closeable {



  Context(Clock clock, ContextConfig config, ScheduledExecutorService scheduler,
      CompletableFuture<ContextData> dataFuture,
      ContextDataProvider dataProvider,
      ContextEventHandler eventHandler, ContextEventLogger eventLogger,
      VariableParser variableParser,
      AudienceMatcher audienceMatcher) {
    clock_ = clock;
    publishDelay_ = config.getPublishDelay();
    refreshInterval_ = config.getRefreshInterval();
    eventHandler_ = eventHandler;
    eventLogger_ =
        config.getEventLogger() ?? eventLogger;
    dataProvider_ = dataProvider;
    variableParser_ = variableParser;
    audienceMatcher_ = audienceMatcher;
    scheduler_ = scheduler;

    units_ = <String, String>{};

    final Map<String, String> units = config.getUnits();
    if (units != null) {
      setUnits(units);
    }

    assigners_ = <String, VariantAssigner>{};
    hashedUnits_ = <String, Uint8List>{};

    final Map<String, dynamic> attributes = config.getAttributes();
    if (attributes != null) {
      setAttributes(attributes);
    }

    final Map<String, int> overrides = config.getOverrides();
    overrides_ = <String, int>{};

    final Map<String, int>? cassignments = config.getCustomAssignments();
    cassignments_ = <String, int>{};

    if (dataFuture.isDone()) {
      dataFuture.thenAccept(Consumer<ContextData>() {
      @Override
      public void accept(ContextData data) {
      Context.this.setData(data);
      Context.this.logEvent(EventType.Ready, data);
      }
      }).exceptionally(Function<Throwable, Void>() {
          @Override
          public Void apply(Throwable exception)
      {
        Context
    .
    this.setDataFailed(exception);
    Context.this.logError(exception);
    return null;
    }
    });
    } else {
    readyFuture_ = CompletableFuture<Void>();
    dataFuture.thenAccept(Consumer<ContextData>() {
    @Override
    public void accept(ContextData data) {
    Context.this.setData(data);
    readyFuture_.complete(null);
    readyFuture_ = null;

    Context.this.logEvent(EventType.Ready, data);

    if (Context.this.getPendingCount() > 0) {
    Context.this.setTimeout();
    }
    }
    }).exceptionally(Function<Throwable, Void>() {
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
    return closed_;
  }

  bool isClosing() {
    return !closed_ && closing_;
  }

  public CompletableFuture

  <

  Context

  >

  waitUntilReadyAsync() {
    if (data_ != null) {
      return CompletableFuture.completedFuture(this);
    } else {
      return readyFuture_.thenApply(Function<Void, Context>() {
          @Override
          public Context apply(Void k)
      {
        return Context
    .
    this;
  }
  }
    );
  }
  }

  Context waitUntilReady() {
    if (data_ == null) {
      final CompletableFuture<
          Void> future = readyFuture_; // cache here to avoid locking
      if (future != null && !future.isDone()) {
        future.join();
      }
    }
    return this;
  }

  List<String> getExperiments() {
    checkReady(true);

    try {
      dataLock_.acquireRead();
      final List<String> experimentNames = List.generate(data_!.experiments.length, (index) => data_!.experiments[index].name);

      return experimentNames;
    } finally {
      dataLock_.release();
    }
  }

  ContextData getData() {
    checkReady(true);

    try {
      dataLock_.acquireRead();
      return data_;
    } finally {
      dataLock_.release();
    }
  }

  void setOverride(final String experimentName, final int variant) {
    checkNotClosed();
    Concurrency.putRW(contextLock_, overrides_, experimentName, variant);
  }

  int getOverride(final String experimentName) {
    return Concurrency.getRW(contextLock_, overrides_, experimentName);
  }

  void setOverrides(Map<String, int> overrides) {
    overrides.forEach((key, value) {
      setOverride(key, value);
    });
  }

  void setCustomAssignment(String experimentName, int variant) {
    checkNotClosed();
    Concurrency.putRW(contextLock_, cassignments_, experimentName, variant);
  }

  int getCustomAssignment(String experimentName) {
    return Concurrency.getRW(contextLock_, cassignments_, experimentName);
  }

  void setCustomAssignments(Map<String, int> customAssignments) {
    customAssignments.forEach((key, value) {
      setCustomAssignment(key, value);
    });
  }

  String getUnit(final String unitType) {
    try {
      contextLock_.acquireRead();
      return units_[unitType];
    } finally {
      contextLock_.release();
    }
  }

  void setUnit(final String unitType, final String uid) {
    checkNotClosed();

    try {
      contextLock_.acquireWrite();


      final String previous = units_.get(unitType);
      if ((previous != null) && !previous.equals(uid)) {
        throw IllegalArgumentException(
            String.format("Unit '%s' already set.", unitType));
      }

      final String trimmed = uid.trim();
      if (trimmed.isEmpty()) {
        throw IllegalArgumentException(
            String.format("Unit '%s' UID must not be blank.", unitType));
      }

      units_[unitType] = trimmed;
    } finally {
      contextLock_.release();
    }
  }

  Map<String, String> getUnits() {
    try {
      contextLock_.acquireRead();

      return <String, String>{};
    } finally {
      contextLock_.release();
    }
  }

  void setUnits(Map<String, String> units) {
    units.forEach((key, value) {
      setUnit(key, value);
    });
  }

  dynamic getAttribute(final String name) {
    final ReentrantReadWriteLock.ReadLock readLock = contextLock_.readLock();
    try {
      readLock.lock();
      for (int i = attributes_.length; i-- > 0;) {
        final Attribute attr = attributes_[i];
        if (name == attr.name) {
          return attr.value;
        }
      }

      return null;
    } finally {
      readLock.unlock();
    }
  }

  void setAttribute(String name, dynamic value) {
    checkNotClosed();


    Concurrency.addRW(
        contextLock_, attributes_,
        Attribute(name: name, value: value, setAt: clock_.millis()));
  }

  Map<String, dynamic> getAttributes() {
    final Map<String, dynamic> result = Map<String, dynamic>();
    final ReentrantReadWriteLock.ReadLock readLock = contextLock_.readLock();
    try {
      readLock.lock();
      for (final Attribute attr in attributes_) {
        result[attr.name] = attr.value;
      }
      return result;
    } finally {
      readLock.unlock();
    }
  }

  void setAttributes(final Map<String, dynamic> attributes) {
    attributes.forEach((key, value) {
      setAttribute(key, value);
    });
  }

  int getTreatment(final String experimentName) {
    checkReady(true);

    final Assignment assignment = getAssignment(experimentName);
    if (!assignment.exposed.get()) {
      queueExposure(assignment);
    }

    return assignment.variant;
  }

  void queueExposure(final Assignment assignment) {
    if (assignment.exposed.compareAndSet(false, true)) {
      final Exposure exposure = Exposure(id: assignment.id,
          name: assignment.name,
          unit: assignment.unitType,
          variant: assignment.variant,
          exposedAt: clock_.millis(),
          assigned: assignment.assigned,
          eligible: assignment.eligible,
          overridden: assignment.overridden,
          fullOn: assignment.fullOn,
          custom: assignment.custom,
          audienceMismatch: assignment.audienceMismatch);

      try {
        eventLock_.lock();
        pendingCount_.incrementAndGet();
        exposures_.add(exposure);
      } finally {
        eventLock_.unlock();
      }

      logEvent(EventType.Exposure, exposure);

      setTimeout();
    }
  }

  int peekTreatment(final String experimentName) {
    checkReady(true);

    return getAssignment(experimentName).variant;
  }

  Map<String, List<String>> getVariableKeys() {
    checkReady(true);

    final Map<String, List<String>> variableKeys = <String, List<String>>{};

    try {
      dataLock_.readLock().lock();

      for (Map.Entry<String,
          List<ExperimentVariables>> entry : indexVariables_.entrySet()) {
    final String key = entry.getKey();
    final List<ExperimentVariables> keyExperimentVariables = entry.getValue();
    final List<String> values = ArrayList<String>(keyExperimentVariables.size());

    for (final ExperimentVariables experimentVariables : keyExperimentVariables) {
    values.add(experimentVariables.data.name);
    }
    variableKeys.put(key, values);
    }
    } finally {
    dataLock_.readLock().unlock();
    }
    return
    variableKeys;
  }

  dynamic getVariableValue(final String key, final dynamic defaultValue) {
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

  Object peekVariableValue(final String key, final Object defaultValue) {
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

  void track(final String goalName, final Map<String, dynamic> properties) {
    checkNotClosed();

    final GoalAchievement achievement = GoalAchievement(name: goalName, achievedAt: clock_.millis(), properties: {},);
    achievement.achievedAt = clock_.millis();
    achievement.name = goalName;
    achievement.properties =
    (properties == null) ? null : TreeMap<String, Object>(properties);

    try {
      eventLock_.acquire();
      pendingCount_++;
      achievements_.add(achievement);
    } finally {
      eventLock_.release();
    }

    logEvent(EventType.Goal, achievement);

    setTimeout();
  }

  public CompletableFuture

  <

  Void

  >

  publishAsync() {
    checkNotClosed();

    return flush();
  }

  public

  void publish() {
    publishAsync().join();
  }

  int getPendingCount() {
    return pendingCount_;
  }

  public CompletableFuture

  <

  Void

  >

  refreshAsync() {
    checkNotClosed();

    if (refreshing_.compareAndSet(false, true)) {
      refreshFuture_ = CompletableFuture<Void>();

      dataProvider_.getContextData().thenAccept(Consumer<ContextData>() {
      @Override
      public void accept(ContextData data) {
      Context.this.setData(data);
      refreshing_.set(false);
      refreshFuture_.complete(null);

      Context.this.logEvent(EventType.Refresh, data);
      }
      }).exceptionally(Function<Throwable, Void>() {
          @Override
          public Void apply(Throwable exception)
      {
        refreshing_.set(false);
        refreshFuture_.completeExceptionally(exception);

        Context
    .
    this.logError(exception);
    return null;
    }
    });
    }

    final CompletableFuture<Void> future = refreshFuture_;
    if (future != null) {
    return future;
    }

    return
    CompletableFuture
    .
    completedFuture
    (
    null
    );
  }

  public

  void refresh() {
    refreshAsync().join();
  }

  public CompletableFuture

  <

  Void

  >

  closeAsync() {
    if (!closed_.get()) {
      if (closing_.compareAndSet(false, true)) {
        clearRefreshTimer();

        if (pendingCount_.get() > 0) {
          closingFuture_ = CompletableFuture<Void>();

          flush().thenAccept(Consumer<Void>() {
          @Override
          public void accept(Void x) {
          closed_.set(true);
          closing_.set(false);
          closingFuture_.complete(null);

          Context.this.logEvent(EventType.Close, null);
          }
          }).exceptionally(Function<Throwable, Void>() {
              @Override
              public Void apply(Throwable exception)
          {
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

    Context.this.logEvent(EventType.Close, null);
    }
    }

    final CompletableFuture<Void> future = closingFuture_;
    if (future != null) {
    return future;
    }
    }

    return CompletableFuture.completedFuture(null);
    }

  @override
  void close() {
    closeAsync().join();
  }

  CompletableFuture<Void> flush() {
    clearTimeout();

    if (!failed_) {
      if (pendingCount_.get() > 0) {
        List<Exposure>? exposures;
        List<GoalAchievement>? achievements;
        int eventCount;

        try {
          eventLock_.lock();
          eventCount = pendingCount_.get();

          if (eventCount > 0) {
            if (!exposures_.isEmpty()) {
              exposures = exposures_.toArray(Exposure[0]);
              exposures_.clear();
            }

            if (!achievements_.isEmpty()) {
              achievements = achievements_.toArray(GoalAchievement[0]);
              achievements_.clear();
            }

            pendingCount_.set(0);
          }
        } finally {
          eventLock_.unlock();
        }

        if (eventCount > 0) {
          final PublishEvent event = PublishEvent();
          event.hashed = true;
          event.publishedAt = clock_.millis();
          event.units = Algorithm.mapSetToArray(units_.entrySet(), Unit[0],
              Function<Map.Entry<String, String>, Unit>() {
              @Override
              public Unit apply(Map.Entry<String, String> entry) {
              return new Unit(entry.getKey(),
              new String(getUnitHash(entry.getKey(), entry.getValue()),
              StandardCharsets.US_ASCII));
              }
              });
          event.attributes =
          attributes_.isEmpty() ? null : attributes_.toArray(Attribute[0]);
          event.exposures = exposures;
          event.goals = achievements;

          final CompletableFuture<Void> result = CompletableFuture<Void>();

          eventHandler_.publish(this, event).thenRunAsync(Runnable() {
          @Override
          public void run() {
          Context.this.logEvent(EventType.Publish, event);
          result.complete(null);
          }
          }).exceptionally(Function<Throwable, Void>() {
              @Override
              public Void apply(Throwable throwable)
          {
            Context
    .
    this.logError(throwable);

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

    return
    CompletableFuture
    .
    completedFuture
    (
    null
    );
  }

  void checkNotClosed() {
    if (closed_.get()) {
      throw IllegalStateException("ABSmartly Context is closed");
    } else if (closing_.get()) {
      throw IllegalStateException("ABSmartly Context is closing");
    }
  }

  void checkReady(final bool expectNotClosed) {
    if (!isReady()) {
      throw IllegalStateException("ABSmartly Context is not yet ready");
    } else if (expectNotClosed) {
      checkNotClosed();
    }
  }

  bool experimentMatches(final Experiment experiment,
      final Assignment assignment) {
    return experiment.id == assignment.id &&
        experiment.unitType == assignment.unitType &&
        experiment.iteration == assignment.iteration &&
        experiment.fullOnVariant == assignment.fullOnVariant &&
        Arrays.equals(experiment.trafficSplit, assignment.trafficSplit);
  }




  Assignment getAssignment(final String experimentName) {
    try {
      contextLock_.acquireRead();


      final Assignment assignment = assignmentCache_[experimentName]!;

      if (assignment != null) {
        final int custom = cassignments_[experimentName]!;
        final int override = overrides_[experimentName]!;
        final ExperimentVariables experiment = Context
    .this.getExperiment(experimentName);

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
    contextLock_.release();
    }

    // cache miss or out-dated
    final ReentrantReadWriteLock.WriteLock writeLock = contextLock_.writeLock();
    try {
    writeLock.lock();

    final int custom = cassignments_[experimentName]!;
    final int override = overrides_[experimentName]!;
    final ExperimentVariables experiment = Context.this.getExperiment(experimentName);

    final Assignment assignment = Assignment();
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
    final Map<String, Object> attrs = HashMap<String, Object>(attributes_.size());
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
    final Uint8List unitHash = Context.this.getUnitHash(unitType, uid);

    final VariantAssigner assigner = Context.this.getVariantAssigner(unitType,
    unitHash);
    final bool eligible = assigner.assign(experiment.data.trafficSplit,
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
    final List<
        ExperimentVariables> keyExperimentVariables = getVariableExperiments(
        key);

    if (keyExperimentVariables != null) {
      for (ExperimentVariables experimentVariables in keyExperimentVariables) {
        final Assignment assignment = getAssignment(
            experimentVariables.data.name);
        if (assignment.assigned || assignment.overridden) {
          return assignment;
        }
      }
    }
    return null;
  }

  ExperimentVariables getExperiment(final String experimentName) {
    try {
      dataLock_.acquireRead();
      return index_[experimentName]!;
    } finally {
      dataLock_.release();
    }
  }

  List<ExperimentVariables> getVariableExperiments(final String key) {
    return Concurrency.getRW(dataLock_, indexVariables_, key);
  }

  byte

  [

  ]

  getUnitHash(final String unitType, final String unitUID) {
    return Concurrency.computeIfAbsentRW(
        contextLock_, hashedUnits_, unitType, new Function < String,
        byte[] > () {
          @Override
          public byte[]
          apply(String key) {
            return Hashing.hashUnit(unitUID);
          }
        });
  }

  VariantAssigner getVariantAssigner

  (

  final String unitType, final byte[] unitHash) {
  return Concurrency.computeIfAbsentRW(contextLock_, assigners_, unitType,
  Function<String, VariantAssigner>() {
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
  timeout_ ??= scheduler_.schedule(Runnable() {
  @Override
  public void run() {
  Context.this.flush();
  }
  }, publishDelay_, TimeUnit.MILLISECONDS);
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
  refreshTimer_ = scheduler_.scheduleWithFixedDelay(Runnable() {
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


  void setData(final ContextData data) {
  final Map<String, ExperimentVariables> index = Map<String, ExperimentVariables>();
  final Map<String, List<ExperimentVariables>> indexVariables = Map<String, List<ExperimentVariables>>();

  for (Experiment experiment in data.experiments) {
  final ExperimentVariables experimentVariables = ExperimentVariables();
  experimentVariables.data = experiment;
  experimentVariables.variables = List<Map<String, dynamic>>(experiment.variants.length);

  for ( ExperimentVariant variant in experiment.variants) {
  if ((variant.config != null) && variant.config!.isNotEmpty) {
  final Map<String, dynamic>? variables = variableParser_.parse(this, experiment.name, variant.name,
  variant.config!);
  for (final String key in variables.keySet()) {
  List<ExperimentVariables> keyExperimentVariables = indexVariables.get(key);
  if (keyExperimentVariables == null) {
  keyExperimentVariables = <ExperimentVariables>[];
  indexVariables.put(key, keyExperimentVariables);
  }

  int at = Collections.binarySearch(keyExperimentVariables, experimentVariables,
  Comparator<ExperimentVariables>() {
  @Override
  public int compare(ExperimentVariables a, ExperimentVariables b) {
  return int.valueOf(a.data.id).compareTo(b.data.id);
  }
  });

  if (at < 0) {
  at = -at - 1;
  keyExperimentVariables.add (at, experimentVariables);
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
    dataLock_.acquireWrite();

  index_ = index;
  indexVariables_ = indexVariables;
  data_ = data;

  setRefreshTimer();
  } finally {
  dataLock_.release();
  }
  }

  void setDataFailed(final Throwable exception) {
  try {
  dataLock_.acquireWrite();
  index_ = <String, ExperimentVariables>{};
  indexVariables_ = <String, List<ExperimentVariables>>{};
  data_ = ContextData();
  failed_ = true;
  } finally {
  dataLock_.release();
  }
  }

  void logEvent(EventType event, Object data) {
  if (eventLogger_ != null) {
  eventLogger_.handleEvent(this, event, data);
  }
  }

  void logError(Exception error) {
  if (eventLogger_ != null) {
  while (error instanceof CompletionException) {
  error = error.getCause();
  }
  eventLogger_.handleEvent(this, EventType.Error, error);
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

  final ReadWriteMutex dataLock_ = ReadWriteMutex();
  ContextData? data_;
  Map<String, ExperimentVariables> index_;
  Map<String, List<ExperimentVariables>> indexVariables_;

  final ReadWriteMutex contextLock_ = ReadWriteMutex();

  late Map<String, Uint8List> hashedUnits_;
  late Map<String, VariantAssigner> assigners_;
  final Map<String, Assignment> assignmentCache_ = <String, Assignment>{};

  // final ReentrantLock eventLock_ = new ReentrantLock();
  final Mutex eventLock_ = Mutex();
  final List<Exposure> exposures_ = [];
  final List<GoalAchievement> achievements_ = [];

  final List<Attribute> attributes_ = [];
  late Map<String, int> overrides_;
  late Map<String, int> cassignments_;

  int pendingCount_ = 0;
  bool closing_ = false;
  bool closed_ = false;
  bool refreshing_ = false;

  volatile late Future<void> readyFuture_;
  volatile late Future<void> closingFuture_;
  volatile late Future<void> refreshFuture_;

  final Mutex timeoutLock_ = Mutex();
  volatile ScheduledFuture<?> timeout_;
  volatile

  ScheduledFuture

  <

  ?

  >

  refreshTimer_;

}

class ExperimentVariables {
  late Experiment data;
  late List<Map<String, Object>> variables;
}

class Assignment {
  late int id;
  late int iteration;
  late int fullOnVariant;
  late String name;
  late String unitType;
  late List<double> trafficSplit;
  late int variant;
  late bool assigned;
  late bool overridden;
  late bool eligible;
  late bool fullOn;
  late bool custom;

  late bool audienceMismatch;

  Map<String, dynamic> variables = {};

  final bool exposed = false;
}