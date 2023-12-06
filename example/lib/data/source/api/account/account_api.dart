import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_api.g.dart';

@RestApi()
abstract class AccountApi {
  factory AccountApi(Dio dio) = _AccountApi;
}
