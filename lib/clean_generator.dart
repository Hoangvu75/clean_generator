import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:clean_generator/commands/bind/bind_api_client_to_repository_command.dart';
import 'package:clean_generator/commands/bind/bind_repository_to_a_controller_command.dart';
import 'package:clean_generator/commands/bind/bind_service_to_controller_command.dart';
import 'package:clean_generator/commands/create/create_api_command.dart';
import 'package:clean_generator/commands/create/create_controller_command.dart';
import 'package:clean_generator/commands/create/create_module_command.dart';
import 'package:clean_generator/commands/create/create_repository_command.dart';
import 'package:clean_generator/commands/create/create_service_command.dart';
import 'package:clean_generator/commands/generate/generate_api_request_command.dart';
import 'package:clean_generator/commands/generate/generate_api_response_command.dart';
import 'package:clean_generator/commands/generate/generate_asset_path_command.dart';
import 'package:clean_generator/commands/generate/generate_locales_command.dart';
import 'package:clean_generator/commands/generate/generate_model_command.dart';
import 'package:clean_generator/commands/init/init_api_client_interface_command.dart';

import 'commands/create/create_widget_command.dart';
import 'commands/init/init_command.dart';

Future<void> onCommandReceive(List<String> arguments) async {
  var pubspecFile = File('pubspec.yaml');
  bool exists = await pubspecFile.exists();
  if (!exists) {
    print('pubspec.yaml not found!');
    return;
  }

  final runner =
      CommandRunner<void>('clean_generator', 'A simple Flutter CLI tool')
        ..addCommand(InitCommand())
        ..addCommand(CreateModuleCommand())
        ..addCommand(CreateWidgetCommand())
        ..addCommand(CreateControllerCommand())
        ..addCommand(CreateServiceCommand())
        ..addCommand(CreateRepositoryCommand())
        ..addCommand(GenerateModelCommand())
        ..addCommand(GenerateApiResponseCommand())
        ..addCommand(BindServiceToControllerCommand())
        ..addCommand(InitApiClientInterfaceCommand())
        ..addCommand(CreateApiCommand())
        ..addCommand(GenerateApiRequestCommand())
        ..addCommand(BindApiClientToRepositoryCommand())
        ..addCommand(BindRepositoryToControllerCommand())
        ..addCommand(GenerateLocalesCommand())
        ..addCommand(GenerateAssetPath());

  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });
}
