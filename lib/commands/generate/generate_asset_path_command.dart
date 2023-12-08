import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class GenerateAssetPath extends Command<void> {
  @override
  final name = 'generate_asset_path:';
  @override
  final description = "Generate variable of asset's path.";

  @override
  Future<void> run() async {
    var startTime = DateTime.now();
    if (argResults!.rest.isEmpty) {
      print('Usage: generate_asset_path: <asset_folder_dir>');
      return;
    }

    final assetFolder = argResults!.rest[0];
    await _checkIfAssetFolderExists(assetFolder);
    await _generateAssetPath(assetFolder);

    var endTime = DateTime.now();
    var difference = endTime.difference(startTime);
    print('Asset path generated successfully.');
    print('Finished in ${difference.inMilliseconds}ms.');
  }

  Future<void> _checkIfAssetFolderExists(String assetFolderPath) async {
    final directory = Directory(assetFolderPath);
    if (!await directory.exists()) {
      throw Exception('Asset folder $assetFolderPath does not exist');
    }
  }

  Future<void> _generateAssetPath(String assetFolderPath) async {
    final dir = Directory(assetFolderPath);
    final files = await dir.list().toList();

    final folderName = assetFolderPath.split('/').last;
    final assetClassesContent = _generateAssetFileContent(files, folderName);

    final assetClassesPath = 'lib/core/asset_path/asset_${folderName}_path.dart';
    final assetClassesFile = File(assetClassesPath);
    if (!await assetClassesFile.exists()) {
      await assetClassesFile.create(recursive: true);
    }
    await assetClassesFile.writeAsString(assetClassesContent);
    await Process.run('dart', ['format', assetClassesPath]);
  }

  String _generateAssetFileContent(List<FileSystemEntity> assetFiles, String folderName) {
    final buffer = StringBuffer();
    buffer.writeln('// ignore_for_file: constant_identifier_names');
    buffer.writeln('// ignore_for_file: prefer_const_constructors');
    buffer.writeln('// ignore_for_file: prefer_const_literals_to_create_immutables');
    buffer.writeln('// ignore_for_file: unused_import');
    buffer.writeln('');
    buffer.writeln('class Asset${ReCase(folderName).pascalCase}Path {');
    for (final file in assetFiles) {
      final fileName = file.path.split('/').last;
      final assetName = fileName.split('.').first;
      buffer.writeln('  static const $assetName = "${file.path}";');
    }
    buffer.writeln('}');
    return buffer.toString();
  }
}
