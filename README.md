### CLEAN GENERATOR

This is a Flutter CLI (Dart) created by Hoang Vu for Moonfactory company staff only.

Project would be based on GetX and Clean architecture.

## Initialize project
``` shell
dart run clean_generator.dart init
```

## Create a module (include widget, controller, binding)
``` shell
dart run clean_generator.dart create_module: <your_module_name>
// example: dart run clean_generator.dart create_widget: settings
```

## Create widget on specific module
``` shell
dart run clean_generator.dart create_widget: <your_widget_name> on <your_module_name>
// example: dart run clean_generator.dart create_widget: home_button on home
```

## Create controller on specific module
``` shell
dart run clean_generator.dart create_widget: <your_controller_name> on <your_module_name>
// example: dart run clean_generator.dart create_controller: home_button on home
```

## Create service
``` shell
dart run clean_generator.dart create_service: <your_service_name>
// example: dart run clean_generator.dart create_service: alarm
```