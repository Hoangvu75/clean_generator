# CLEAN GENERATOR

This is a Flutter CLI (Dart) created by Hoang Vu for Moonfactory company staff only.

Project would be based on GetX and Clean architecture.

# Install

Add clean_generator to your dev-dependencies in pubspec.yaml

``` yaml
dev_dependencies:
  clean_generator:
    git:
      url: https://github.com/Hoangvu75/clean_generator.git
      ref: master
```

## Initialize project
``` shell
dart run clean_generator init
```

## Create a module (include widget, controller, binding)
`dart run clean_generator create_module: <your_module_name>`

example: 
``` shell
dart run clean_generator create_module: settings
```

## Create widget on specific module
`dart run clean_generator create_widget: <your_widget_name> on <your_module_name>`

example: 
``` shell
dart run clean_generator create_widget: home_button on home
```

## Create controller on specific module
`dart run clean_generator create_controller: <your_controller_name> on <your_module_name>`

example:
``` shell
dart run clean_generator create_controller: home_button on home
```

## Create repository
`dart run clean_generator create_repository: <your_repository_name>`

example:
``` shell
dart run clean_generator create_repository: auth
```

## Create service
`dart run clean_generator create_service: <your_service_name>`

example:
``` shell
dart run clean_generator create_service: alarm
```

## Bind service to a controller of a module
`dart run clean_generator bind_service: <your_service_name> on <your_controller_name> of <your_module_name>`

example:
``` shell
dart run clean_generator bind_service: network on home of home
```

## Generate model
`dart run clean_generator generate_model: <your_model_name>`

example: 
``` shell
dart run clean_generator create_model: sample_object
```

Then press enter to execute the command, then copy and paste the json string of model to the terminal
``` shell
Enter your sample model json: 
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

A model would be created at lib/domain/entities/models/SampleObject.dart like this
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

## Generate API Response model
`dart run clean_generator generate_api_response: <your_api_response_name>`

example: 
``` shell
dart run clean_generator create_model: base_response
```

Then press enter to execute the command, then copy and paste the json string of model to the terminal
``` json
{
  "code": 200,
  "message": "success",
  "data": null,
  "isSuccess": true
}
```

An API response would be created at lib/domain/entities/api_response/BaseResponse.dart like this
``` dart
class BaseResponse {
  int? code;
  String? message;
  dynamic data;
  bool? isSuccess;

  BaseResponse({
    this.code,
    this.message,
    this.data,
    this.isSuccess,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'],
      isSuccess: json['isSuccess'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
      'isSuccess': isSuccess,
    };
  }
}
```

## Generate API:
### You must initialize API client interface at first
``` shell
dart run clean_generator init_api_client_interface
```

Then it asked you to enter your API client interface name and base url, do like this
``` shell
Enter API client interface name:
>> base
Enter base url:
>> https://base.api.com
```

After that, you can see an API client interface call BaseApiClientInterface created at lib/data/source/api/base_api_client_interface.dart
``` dart
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class BaseApiClientInterface extends GetxService {
  late final Dio dio;
  late final String baseURL;

  @override
  void onInit() {
    super.onInit();
    baseURL = "https://base.api.com";
    dio = Dio();
    dio.options = BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status! < 500;
      },
      contentType: Headers.jsonContentType,
    );
    dio.interceptors
      ..add(
        PrettyDioLogger(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      )
      ..add(
        InterceptorsWrapper(
          onRequest: (
            RequestOptions options,
            RequestInterceptorHandler handler,
          ) {
            final token = "";
            if (token != null) {
              options.headers['Authorization'] = "Bearer $token";
            }
            handler.next(options);
          },
          onError: (
            DioException exception,
            ErrorInterceptorHandler handler,
          ) {
            throw exception;
          },
        ),
      );
  }
}

```

### After initialized API client interface, you can create your API:
`dart run clean_generator create_api: <your_api_name> from <your_api_client_interface_name>`

example:
``` shell
dart run clean_generator create_api: auth from base
```

This will create the three of `auth_api.dart`, `auth_api.g.dart`, `auth_api_client.dart` in lib/data/source/api/auth

### Generate API request on your API:
`dart run clean_generator generate_api_request: <your_api_name>`

example:
``` shell
>> dart run clean_generator generate_api_request: auth
Enter your function name:
>> login
Enter your API method (GET, POST, etc...):
>> POST

Enter your API endpoint:
Example: /login/
(If your endpoint has a path parameter, replace it with {parameter_name}. Example: /profile/{userIdx})
>> /api/auth/login
Does your API request has a body? (y/n)
>> y
Does your API request has a query? (y/n)
>> n
Enter the name of api response model that you want to use (it must be created before):
>> base
```

Finally, a new API request would be added to your API, for example:
``` dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../domain/entities/api_responses/base_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  // new request added here
  @POST("/api/auth/login") 
  Future<BaseResponse> login(
    @Body() Map<String, dynamic> body,
  );
}
```
