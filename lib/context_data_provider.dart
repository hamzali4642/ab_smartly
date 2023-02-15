import 'json/context_data.dart';

abstract class ContextDataProvider {

  Future<ContextData?> getContextData();

}