 import 'java_system_classes/closeable.dart';

class Context implements Closeable {

  @override
  void close() {
     final ReentrantLock timeoutLock_ = new ReentrantLock();
     volatile ScheduledFuture<?> timeout_ = null;
     volatile ScheduledFuture<?> refreshTimer_ = null;
  }

}