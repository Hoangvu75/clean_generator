import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class BindServiceCommand extends Command<void> {
  @override
  final name = 'bind_service:';
  @override
  final description = 'Bind a service to a controller';

  BindServiceCommand() {
    // The command will handle the parsing manually, so no need to addOption here.
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 5 ||
        argResults!.rest[1].toLowerCase() != 'on' ||
        argResults!.rest[3].toLowerCase() != 'of') {
      print('Usage: bind_service: <service_name> on <controller_name> of '
          '<module_name>');
      return;
    }

    final servicePart = argResults!.rest[0];
    final controllerPart = argResults!.rest[2];
    final modulePart = argResults!.rest[4];

    final serviceName = servicePart;
    final controllerName = controllerPart;
    final moduleName = modulePart;
    await _execute(serviceName, controllerName, moduleName);
    await _configControllerBinding(serviceName, controllerName, moduleName);

    print('Service ${ReCase(serviceName).pascalCase}Service binded '
        'to ${ReCase(controllerName).pascalCase}Controller');
  }

  Future<void> _execute(
    String serviceName,
    String controllerName,
    String moduleName,
  ) async {
    final filePath = 'lib/presentation/${ReCase(moduleName).snakeCase}/controllers/${ReCase(controllerName).snakeCase}_controller.dart';
    final file = File(filePath);
    String fileContent = await file.readAsString();

    if (!fileContent.contains("import '../../../infrastructure/services/services.dart';")) {
      final importStatement = "import '../../../infrastructure/services/services.dart';";
      final importIndex = fileContent.lastIndexOf("import ");
      final importEndIndex = fileContent.indexOf(';\n', importIndex) + 1;
      fileContent = fileContent.substring(0, importEndIndex) + importStatement + fileContent.substring(importEndIndex);
    }

    final defineServiceStatement = '''
    final ${ReCase(serviceName).pascalCase}Service ${ReCase(serviceName).camelCase}Service;
''';
    final startIndex = fileContent.indexOf('class ${ReCase(controllerName).pascalCase}Controller extends GetxController {');
    final stopIndex = fileContent.indexOf('${ReCase(controllerName).pascalCase}Controller(', startIndex);
    fileContent = fileContent.substring(0, stopIndex) + defineServiceStatement + fileContent.substring(stopIndex);

    if (fileContent.contains('${ReCase(controllerName).pascalCase}Controller({')) {
      final startIndex = fileContent.indexOf('${ReCase(controllerName).pascalCase}Controller({');
      final stopIndex = fileContent.indexOf('})', startIndex);
      final constructServiceStatement = 'required this.${ReCase(serviceName).camelCase}Service,';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    } else if (fileContent.contains('${ReCase(controllerName).pascalCase}Controller();')) {
      final startIndex = fileContent.indexOf('${ReCase(controllerName).pascalCase}Controller(');
      final stopIndex = fileContent.indexOf(');', startIndex);
      final constructServiceStatement = '{required this.${ReCase(serviceName).camelCase}Service,}';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    }

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _configControllerBinding(
    String serviceName,
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
    final insertServiceStatement = '${ReCase(serviceName).camelCase}Service: Get.find(),';
    fileContent = fileContent.substring(0, insertIndex) + insertServiceStatement + fileContent.substring(insertIndex);

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }
}
