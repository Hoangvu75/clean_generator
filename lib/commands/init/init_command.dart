import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:clean_generator/extensions/string_extension.dart';

class InitCommand extends Command<void> {
  @override
  final name = 'init';
  @override
  final description = 'Initialize GetX Flutter project with Clean architecture.';

  @override
  Future<void> run() async {
    if (!await isFolderEmpty('lib')) {
      print('Your lib is not empty. Do you want to over-write on it?');
      print('[1]: Yes');
      print('[2]: No');
      String? choice = stdin.readLineSync();
      int? choiceInInt = int.parse(choice!);
      if (choiceInInt == 2) return;
      deleteEverythingInFolder('lib');
    }
    await addNecessaryDependencies();
    await generateProjectStructure();
  }

  Future<void> addNecessaryDependencies() async {
    print('Adding required dependencies...');
    var appDependencies = await Process.run(
      'flutter',
      [
        'pub',
        'add',
        'get',
      ],
      runInShell: true,
    );
    print(appDependencies.stdout);
    print(appDependencies.stderr);
  }

  Future<void> generateProjectStructure() async {
    print('Generating project folder...');

    List<String> folders = [
      'lib/core/extensions',
      'lib/core/ui',
      'lib/core/utils',
      'lib/data/repository_impl',
      'lib/data/source/api',
      'lib/data/source/local',
      'lib/domain/entities/models',
      'lib/domain/entities/api_responses',
      'lib/domain/repositories',
      'lib/infrastructure/navigation/bindings/controllers',
      'lib/infrastructure/navigation/bindings/domains',
      'lib/infrastructure/services',
    ];

    for (String folder in folders) {
      await Directory(folder).create(recursive: true);
    }

    await _createMainDartFile();
    await _createRoutesFile();
    await _createNavigationFile();
    await _createServicesFile();
    await _createRepositoriesFile();
    await _createSourcesFile();
    await _createInfrastructureConfigFile();
    await _createDomainConfigFile();
    await _createDataConfigFile();

    await _createSampleModule();
    await _addSampleRouteToNavigation();
    await _addSampleRouteToRoutesClass();
    await _addSampleControllerBindingToExportControllerBindingFile();
    await _addSampleScreenToExportScreenFile();

    print('Project structure generated successfully.');
  }

  Future<void> _createMainDartFile() async {
    String fileContent = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/data_config.dart';
import 'infrastructure/infrastructure_config.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'domain/domain_config.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  DataConfig.init();
  DomainConfig.init();
  InfrastructureConfig.init();

  GetMaterialApp getMaterialApp = GetMaterialApp(
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    initialRoute: await Routes.initialRoute,
    getPages: Nav.routes,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
      );
    },
  );

  runApp(getMaterialApp);
}
''';

    String filePath = 'lib/main.dart';
    File file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createRoutesFile() async {
    String dirPath = 'lib/infrastructure/navigation';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String fileContent = '''
class Routes {
  static Future<String> get initialRoute async {
    // TODO: implement method
    return HOME;
  }

}
''';

    String filePath = '$dirPath/routes.dart';
    File file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createNavigationFile() async {
    String dirPath = 'lib/infrastructure/navigation';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String fileContent = '''
import 'package:get/get.dart';

import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class Nav {
  static List<GetPage> routes = [

  ];
}
''';

    String filePath = '$dirPath/navigation.dart';
    File file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createServicesFile() async {
    String dirPath = 'lib/infrastructure/services';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);
    String filePath = '$dirPath/services.dart';
    File file = File(filePath);
    file.writeAsString("");
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createRepositoriesFile() async {
    String dirPath = 'lib/domain/repositories';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);
    String filePath = '$dirPath/repositories.dart';
    File file = File(filePath);
    file.writeAsString("");
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createSourcesFile() async {
    String dirPath = 'lib/data/source';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);
    String filePath = '$dirPath/sources.dart';
    File file = File(filePath);
    file.writeAsString("");
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createInfrastructureConfigFile() async {
    String dirPath = 'lib/infrastructure';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String fileContent = '''
import 'package:get/get.dart';

import 'services/services.dart';

class InfrastructureConfig {
  static void init() {
    serviceConfig();
  }

  static void serviceConfig() {

  }
}
''';

    String filePath = '$dirPath/infrastructure_config.dart';
    File file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createDomainConfigFile() async {
    String dirPath = 'lib/domain';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String fileContent = '''
import 'package:get/get.dart';

import 'repositories/repositories.dart';

class DomainConfig {
  static void init() {
    repositoryConfig();
  }

  static void repositoryConfig() {

  }
}
''';

    String filePath = '$dirPath/domain_config.dart';
    File file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _createDataConfigFile() async {
    String dirPath = 'lib/data';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String fileContent = '''
import 'package:get/get.dart';

import 'source/sources.dart';

class DataConfig {
  static Future<void> init() async {
    apiDataSourceConfig();
    localDataSourceConfig();
    socketDataSourceConfig();
  }

  static void apiDataSourceConfig() {
  }

  static void localDataSourceConfig() {
  }

