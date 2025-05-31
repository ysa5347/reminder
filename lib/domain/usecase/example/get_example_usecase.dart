import 'package:reminder/domain/entities/example.dart';
import 'package:reminder/domain/repository/example_repository.dart';

class GetExampleUsecase {
  final ExampleRepository repository;

  GetExampleUsecase({required this.repository});

  Future<Example> execute() async {
    return await repository.getExample();
  }
}
