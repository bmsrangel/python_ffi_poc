import 'package:python_ffi/python_ffi.dart';

final class ExcelTest extends PythonModule {
  ExcelTest.from(super.python) : super.from();

  static ExcelTest import() => PythonFfi.instance.importModule(
        'excel_test',
        ExcelTest.from,
      );

  int getRowCount(String filePath) => getFunction('excel_test').call(
        <Object?>[filePath],
      );
}
