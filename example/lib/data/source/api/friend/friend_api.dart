import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../domain/entities/api_responses/base_response.dart';
part 'friend_api.g.dart';

@RestApi()
abstract class FriendApi {
  factory FriendApi(Dio dio) = _FriendApi;
  @GET("/api/friend/{friendId}")
  Future<BaseResponse> getFriendData(
    @Path("friendId") String friendId,
  );
}