  static void socketDataSourceConfig() {
  }
}
''';

    String filePath = '$dirPath/data_config.dart';
    File file = File(filePath);
    await file.writeAsString(fileContent);
    await Process.run('dart', ['format', filePath]);
}

  Future<void> _createSampleModule() async {
    var moduleName = 'home';

    // create module widget

    String widgetDirPath = 'lib/presentation/${moduleName.toLowerCase()}/widgets';
    Directory widgetDirectory = Directory(widgetDirPath);
    await widgetDirectory.create(recursive: true);

    String widgetFileContent = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/${moduleName.toLowerCase()}_controller.dart';

class ${moduleName.capitalize()}Widget extends GetWidget<${moduleName.capitalize()}Controller> {
  const ${moduleName.capitalize()}Widget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${moduleName.capitalize()}Widget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '${moduleName.capitalize()}Widget is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
''';

    String widgetFilePath = '$widgetDirPath/${moduleName.toLowerCase()}_widget.dart';
    File widgetFile = File(widgetFilePath);
    await widgetFile.writeAsString(widgetFileContent);
    await Process.run('dart', ['format', widgetFilePath]);

    // create module controller

    String controllerDirPath = 'lib/presentation/${moduleName.toLowerCase()}/controllers';
    Directory controllerDirectory = Directory(controllerDirPath);
    await controllerDirectory.create(recursive: true);

    String controllerFileContent = '''
import 'package:get/get.dart';

class ${moduleName.capitalize()}Controller extends GetxController {
  ${moduleName.capitalize()}Controller();
  
  final count = 0.obs;
  
  @override
  void onInit() {
    //TODO: Implement SettingsController
    super.onInit();
  }

  @override
  void onReady() {
    //TODO: Implement SettingsController
    super.onReady();
  }

  @override
  void onClose() {
    //TODO: Implement SettingsController
    super.onClose();
  }

  void increment() => count.value++;
}
''';

    String controllerFilePath = '$controllerDirPath/${moduleName.toLowerCase()}_controller.dart';
    File controllerFile = File(controllerFilePath);
    await controllerFile.writeAsString(controllerFileContent);
    await Process.run('dart', ['format', controllerFilePath]);

    // create module controller binding

    String controllerBindingDirPath = 'lib/infrastructure/navigation/bindings/controllers';
    Directory controllerBindingDirectory = Directory(controllerBindingDirPath);
    await controllerBindingDirectory.create(recursive: true);

    String controllerBindingFileContent = '''
import 'package:get/get.dart';

import '../../../../presentation/${moduleName.toLowerCase()}/controllers/${moduleName.toLowerCase()}_controller.dart';

class ${moduleName.capitalize()}ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ${moduleName.capitalize()}Controller(),
    );
  }
}
''';

    String controllerBindingFilePath = '$controllerBindingDirPath/${moduleName.toLowerCase()}_controller_binding.dart';
    File controllerBindingFile = File(controllerBindingFilePath);
    await controllerBindingFile.writeAsString(controllerBindingFileContent);
    await Process.run('dart', ['format', controllerBindingFilePath]);
  }

  Future<void> _addSampleRouteToNavigation() async {
    var moduleName = 'home';

    String filePath = 'lib/infrastructure/navigation/navigation.dart';

    File file = File(filePath);
    String fileContent = await file.readAsString();

    String nameUpperCase = moduleName.toUpperCase();
    String nameCapitalize = moduleName.capitalize();

    String newRoute = '''
    GetPage(
      name: Routes.$nameUpperCase,
      page: () => const ${nameCapitalize}Widget(),
      binding: ${nameCapitalize}ControllerBinding(),
    ),''';

    String searchPattern = 'static List<GetPage> routes = [';
    int insertIndex = fileContent.indexOf(searchPattern);

    if (insertIndex != -1) {
      insertIndex = fileContent.indexOf('];', insertIndex);
      String updatedContent = '${fileContent.substring(0, insertIndex)}$newRoute\n${fileContent.substring(insertIndex)}';
      await file.writeAsString(updatedContent);
      await Process.run('dart', ['format', filePath]);
    }
  }

  Future<void> _addSampleRouteToRoutesClass() async {
    var moduleName = 'home';
    String filePath = 'lib/infrastructure/navigation/routes.dart';
    File file = File(filePath);
    String fileContent = await file.readAsString();
    String routeConstName = moduleName.toUpperCase();
    String newRoute = '  static const $routeConstName = \'/$moduleName\';\n';
    int insertIndex = fileContent.lastIndexOf('}');
    if (insertIndex != -1) {
      String updatedContent = fileContent.substring(0, insertIndex) + newRoute + fileContent.substring(insertIndex);
      await file.writeAsString(updatedContent);
      await Process.run('dart', ['format', filePath]);
    }
  }

  Future<void> _addSampleControllerBindingToExportControllerBindingFile() async {
    var moduleName = 'home';

    String dirPath = 'lib/infrastructure/navigation/bindings/controllers';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String filePath = '$dirPath/controllers_bindings.dart';
    File file = File(filePath);
    await file.writeAsString(
      "export '${moduleName.toLowerCase()}_controller_binding.dart';",
      mode: FileMode.append,
    );
    await Process.run('dart', ['format', filePath]);
  }

  Future<void> _addSampleScreenToExportScreenFile() async {
    var moduleName = 'home';

    String dirPath = 'lib/presentation';
    Directory directory = Directory(dirPath);
    await directory.create(recursive: true);

    String filePath = '$dirPath/screens.dart';
    File file = File(filePath);
    await file.writeAsString(
      "export '${moduleName.toLowerCase()}/widgets/${moduleName.toLowerCase()}_widget.dart';",
      mode: FileMode.append,
    );
    await Process.run('dart', ['format', filePath]);
  }

  Future<bool> isFolderEmpty(String folderPath) async {
    Directory directory = Directory(folderPath);

    if (!await directory.exists()) {
      print('Directory does not exist.');
      return true;
    }

    bool isEmpty = true;
    await for (var entity in directory.list()) {
      isEmpty = false;
      break;
    }
    return isEmpty;
  }

  Future<void> deleteEverythingInFolder(String folderPath) async {
    Directory directory = Directory(folderPath);

    if (!await directory.exists()) {
      return;
    }

    await for (var entity in directory.list()) {
      if (entity is File) {
        await entity.delete();
      } else if (entity is Directory) {
        await entity.delete(recursive: true);
      }
    }
  }
}
