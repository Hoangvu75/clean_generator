import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class GenerateApiRequestCommand extends Command<void> {
  @override
  final name = 'generate_api_request:';
  @override
  final description = 'Generate API Request on an API Client';

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty) {
      print('Usage: generate_api_request: <api_name>');
      return;
    }

    final apiName = argResults!.rest[0];
    await _checkIfApiExist(apiName);

    print('Enter your function name:');
    final functionName = stdin.readLineSync()!;

    await _generateApi(apiName, functionName);
    await _runBuildRunner();

    print('API Request generated successfully');
  }

  Future<void> _checkIfApiExist(String apiName) async {
    final dir = 'lib/data/source/api/${ReCase(apiName).snakeCase}';
    final directory = Directory(dir);
    if (!await directory.exists()) {
      throw Exception('API ${ReCase(apiName).pascalCase} does not exist');
    }
  }

  Future<void> _generateApi(String apiName, String functionName) async {
    final apiNameSnakeCase = ReCase(apiName).snakeCase;
    String filePath = 'lib/data/source/api/$apiNameSnakeCase/${apiNameSnakeCase}_api.dart';
    final file = File(filePath);
    String fileContent = await file.readAsString();

    print('Enter your API method (GET, POST, etc...):');
    final method = stdin.readLineSync()!;
    if (method != 'GET' &&
        method != 'POST' &&
        method != 'PUT' &&
        method != 'DELETE' &&
        method != 'PATCH') {
      throw Exception('Invalid method');
    }

    print('\nEnter your API endpoint:');
    print('Example: /login/');
    print('(If your endpoint has a path parameter, replace it with {parameter_name}. Example: /profile/{userIdx})');
    final endpoint = stdin.readLineSync()!;
    if (endpoint.isEmpty) {
      throw Exception('Invalid endpoint');
    }

    List<String> pathParameters = [];
    RegExp pathParamRegex = RegExp(r'\{([^}]+)\}');
    Iterable<RegExpMatch> matches = pathParamRegex.allMatches(endpoint);
    for (var match in matches) {
      String pathParameter = match.group(1)!; // Group 1 is the content inside the curly braces
      pathParameters.add(pathParameter);
    }

    print('Does your API request has a body? (y/n)');
    final hasBody = stdin.readLineSync()!;

    print('Does your API request has a query? (y/n)');
    final hasQuery = stdin.readLineSync()!;

    print('Enter the name of api response model that you want to use (it must be created before):');
    final apiResponseModelName = stdin.readLineSync()!;
    final importStatement = "import '../../../../domain/entities/api_responses/${apiResponseModelName}_response.dart';";
    final importIndex = fileContent.lastIndexOf("import ");
    final importEndIndex = fileContent.indexOf(';\n', importIndex) + 2;
    fileContent = fileContent.substring(0, importEndIndex) + importStatement + fileContent.substring(importEndIndex);

    String newApiRequest = '''
  @$method("$endpoint")
  Future<${ReCase(apiResponseModelName).pascalCase}Response> $functionName();
  ''';

    if (hasBody == 'y') {
      final paramEndIndex = newApiRequest.lastIndexOf(')');
      final bodyParam = '@Body() Map<String, dynamic> body,';
      String beforeParam = newApiRequest.substring(0, paramEndIndex);
      String afterParam = newApiRequest.substring(paramEndIndex);
      newApiRequest = beforeParam + bodyParam + afterParam;
    }

    if (hasQuery == 'y') {
      final paramEndIndex = newApiRequest.lastIndexOf(')');
      final queryParam = '@Queries() Map<String, dynamic> queries,';
      String beforeParam = newApiRequest.substring(0, paramEndIndex);
      String afterParam = newApiRequest.substring(paramEndIndex);
      newApiRequest = beforeParam + queryParam + afterParam;
    }

    if (pathParameters.isNotEmpty) {
      final paramEndIndex = newApiRequest.lastIndexOf(')');
      String pathParams = '';
      for (var pathParameter in pathParameters) {
        pathParams += '@Path("$pathParameter") String $pathParameter,';
      }
      String beforeParam = newApiRequest.substring(0, paramEndIndex);
      String afterParam = newApiRequest.substring(paramEndIndex);
      newApiRequest = beforeParam + pathParams + afterParam;
    }

    final endIndex = fileContent.lastIndexOf('}');
    String before = fileContent.substring(0, endIndex);
    String after = fileContent.substring(endIndex);
    newApiRequest = before + newApiRequest + after;

    await file.writeAsString(newApiRequest);
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
