import 'context.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<ContextEventLogger>()])

abstract class ContextEventLogger {
  void handleEvent(Context context, EventType type, dynamic data);
}

enum EventType {
  Error,
  Ready,
  Refresh,
  Publish,
  Exposure,
  Goal,
  Close,
}
