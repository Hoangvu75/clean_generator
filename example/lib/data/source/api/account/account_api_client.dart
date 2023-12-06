import 'account_api.dart';
import '../base_api_client_interface.dart';

class AccountApiClient extends BaseApiClientInterface {
  late final AccountApi api;

  @override
  void onInit() {
    super.onInit();
    api = AccountApi(dio);
  }
}
