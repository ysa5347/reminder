import 'package:reminder/domain/entities/example.dart';

abstract class ExampleRepository {
  Future<Example> getExample();
}
