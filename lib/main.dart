import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:python_ffi/python_ffi.dart';
import 'package:python_ffi_poc/basic_operations.dart';
import 'package:python_ffi_poc/excel_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // '/Volumes/Macintosh HD/opt/homebrew/opt/python@3.11/Frameworks/Python.framework/Versions/3.11/lib'
  await PythonFfi.instance.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BasicOperationsPage(),
    );
  }
}

class BasicOperationsPage extends StatefulWidget {
  const BasicOperationsPage({super.key});

  @override
  State<BasicOperationsPage> createState() => BasicOperationsPageState();
}

class BasicOperationsPageState extends State<BasicOperationsPage> {
  late final BasicOperations _basicOperations;
  late final ExcelTest _excelTest;

  late final TextEditingController _a$;
  late final TextEditingController _b$;

  late int a;
  late int b;
  num result = 0;

  String? filePath;
  int rowCount = 0;

  @override
  void initState() {
    super.initState();
    _basicOperations = BasicOperations.import();
    _excelTest = ExcelTest.import();

    _a$ = TextEditingController();
    _b$ = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _a$.dispose();
    _b$.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Operations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _a$,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _b$,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    prepareVariables();
                    setState(() {
                      result = _basicOperations.sum(a, b);
                    });
                  },
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {
                    prepareVariables();
                    setState(() {
                      result = _basicOperations.sub(a, b);
                    });
                  },
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () {
                    prepareVariables();
                    setState(() {
                      result = _basicOperations.multiply(a, b);
                    });
                  },
                  child: const Text('x'),
                ),
                ElevatedButton(
                  onPressed: () {
                    prepareVariables();
                    setState(() {
                      result = _basicOperations.divide(a, b);
                    });
                  },
                  child: const Text('/'),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Text('The result of the operation is $result'),
            const Divider(height: 64.0),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      allowedExtensions: ['xls', 'xslx'],
                    );
                    if (result != null) {
                      final path = filePath = result.files.first.path;
                      final rows = _excelTest.getRowCount(path!);
                      setState(() {
                        filePath = path;
                        rowCount = rows;
                      });
                    }
                  },
                  child: const Text('Load test file'),
                ),
                const SizedBox(width: 16.0),
                Text(filePath ?? 'Please select a file'),
              ],
            ),
            Text('Row count: $rowCount'),
          ],
        ),
      ),
    );
  }

  void prepareVariables() {
    a = int.parse(_a$.text);
    b = int.parse(_b$.text);
  }
}
