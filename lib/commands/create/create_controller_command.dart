import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class CreateControllerCommand extends Command<void> {
  @override
  final name = 'create_controller:';
  @override
  final description = 'Creates a new controller in the specified module.';

  CreateControllerCommand() {
    // The command will handle the parsing manually, so no need to addOption here.
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 3 || argResults!.rest[1].toLowerCase() != 'on') {
      print('Usage: create_controller: <controller_name> on <module_name>');
      return;
    }

    final controllerPart = argResults!.rest[0];
    final onPart = argResults!.rest[1];
    final modulePart = argResults!.rest[2];

    final controllerName = controllerPart;
    final moduleName = modulePart;
    await _execute(controllerName, moduleName);
    await _addControllerToModuleBinding(controllerName, moduleName);
    print('Controller ${ReCase(controllerName).pascalCase}Controller created');
  }

  Future<void> _execute(String controllerName, String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName/controllers';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(controllerName).snakeCase;
    final className = ReCase(controllerName).pascalCase;

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

  Future<void> _addControllerToModuleBinding(String controllerName, String moduleName) async {
    final filePath = 'lib/infrastructure/navigation/bindings/controllers/${ReCase(moduleName).snakeCase}_controller_binding.dart';

    final file = File(filePath);
    String fileContent = await file.readAsString();

    final importStatement = "import '../../../../presentation/${ReCase(moduleName).snakeCase}/controllers/${ReCase(controllerName).snakeCase}_controller.dart';\n";
    final importIndex = fileContent.lastIndexOf("import ");
    final importEndIndex = fileContent.indexOf(';\n', importIndex) + 2;
    fileContent = fileContent.substring(0, importEndIndex) + importStatement + fileContent.substring(importEndIndex);

    final lazyPutStatement = '''
    Get.lazyPut(
      () => ${ReCase(controllerName).pascalCase}Controller(),
    );
''';
    final dependenciesStartIndex = fileContent.indexOf('void dependencies() {');
    final dependenciesEndIndex = fileContent.indexOf('}', dependenciesStartIndex);
    fileContent = fileContent.substring(0, dependenciesEndIndex) + lazyPutStatement + fileContent.substring(dependenciesEndIndex);

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }
}