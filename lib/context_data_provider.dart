import 'json/context_data.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<ContextDataProvider>()])

abstract class ContextDataProvider {

  Future<ContextData?> getContextData();

}