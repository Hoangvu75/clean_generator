import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class CreateRepositoryCommand extends Command<void> {
  @override
  final name = 'create_repository:';
  @override
  final description = 'Creates a new repository and repository implement.';

  @override
  Future<void> run() async {
    if (argResults!.rest.length != 1) {
      print('Usage: create_repository: <repository_name>');
      return;
    }

    final repositoryPart = argResults!.rest[0];
    final repositoryName = repositoryPart;
    await _checkIsCreated(repositoryName);
    await _createInterface(repositoryName);
    await _createImplementation(repositoryName);
    await _addRepositoryToExportFile(repositoryName);
    await _addRepositoryToDomainConfigFile(repositoryName);

    print('Repository ${ReCase(repositoryName).pascalCase}Repository created');
  }

  Future<void> _checkIsCreated(String repositoryName) async {
    final dirPath = 'lib/domain/repositories';
    final fileName = ReCase(repositoryName).snakeCase;
    final filePath = '$dirPath/${fileName}_widget.dart';
    final file = File(filePath);
    if (await file.exists()) {
      throw Exception(
        'Repository ${ReCase(repositoryName).pascalCase}Repository already exists',
      );
    }
  }

  Future<void> _createInterface(String repositoryName) async {
    final dirPath = 'lib/domain/repositories';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = ReCase(repositoryName).snakeCase;
    final className = ReCase(repositoryName).pascalCase;

    final fileContent = '''
import '../../data/repository_impl/${fileName}_repository_impl.dart';

abstract class ${className}Repository {
  factory ${className}Repository() = ${className}RepositoryImpl;
}
''';

    final filePath = '$dirPath/${fileName}_repository.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createImplementation(String repositoryName) async {
    final dirPath = 'lib/data/repository_impl';
    final directory = Directory(dirPath);
    await directory.create(recursive: true);

    final fileName = ReCase(repositoryName).snakeCase;
    final className = ReCase(repositoryName).pascalCase;

    final fileContent = '''
import '../../domain/repositories/${fileName}_repository.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  ${className}RepositoryImpl();
}
''';

    final filePath = '$dirPath/${fileName}_repository_impl.dart';
    final file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addRepositoryToExportFile(String repositoryName) async {
    String dirPath = 'lib/domain/repositories';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String filePath = '$dirPath/repositories.dart';
    File file = File(filePath);
    await file.writeAsString(
      "export '${ReCase(repositoryName).snakeCase}_repository.dart';",
      mode: FileMode.append,
    );
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addRepositoryToDomainConfigFile(String repositoryName) async {
    String filePath = 'lib/domain/domain_config.dart';

    File file = File(filePath);
    String fileContent = await file.readAsString();

    String newRepository = '''
    Get.lazyPut(() => ${ReCase(repositoryName).pascalCase}Repository(),);
    ''';

    String searchPattern = 'static void repositoryConfig() {';
    int insertIndex = fileContent.indexOf(searchPattern);

    if (insertIndex != -1) {
      insertIndex = fileContent.indexOf('}', insertIndex);
      String updatedContent = '${fileContent.substring(0, insertIndex)}$newRepository\n${fileContent.substring(insertIndex)}';
      await file.writeAsString(updatedContent);
      await Process.run('dart', ['format', filePath]);
    }
  }
}