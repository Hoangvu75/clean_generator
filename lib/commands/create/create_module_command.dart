import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class CreateModuleCommand extends Command<void> {
  @override
  final name = 'create_module:';
  @override
  final description = 'Creates a new module (includes widget, controller, binding).';

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 1) {
      print('Usage: create_module: <module_name>');
      return;
    }

    final modulePart = argResults!.rest[0];
    final moduleName = modulePart;
    await _checkIsCreated(moduleName);
    await _execute(moduleName);
  }

  Future<void> _checkIsCreated(String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName';
    if (await Directory(dirPath).exists()) {
      throw Exception(
        'Module ${ReCase(moduleName).pascalCase} already exists',
      );
    }
  }

  Future<void> _execute(String moduleName) async {
    await _createWidget(moduleName);
    await _createController(moduleName);
    await _createControllerBinding(moduleName);
    await _addModuleRouteToNavigation(moduleName);
    await _defineModuleRoute(moduleName);
    await _addControllerBindingToExportControllerBindingFile(moduleName);
    await _addScreenToExportScreenFile(moduleName);
    print('Module ${ReCase(moduleName).pascalCase} created');
  }

  Future<void> _createWidget(String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName/widgets';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(moduleName).snakeCase;
    final className = ReCase(moduleName).pascalCase;

    final fileContent = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/${fileName}_controller.dart';

class ${className}Widget extends GetWidget<${className}Controller> {
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

  Future<void> _createController(String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName/controllers';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(moduleName).snakeCase;
    final className = ReCase(moduleName).pascalCase;

    final fileContent = '''
import 'package:get/get.dart';

class ${className}Controller extends GetxController {
  ${className}Controller();
  
  final count = 0.obs;
  
  @override
  void onInit() {
    //TODO: Implement SettingsController
    super.onInit();
  }

  @override
  void onReady() {
    //TODO: Implement SettingsController
    super.onReady();
  }

  @override
  void onClose() {
    //TODO: Implement SettingsController
    super.onClose();
  }

  void increment() => count.value++;
}
''';

    final filePath = '$dirPath/${fileName}_controller.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createControllerBinding(String moduleName) async {
    final dirPath = 'lib/infrastructure/navigation/bindings/controllers';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(moduleName).snakeCase;
    final className = ReCase(moduleName).pascalCase;

    final fileContent = '''
import 'package:get/get.dart';

import '../../../../presentation/${moduleName.toLowerCase()}/controllers/${moduleName.toLowerCase()}_controller.dart';

class ${className}ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ${className}Controller(),
    );
  }
}
''';

    final filePath = '$dirPath/${fileName}_controller_binding.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addModuleRouteToNavigation(String moduleName) async {
    final navigationPath = 'lib/infrastructure/navigation/navigation.dart';
    File file = File(navigationPath);
    String fileContent = await file.readAsString();

    final fileName = ReCase(moduleName).snakeCase;
    final className = ReCase(moduleName).pascalCase;

    String newRoute = '''
    GetPage(
      name: Routes.${fileName.toUpperCase()},
      page: () => const ${className}Widget(),
      binding: ${className}ControllerBinding(),
    ),
    ''';

    String searchPattern = 'static List<GetPage> routes = [';
    int insertIndex = fileContent.indexOf(searchPattern);

    if (insertIndex != -1) {
      insertIndex = fileContent.indexOf('];', insertIndex);
      String updatedContent = '${fileContent.substring(0, insertIndex)}$newRoute\n${fileContent.substring(insertIndex)}';
      await file.writeAsString(updatedContent);
      await Process.run('dart', ['format', navigationPath]);
    }
  }

  Future<void> _defineModuleRoute(String moduleName) async {
    String filePath = 'lib/infrastructure/navigation/routes.dart';
    File file = File(filePath);
    String fileContent = await file.readAsString();
    String routeConstName = ReCase(moduleName).snakeCase.toUpperCase();
    String newRoute = '  static const $routeConstName = \'/${moduleName.toLowerCase()}\';\n';
    int insertIndex = fileContent.lastIndexOf('}');
    if (insertIndex != -1) {
      String updatedContent = fileContent.substring(0, insertIndex) + newRoute + fileContent.substring(insertIndex);
      await file.writeAsString(updatedContent);
      await Process.run('dart', ['format', filePath]);
    }
  }

  Future<void> _addControllerBindingToExportControllerBindingFile(String moduleName) async {
    String dirPath = 'lib/infrastructure/navigation/bindings/controllers';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String filePath = '$dirPath/controllers_bindings.dart';
    File file = File(filePath);
    await file.writeAsString(
      "export '${ReCase(moduleName).snakeCase}_controller_binding.dart';",
      mode: FileMode.append,
    );
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addScreenToExportScreenFile(String moduleName) async {
    String dirPath = 'lib/presentation';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String filePath = '$dirPath/screens.dart';
    File file = File(filePath);
    await file.writeAsString(
      "export '${ReCase(moduleName).snakeCase}/widgets/${ReCase(moduleName).snakeCase}_widget.dart';",
      mode: FileMode.append,
    );
    await Process.run('dart', ['format', filePath]);
  }
}
