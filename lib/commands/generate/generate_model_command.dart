import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:recase/recase.dart';

class GenerateModelCommand extends Command<void> {
  @override
  final name = 'generate_model:';
  @override
  final description = 'Creates a new model.';

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty) {
      print('Usage: generate_model: <model_name>');
      return;
    }

    final modelName = argResults!.rest[0];
    print('Enter your sample model json: ');

    final modelJson = _readMultilineInput();
    await _generateModel(modelName, modelJson);

    print('Model ${ReCase(modelName).pascalCase} created');
  }

  String _readMultilineInput() {
    final lines = <String>[];
    while (true) {
      String? line = stdin.readLineSync();
      if (line == null || line.isEmpty) break;
      lines.add(line);
    }
    return lines.join('\n');
  }

  Future<void> _generateModel(String modelName, String json) async {
    final jsonMap = jsonDecode(json) as Map<String, dynamic>;
    final modelContent = _generateModelContent(modelName, jsonMap);

    final dirPath = 'lib/domain/entities/models';
    final directory = Directory(dirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final filePath = '$dirPath/${ReCase(modelName).snakeCase}.dart';
    final file = File(filePath);
    await file.writeAsString(modelContent);

    await Process.run('dart', ['format', filePath]);
  }

  String _generateModelContent(String modelName, Map<String, dynamic> jsonMap) {
    final buffer = StringBuffer();
    _generateClass(modelName, jsonMap, buffer);
    return buffer.toString();
  }

  void _generateClass(String className, Map<String, dynamic> jsonMap, StringBuffer buffer) {
    buffer.writeln('class ${ReCase(className).pascalCase} {');

    jsonMap.forEach((key, value) {
      if (value is Map) {
        final nestedClassName = ReCase(key).pascalCase;
        buffer.writeln('  $nestedClassName? ${ReCase(key).camelCase};');
      } else {
        buffer.writeln('  ${_dartType(value)}? ${ReCase(key).camelCase};');
      }
    });

    buffer.writeln();
    buffer.writeln('  ${ReCase(className).pascalCase}({');

    for (var key in jsonMap.keys) {
      buffer.writeln('    this.${ReCase(key).camelCase},');
    }

    buffer.writeln('  });');
    buffer.writeln();

    buffer.writeln('  factory ${ReCase(className).pascalCase}.fromJson(Map<String, dynamic> json) {');
    buffer.writeln('    return ${ReCase(className).pascalCase}(');
    jsonMap.forEach((key, value) {
      if (value is Map) {
        final nestedClassName = ReCase(key).pascalCase;
        buffer.writeln('      ${ReCase(key).camelCase}: $nestedClassName.fromJson(json[\'$key\']),');
      } else {
        buffer.writeln('      ${ReCase(key).camelCase}: json[\'$key\'],');
      }
    });
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  Map<String, dynamic> toJson() {');
    buffer.writeln('    return {');
    jsonMap.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('      \'$key\': ${ReCase(key).camelCase}?.toJson(),');
      } else {
        buffer.writeln('      \'$key\': ${ReCase(key).camelCase},');
      }
    });
    buffer.writeln('    };');
    buffer.writeln('  }');
    buffer.writeln('}');

    jsonMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        _generateClass(ReCase(key).pascalCase, value, buffer);
      }
    });
  }

  String _dartType(dynamic value) {
    if (value is String) {
      return 'String';
    } else if (value is int) {
      return 'int';
    } else if (value is double) {
      return 'double';
    } else if (value is bool) {
      return 'bool';
    } else if (value is List) {
      return 'List'; // For simplicity; you might need a more complex handling for lists
    } else {
      return 'dynamic';
    }
  }
}
