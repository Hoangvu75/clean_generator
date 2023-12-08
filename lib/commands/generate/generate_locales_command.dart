import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class GenerateLocalesCommand extends Command<void> {
  @override
  final name = 'generate_locales:';
  @override
  final description = 'Creates locale files.';

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty) {
      print('Usage: generate_locales: <locale_folder_dir>');
      return;
    }

    final localeFolder = argResults!.rest[0];
    await _checkIfLocaleFolderExists(localeFolder);
    await _generateLocale(localeFolder);
  }

  Future<void> _checkIfLocaleFolderExists(String localeFolderPath) async {
    final directory = Directory(localeFolderPath);
    if (!await directory.exists()) {
      throw Exception('Locale folder $localeFolderPath does not exist');
    }
  }

  Future<void> _generateLocale(String localeFolderPath) async {
    final dir = Directory(localeFolderPath);
    final files = await dir.list().toList();
    final localeMap = <String, dynamic>{};
    for (final file in files) {
      final fileName = file.path.split('/').last;
      final localeName = fileName.split('.').first;
      final fileContent = await File(file.path).readAsString();
      final jsonMap = jsonDecode(fileContent) as Map<String, dynamic>;
      localeMap[localeName] = jsonMap;
    }

    final localeContent = await _generateLocaleContent(localeMap);
    final filePath = 'lib/core/locales/locales.dart';
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(localeContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<String> _generateLocaleContent(Map<String, dynamic> localeMap) async {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('class AppTranslation {');
    buffer.writeln('  static Map<String, Map<String, String>> translations = {');
    localeMap.forEach((localeName, jsonMap) {
      buffer.writeln('    \'$localeName\': Locales.$localeName,');
    });
    buffer.writeln('  };');
    buffer.writeln('}\n');

    buffer.writeln('class LocaleKeys {');
    buffer.writeln('  LocaleKeys._();');

    final firstLocaleMap = localeMap.values.first as Map<String, dynamic>;
    _generateKeys(firstLocaleMap, buffer);

    buffer.writeln('}\n');

    buffer.writeln('class Locales {');
    localeMap.forEach((localeName, jsonMap) {
      buffer.writeln('  static const $localeName = ${_generateMapContent(jsonMap)};');
    });
    buffer.writeln('}');

    return buffer.toString();
  }

  void _generateKeys(Map<String, dynamic> jsonMap, StringBuffer buffer, [String prefix = '']) {
    jsonMap.forEach((key, value) {
      final String keyName = prefix + key; // keep original key format
      if (value is Map<String, dynamic>) {
        _generateKeys(value, buffer, keyName + '_');
      } else {
        buffer.writeln('  static const $keyName = \'$keyName\';');
      }
    });
  }

  String _generateMapContent(dynamic jsonValue, [String parentKey = '']) {
    final buffer = StringBuffer();
    buffer.write('{\n');

    if (jsonValue is Map<String, dynamic>) {
      jsonValue.forEach((key, value) {
        final fullKey = parentKey.isEmpty ? key : '${parentKey}_$key';
        final escapedKey = fullKey.replaceAll('\'', '\\\'');

        if (value is String) {
          final escapedValue = value.replaceAll('\'', '\\\'').replaceAll('\n', '\\n');
          buffer.write('    \'$escapedKey\': \'$escapedValue\',\n');
        } else if (value is Map<String, dynamic>) {
          buffer.write(_generateMapContent(value, fullKey).replaceAll('{', '').replaceAll('}', ''));
        } else {
          buffer.write('    \'$escapedKey\': \'$value\',\n');
        }
      });
    }

    buffer.write('  }');
    return buffer.toString();
  }
}