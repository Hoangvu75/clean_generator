import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class CreateServiceCommand extends Command<void> {
  @override
  final name = 'create_service:';
  @override
  final description = 'Creates a new service.';

  CreateServiceCommand() {
    // The command will handle the parsing manually, so no need to addOption here.
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 1) {
      print('Usage: create_service: <service_name>');
      return;
    }

    final servicePart = argResults!.rest[0];

    final serviceName = servicePart;
    await _checkIsCreated(serviceName);
    await _execute(serviceName);
    await _addAccountServiceToExportServiceFile(serviceName);
    await _addServiceToInfrastructureConfigFile(serviceName);
    print('Service ${ReCase(serviceName).pascalCase}Service created');
  }

  Future<void> _checkIsCreated(String serviceName) async {
    final dirPath = 'lib/infrastructure/services';
    final fileName = ReCase(serviceName).snakeCase;
    final filePath = '$dirPath/${fileName}_service.dart';
    final file = File(filePath);
    if (await file.exists()) {
      throw Exception(
        'Service ${ReCase(serviceName).pascalCase}Service already exists',
      );
    }
  }

  Future<void> _execute(String serviceName) async {
    final dirPath = 'lib/infrastructure/services';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(serviceName).snakeCase;
    final className = ReCase(serviceName).pascalCase;

    final fileContent = '''
import 'package:get/get.dart';

class ${className}Service extends GetxService {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
''';

    final filePath = '$dirPath/${fileName}_service.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addAccountServiceToExportServiceFile(String serviceName) async {
    String dirPath = 'lib/infrastructure/services';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String filePath = '$dirPath/services.dart';
    File file = File(filePath);
    await file.writeAsString(
      "export '${ReCase(serviceName).snakeCase}_service.dart';",
      mode: FileMode.append,
    );
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addServiceToInfrastructureConfigFile(String serviceName) async {
    String filePath = 'lib/infrastructure/infrastructure_config.dart';

    File file = File(filePath);
    String fileContent = await file.readAsString();

    String newService = '''
    Get.put(${ReCase(serviceName).pascalCase}Service());
    ''';

    String searchPattern = 'static void serviceConfig() {';
    int insertIndex = fileContent.indexOf(searchPattern);

    if (insertIndex != -1) {
      insertIndex = fileContent.indexOf('}', insertIndex);
      String updatedContent =
          '${fileContent.substring(0, insertIndex)}$newService\n${fileContent.substring(insertIndex)}';
      await file.writeAsString(updatedContent);
      await Process.run('dart', ['format', filePath]);
    }
  }
}
