import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class BindApiClientToRepositoryCommand extends Command<void> {
  @override
  final name = 'bind_api_client:';
  @override
  final description = 'Bind an API client to a repository';

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 3 ||
        argResults!.rest[1].toLowerCase() != 'on') {
      print('Usage: bind_api_client: <api_name> on <repository_name>');
      return;
    }

    final apiPart = argResults!.rest[0];
    final repositoryPart = argResults!.rest[2];

    final apiName = apiPart;
    final repositoryName = repositoryPart;

    await _checkIfApiExist(apiName);
    await _checkIfRepositoryExist(repositoryName);
    await _checkIfIsBinded(apiName, repositoryName);

    await _configRepositoryFile(apiName, repositoryName);
    await _addApiImportToRepository(apiName, repositoryName);
    await _configRepositoryImplFile(apiName, repositoryName);
    await _configDomainConfigFile(apiName, repositoryName);

    print('${ReCase(apiName).pascalCase}ApiClient binded to '
        '${ReCase(repositoryName).pascalCase}Repository');
  }

  Future<void> _checkIfApiExist(String apiName) async {
    final dirPath = 'lib/data/source/api/${ReCase(apiName).snakeCase}';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      throw Exception('API $apiName does not exist');
    }
  }

  Future<void> _checkIfRepositoryExist(String repositoryName) async {
    final dirPath = 'lib/domain/repositories';
    final fileName = ReCase(repositoryName).snakeCase;
    final filePath = '$dirPath/${fileName}_repository.dart';
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception(
        'Repository ${ReCase(repositoryName).pascalCase}Repository does not exist',
      );
    }
  }

  Future<void> _checkIfIsBinded(
    String apiName,
    String repositoryName,
  ) async {
    final dirPath = 'lib/domain/repositories';
    final fileName = ReCase(repositoryName).snakeCase;
    final filePath = '$dirPath/${fileName}_repository.dart';
    final file = File(filePath);
    final fileContent = await file.readAsString();
    final isBinded = fileContent.contains(
      'required ${ReCase(apiName).pascalCase}ApiClient ${ReCase(apiName).camelCase}ApiClient,',
    );
    if (isBinded) {
      throw Exception(
        '${ReCase(apiName).pascalCase}ApiClient is already binded to '
        '${ReCase(repositoryName).pascalCase}Repository',
      );
    }
  }

  Future<void> _configRepositoryFile(
    String apiName,
    String repositoryName,
  ) async {
    final dirPath = 'lib/domain/repositories';
    final fileName = ReCase(repositoryName).snakeCase;
    final filePath = '$dirPath/${fileName}_repository.dart';
    final file = File(filePath);
    String fileContent = await file.readAsString();

    if (fileContent.contains('factory ${ReCase(repositoryName).pascalCase}Repository()')) {
      final startIndex = fileContent.indexOf('${ReCase(repositoryName).pascalCase}Repository(');
      final stopIndex = fileContent.indexOf(')', startIndex);
      final constructServiceStatement = '{required ${ReCase(apiName).pascalCase}ApiClient ${ReCase(apiName).camelCase}ApiClient,}';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    } else if (fileContent.contains('factory ${ReCase(repositoryName).pascalCase}Repository({')) {
      final startIndex = fileContent.indexOf('${ReCase(repositoryName).pascalCase}Repository({');
      final stopIndex = fileContent.indexOf('})', startIndex);
      final constructServiceStatement = 'required ${ReCase(apiName).pascalCase}ApiClient ${ReCase(apiName).camelCase}ApiClient,';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    }

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addApiImportToRepository(
    String apiName,
    String repositoryName,
  ) async {
    final dirPath = 'lib/domain/repositories';
    final fileName = ReCase(repositoryName).snakeCase;
    final filePath = '$dirPath/${fileName}_repository.dart';
    final file = File(filePath);
    String fileContent = await file.readAsString();

    final importStatement = "import '../../data/source/api/${ReCase(apiName).snakeCase}/${ReCase(apiName).snakeCase}_api_client.dart';\n";
    final importIndex = fileContent.lastIndexOf("import ");
    final importEndIndex = fileContent.indexOf(';\n', importIndex) + 1;
    fileContent = fileContent.substring(0, importEndIndex) + importStatement + fileContent.substring(importEndIndex);

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _configRepositoryImplFile(
    String apiName,
    String repositoryName,
  ) async {
    final dirPath = 'lib/data/repository_impl';
    final fileName = ReCase(repositoryName).snakeCase;
    final filePath = '$dirPath/${fileName}_repository_impl.dart';
    final file = File(filePath);
    String fileContent = await file.readAsString();

    if (!fileContent.contains("import '../source/sources.dart';")) {
      final importStatement = "import '../source/sources.dart';";
      final importIndex = fileContent.lastIndexOf("import ");
      final importEndIndex = fileContent.indexOf(';\n', importIndex) + 1;
      fileContent = fileContent.substring(0, importEndIndex) + importStatement + fileContent.substring(importEndIndex);
    }

    final defineApiStatement = '''
    final ${ReCase(apiName).pascalCase}ApiClient ${ReCase(apiName).camelCase}ApiClient;
''';
    final startIndex = fileContent.indexOf('class ${ReCase(repositoryName).pascalCase}RepositoryImpl implements ${ReCase(repositoryName).pascalCase}Repository {');
    final stopIndex = fileContent.indexOf('${ReCase(repositoryName).pascalCase}RepositoryImpl(', startIndex);
    fileContent = fileContent.substring(0, stopIndex) + defineApiStatement + fileContent.substring(stopIndex);

    if (fileContent.contains('${ReCase(repositoryName).pascalCase}RepositoryImpl();')) {
      final startIndex = fileContent.indexOf('${ReCase(repositoryName).pascalCase}RepositoryImpl(');
      final stopIndex = fileContent.indexOf(');', startIndex);
      final constructServiceStatement = '{required this.${ReCase(apiName).camelCase}ApiClient,}';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    } else if (fileContent.contains('${ReCase(repositoryName).pascalCase}RepositoryImpl({')) {
      final startIndex = fileContent.indexOf('${ReCase(repositoryName).pascalCase}RepositoryImpl({');
      final stopIndex = fileContent.indexOf('});', startIndex);
      final constructServiceStatement = 'required this.${ReCase(apiName).camelCase}ApiClient,';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    }

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _configDomainConfigFile(
    String apiName,
    String repositoryName,
  ) async {
    final dirPath = 'lib/domain/domain_config.dart';
    final file = File(dirPath);
    String fileContent = await file.readAsString();

    if (fileContent.contains('${ReCase(repositoryName).pascalCase}Repository()')) {
      final startIndex = fileContent.indexOf('${ReCase(repositoryName).pascalCase}Repository(');
      final stopIndex = fileContent.indexOf('),', startIndex);
      final constructServiceStatement = '${ReCase(apiName).camelCase}ApiClient: Get.find(),';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    } else {
      final startIndex = fileContent.indexOf('${ReCase(repositoryName).pascalCase}Repository(');
      String pattern = '),\n    );';
      final stopIndex = fileContent.indexOf(pattern, startIndex);
      final constructServiceStatement = '${ReCase(apiName).camelCase}ApiClient: Get.find(),';
      fileContent = fileContent.substring(0, stopIndex) + constructServiceStatement + fileContent.substring(stopIndex);
    }

    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', dirPath]);
  }
}
