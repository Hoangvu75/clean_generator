import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class CreateWidgetCommand extends Command<void> {
  @override
  final name = 'create';
  @override
  final description = 'Creates a new widget in the specified module.';

  CreateWidgetCommand() {
    // The command will handle the parsing manually, so no need to addOption here.
  }

  @override
  Future<void> run() async {
    // We expect exactly three parts for the command: "widget:<name>", "on", "<module>"
    if (argResults!.rest.length != 3 || argResults!.rest[1].toLowerCase() != 'on') {
      print('Usage: create widget:<widget_name> on <module_name>');
      return;
    }

    final widgetPart = argResults!.rest[0];
    final onPart = argResults!.rest[1];
    final modulePart = argResults!.rest[2];

    // Extract the widget name from the widget part
    if (!widgetPart.startsWith('widget:')) {
      print('The first part of the command must be in the format "widget:<widget_name>".');
      return;
    }
    final widgetName = widgetPart.substring('widget:'.length);

    // Proceed with the execution
    final moduleName = modulePart;
    await _execute(widgetName, moduleName);
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

    print('Widget created at $filePath');
  }
}
