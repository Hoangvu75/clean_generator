import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:clean_generator/getx/commands/create/create_widget_command.dart';
import 'package:clean_generator/getx/commands/init/init_command.dart';

Future<void> onCommandReceive(List<String> arguments) async {
  var pubspecFile = File('pubspec.yaml');
  bool exists = await pubspecFile.exists();
  if (!exists) {
    print('pubspec.yaml not found!');
    return;
  }

  final runner = CommandRunner<void>('clean_generator', 'A simple Flutter CLI tool')
    ..addCommand(InitCommand())
    ..addCommand(CreateWidgetCommand());

  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });
}
