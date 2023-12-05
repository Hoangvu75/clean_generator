import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class CreateApiCommand extends Command<void> {
  @override
  final name = 'create_api:';
  @override
  final description = 'Creates a API based on an API client interface.';

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 3 || argResults!.rest[1].toLowerCase() != 'from') {
      print('Usage: create_api: <api_name> from <api_client_interface_name>');
      return;
    }

    final apiPart = argResults!.rest[0];
    final apiClientPart = argResults!.rest[2];

    final apiName = apiPart;
    final apiClientInterfaceName = apiClientPart;

    await _checkIfApiClientInterfaceExists(apiClientInterfaceName);
    await _checkIsApiCreated(apiName);
    await _createApiFile(apiName);
    await _createApiClientFile(apiName, apiClientInterfaceName);
    await _runBuildRunner();

    print('API ${ReCase(apiName).pascalCase} created successfully');
  }

  Future<void> _checkIfApiClientInterfaceExists(String apiClientInterfaceName) async {
    final dirPath = 'lib/data/source/api';
    final fileName = ReCase(apiClientInterfaceName).snakeCase;
    final filePath = '$dirPath/${fileName}_api_client_interface.dart';
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('${ReCase(apiClientInterfaceName).pascalCase}ApiClientInterface does not exist');
    }
  }

  Future<void> _checkIsApiCreated(String apiName) async {
    final dirPath = 'lib/data/source/api/${ReCase(apiName).snakeCase}';
    if (await Directory(dirPath).exists()) {
      throw Exception('${ReCase(apiName).pascalCase}Api already exists');
    }
  }

  Future<void> _createApiFile(String apiName) async {
    final dirPath = 'lib/data/source/api/${ReCase(apiName).snakeCase}';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(apiName).snakeCase;
    final className = ReCase(apiName).pascalCase;

    final fileContent = '''
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part '${fileName}_api.g.dart';

@RestApi()
abstract class ${className}Api {
  factory ${className}Api(Dio dio) = _AuthApi;
}
    ''';

    final filePath = '$dirPath/${fileName}_api.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createApiClientFile(String apiName, String apiClientInterfaceName) async {
    final dirPath = 'lib/data/source/api/${ReCase(apiName).snakeCase}';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(apiName).snakeCase;
    final className = ReCase(apiName).pascalCase;

    final fileContent = '''
import '${fileName}_api.dart';
import '../${ReCase(apiClientInterfaceName).snakeCase}_api_client_interface.dart';

class ${className}ApiClient extends ${ReCase(apiClientInterfaceName).pascalCase}ApiClientInterface {
  late final ${className}Api api;

  @override
  void onInit() {
    super.onInit();
    api = ${className}Api(dio);
  }
}
    ''';

    final filePath = '$dirPath/${fileName}_api_client.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _runBuildRunner() async {
    print('Running build_runner...');
    var buildRunner = await Process.run(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      runInShell: true,
    );
    print(buildRunner.stdout);
    print(buildRunner.stderr);
  }
}
