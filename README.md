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

## Generate model
``` shell
dart run clean_generator.dart generate_model: <your_model_name>
// example: dart run clean_generator.dart create_model: sample_object
// Enter your sample model json:
// {
//  "greeting": "Welcome to quicktype!",
//  "instructions": [
//    "Type or paste JSON here",
//    "Or choose a sample above",
//    "quicktype will generate code in your",
//    "chosen language to parse the sample data"
//  ],
//  "complicated": {
//      "first": 1,
//      "second": 2
//  }
//}
```