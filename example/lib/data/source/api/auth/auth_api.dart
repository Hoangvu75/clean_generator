import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../domain/entities/api_responses/base_response.dart';
part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @GET("/profile/{user}")
  Future<BaseResponse> login(
    @Body() Map<String, dynamic> body,
    @Queries() Map<String, dynamic> queries,
    @Path("user") String user,
  );
}
