### CLEAN GENERATOR

This is a Flutter CLI (Dart) created by Hoang Vu for Moonfactory company staff only.

Project would be based on GetX and Clean architecture.

## Initialize project
``` shell
dart run clean_generator init
```

## Create a module (include widget, controller, binding)
`dart run clean_generator create_module: <your_module_name>`

example: 
``` shell
dart run clean_generator create_widget: settings
```

## Create widget on specific module
`dart run clean_generator create_widget: <your_widget_name> on <your_module_name>`

example: 
``` shell
dart run clean_generator create_widget: home_button on home
```

## Create controller on specific module
`dart run clean_generator create_widget: <your_controller_name> on <your_module_name>`

example:
``` shell
dart run clean_generator create_controller: home_button on home
```

## Create service
`dart run clean_generator create_service: <your_service_name>`

example:
``` shell
dart run clean_generator create_service: alarm
```

## Generate model
`dart run clean_generator generate_model: <your_model_name>`

example: 
``` shell
dart run clean_generator create_model: sample_object
```

Then press enter to execute the command, then copy and paste the json string of model to the terminal
```
{
  "greeting": "Welcome to quicktype!",
  "instructions": [
    "Type or paste JSON here",
    "Or choose a sample above",
    "quicktype will generate code in your",
    "chosen language to parse the sample data"
  ],
  "complicated": {
      "first": 1,
      "second": 2
  }
}
```

A model would be created at lib/domain/entities/models like this
```dart
class SampleObject {
  String? greeting;
  List? instructions;
  Complicated? complicated;

  SampleObject({
    this.greeting,
    this.instructions,
    this.complicated,
  });

  factory SampleObject.fromJson(Map<String, dynamic> json) {
    return SampleObject(
      greeting: json['greeting'],
      instructions: json['instructions'],
      complicated: Complicated.fromJson(json['complicated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greeting': greeting,
      'instructions': instructions,
      'complicated': complicated?.toJson(),
    };
  }
}

class Complicated {
  int? first;
  int? second;

  Complicated({
    this.first,
    this.second,
  });

  factory Complicated.fromJson(Map<String, dynamic> json) {
    return Complicated(
      first: json['first'],
      second: json['second'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'second': second,
    };
  }
}
```
