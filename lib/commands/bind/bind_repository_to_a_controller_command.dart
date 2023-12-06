import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class BindRepositoryToControllerCommand extends Command<void> {
  @override
  final name = 'bind_repo_to_controller:';
  @override
  final description = 'Bind a repository to a controller';

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 5 ||
        argResults!.rest[1].toLowerCase() != 'on' ||
        argResults!.rest[3].toLowerCase() != 'of') {
      print('Usage: bind_repo_to_controller: <repository_name> on'
          ' <controller_name> of <module_name>');
      return;
    }

    final repositoryPart = argResults!.rest[0];
    final controllerPart = argResults!.rest[2];
    final modulePart = argResults!.rest[4];

    final repositoryName = repositoryPart;
    final controllerName = controllerPart;
    final moduleName = modulePart;

    await _checkIfModuleExists(moduleName);
    await _checkIfControllerExists(controllerName, moduleName);
    await _checkIfIsBinded(repositoryName, controllerName, moduleName);
    await _execute(repositoryName, controllerName, moduleName);
    await _configControllerBinding(repositoryName, controllerName, moduleName);

    print('${ReCase(repositoryName).pascalCase}Repository binded to'
        ' ${ReCase(controllerName).pascalCase}Controller');
  }

  Future<void> _checkIfModuleExists(String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      throw Exception('Module $moduleName does not exist');
    }
  }

  Future<void> _checkIfControllerExists(String controllerName, String moduleName) async {
    final dirPath = 'lib/presentation/$moduleName/controllers';
    final fileName = ReCase(controllerName).snakeCase;
    final filePath = '$dirPath/${fileName}_controller.dart';
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception(
        'Controller ${ReCase(controllerName).pascalCase}Controller does not exist',
      );
    }
  }

  Future<void> _checkIfIsBinded(
      String repositoryName,
      String controllerName,
      String moduleName,
      ) async {
    final filePath = 'lib/presentation/${ReCase(moduleName).snakeCase}/controllers/${ReCase(controllerName).snakeCase}_controller.dart';
    final file = File(filePath);
    String fileContent = await file.readAsString();
    if (fileContent.contains('required this.${ReCase(repositoryName).camelCase}Repository')) {
      throw Exception(
        'Service ${ReCase(repositoryName).pascalCase}Repository is already binded to ${ReCase(controllerName).pascalCase}Controller',
      );
    }
  }

  Future<void> _execute(
      String repositoryName,
      String controllerName,
      String moduleName,
      ) async {
    final filePath = 'lib/presentation/${ReCase(moduleName).snakeCase}/controllers/${ReCase(controllerName).snakeCase}_controller.dart';
    final file = File(filePath);
    String fileContent = await file.readAsString();

    if (!fileContent.contains("import '../../../domain/repositories/repositories.dart';")) {
      final importStatement = "import '../../../domain/repositories/repositories.dart';";
      final importIndex = fileContent.lastIndexOf("import ");
      final importEndIndex = fileContent.indexOf(';\n', importIndex) + 1;
      fileContent = fileContent.substring(0, importEndIndex) + importStatement + fileContent.substring(importEndIndex);
    }

    final defineServiceStatement = '''
    final ${ReCase(repositoryName).pascalCase}Repository ${ReCase(repositoryName).camelCase}Repository;
''';
    final startIndex = fileContent.indexOf('class ${ReCase(controllerName).pascalCase}Controller extends GetxController {');
    final stopIndex = fileContent.indexOf('${ReCase(controllerName).pascalCase}Controller(', startIndex);
    fileContent = fileContent.substring(0, stopIndex) + defineServiceStatement + fileContent.substring(stopIndex);

    if (fileContent.contains('${ReCase(controllerName).pascalCase}Controller({')) {
      final startIndex = fileContent.indexOf('${ReCase(controllerName).pascalCase}Controller({');
      final stopIndex = fileContent.indexOf('})', startIndex);
      final constructRepositoryStatement = 'required this.${ReCase(repositoryName).camelCase}Repository,';
      fileContent = fileContent.substring(0, stopIndex) + constructRepositoryStatement + fileContent.substring(stopIndex);
    } else if (fileContent.contains('${ReCase(controllerName).pascalCase}Controller();')) {
      final startIndex = fileContent.indexOf('${ReCase(controllerName).pascalCase}Controller(');
      final stopIndex = fileContent.indexOf(');', startIndex);
      final constructRepositoryStatement = '{required this.${ReCase(repositoryName).camelCase}Repository,}';
      fileContent = fileContent.substring(0, stopIndex) + constructRepositoryStatement + fileContent.substring(stopIndex);
    }

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _configControllerBinding(
      String repositoryName,
      String controllerName,
      String moduleName,
      ) async {
    final filePath = 'lib/infrastructure/navigation/bindings/controllers/${ReCase(moduleName).snakeCase}_controller_binding.dart';

    final file = File(filePath);
    String fileContent = await file.readAsString();

    final startIndex = fileContent.indexOf('${ReCase(controllerName).pascalCase}Controller(');
    String pattern = '),\n    );';
    final stopIndex = fileContent.indexOf(pattern, startIndex);

    final insertIndex = stopIndex;
    final insertServiceStatement = '${ReCase(repositoryName).camelCase}Repository: Get.find(),';
    fileContent = fileContent.substring(0, insertIndex) + insertServiceStatement + fileContent.substring(insertIndex);

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }
}