import 'auth_api.dart';
import '../base_api_client_interface.dart';

class AuthApiClient extends BaseApiClientInterface {
  late final AuthApi api;

  @override
  void onInit() {
    super.onInit();
    api = AuthApi(dio);
  }
}
