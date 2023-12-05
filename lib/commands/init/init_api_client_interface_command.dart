import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class InitApiClientInterfaceCommand extends Command<void> {
  @override
  final name = 'init_api_client_interface';
  @override
  final description = 'Initialize api client.';

  @override
  Future<void> run() async {
    print('Enter API client interface name:');
    String? apiClientInterfaceName = stdin.readLineSync();
    if (apiClientInterfaceName == null) {
      throw Exception(
        "API client interface name can't be null",
      );
    }
    await _checkIfApiClientInterfaceExist(apiClientInterfaceName);
    print('Enter base url:');
    String? baseUrl = stdin.readLineSync();
    if (baseUrl == null) {
      throw Exception(
        "API client interface name can't be null",
      );
    }
    await _execute(apiClientInterfaceName, baseUrl);
    await _addNecessaryDependencies();
    print('${ReCase(apiClientInterfaceName).pascalCase}ApiClientInterface created');
  }

  Future<void> _addNecessaryDependencies() async {
    final pubspecFile = File('pubspec.yaml');
    if (!await pubspecFile.exists()) {
      throw Exception(
        'pubspec.yaml file not found',
      );
    }
    final pubspecContent = await pubspecFile.readAsString();
    if (!pubspecContent.contains('retrofit:')
        || !pubspecContent.contains('dio:')
        || !pubspecContent.contains('pretty_dio_logger:')
        || !pubspecContent.contains('json_annotation:')
        || !pubspecContent.contains('build_runner:')
        || !pubspecContent.contains('json_serializable:')
        || !pubspecContent.contains('retrofit_generator:')
    ) {
      print('Adding required dependencies...');
      var appDependencies = await Process.run(
        'flutter',
        [
          'pub',
          'add',
          'retrofit',
          'dio',
          'pretty_dio_logger',
          'json_annotation'
        ],
        runInShell: true,
      );
      print(appDependencies.stdout);
      print(appDependencies.stderr);

      var devDependencies = await Process.run(
        'flutter',
        [
          'pub',
          'add',
          '--dev',
          'build_runner',
          'json_serializable',
          'retrofit_generator'
        ],
        runInShell: true,
      );
      print(devDependencies.stdout);
      print(devDependencies.stderr);
    }
  }

  Future<void> _checkIfApiClientInterfaceExist(String apiClientInterfaceName) async {
    final dirPath = 'lib/data/source/api';
    final fileName = ReCase(apiClientInterfaceName).snakeCase;
    final filePath = '$dirPath/${fileName}_api_client_interface.dart';
    final file = File(filePath);
    if (await file.exists()) {
      throw Exception(
        'This API client interface already exist',
      );
    }
  }

  Future<void> _execute(String apiClientInterfaceName, String baseUrl) async {
    final dirPath = 'lib/data/source/api';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(apiClientInterfaceName).snakeCase;
    final className = ReCase(apiClientInterfaceName).pascalCase;

    final fileContent = '''
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class ${className}ApiClientInterface extends GetxService {
  late final Dio dio;
  late final String baseURL;

  @override
  void onInit() {
    super.onInit();
    baseURL = "$baseUrl";
    dio = Dio();
    dio.options = BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status! < 500;
      },
      contentType: Headers.jsonContentType,
    );
    dio.interceptors
      ..add(
        PrettyDioLogger(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      )
      ..add(
        InterceptorsWrapper(
          onRequest: (
            RequestOptions options,
            RequestInterceptorHandler handler,
          ) {
            final token = "";
            if (token != null) {
              options.headers['Authorization'] = "Bearer \$token";
            }
            handler.next(options);
          },
          onError: (
            DioException exception,
            ErrorInterceptorHandler handler,
          ) {
            throw exception;
          },
        ),
      );
  }
}
''';

    final filePath = '$dirPath/${fileName}_api_client_interface.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }
}
