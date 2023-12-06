import 'friend_api.dart';
import '../base_api_client_interface.dart';

class FriendApiClient extends BaseApiClientInterface {
  late final FriendApi api;

  @override
  void onInit() {
    super.onInit();
    api = FriendApi(dio);
  }
}
