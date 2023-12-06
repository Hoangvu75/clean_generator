import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../domain/entities/api_responses/base_response.dart';
part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;
  @POST("/api/auth/login")
  Future<BaseResponse> login(
    @Body() Map<String, dynamic> body,
  );
}
