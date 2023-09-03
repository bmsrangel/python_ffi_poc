import 'package:python_ffi/python_ffi.dart';

final class BasicOperations extends PythonModule {
  BasicOperations.from(super.moduleDelegate) : super.from();

  static BasicOperations import() => PythonModule.import(
        'basic_operations',
        BasicOperations.from,
      );

  int sum(int a, int b) => getFunction('sum').call(<Object?>[a, b]);
  int sub(int a, int b) => getFunction('sub').call(<Object?>[a, b]);
  int multiply(int a, int b) => getFunction('multiply').call(<Object?>[a, b]);
  double divide(int a, int b) => getFunction('divide').call(<Object?>[a, b]);
}
