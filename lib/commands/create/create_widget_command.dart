import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class CreateWidgetCommand extends Command<void> {
  @override
  final name = 'create_widget:';
  @override
  final description = 'Creates a new widget in the specified module.';

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 3 || argResults!.rest[1].toLowerCase() != 'on') {
      print('Usage: create_widget: <widget_name> on <module_name>');
      return;
    }

    final widgetPart = argResults!.rest[0];
    final modulePart = argResults!.rest[2];

    final widgetName = widgetPart;
    final moduleName = modulePart;
    await _checkIfModuleExists(moduleName);
    await _checkIsCreated(widgetName, moduleName);
    await _execute(widgetName, moduleName);
    print('Widget ${ReCase(moduleName).pascalCase}Widget created');
  }

  Future<void> _checkIfModuleExists(String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      throw Exception('Module $moduleName does not exist');
    }
  }

  Future<void> _checkIsCreated(String widgetName, String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName/widgets';
    final fileName = ReCase(widgetName).snakeCase;
    final filePath = '$dirPath/${fileName}_widget.dart';
    final file = File(filePath);
    if (await file.exists()) {
      throw Exception(
        'Widget ${ReCase(widgetName).pascalCase}Widget already exists',
      );
    }
  }

  Future<void> _execute(String widgetName, String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName/widgets';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(widgetName).snakeCase;
    final className = ReCase(widgetName).pascalCase;

    final fileContent = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ${className}Widget extends GetWidget {
  const ${className}Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${className}Widget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '${className}Widget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
''';

    final filePath = '$dirPath/${fileName}_widget.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }
}
