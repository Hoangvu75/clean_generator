import '../../data/repository_impl/auth_repository_impl.dart';
import '../../data/source/api/auth/auth_api_client.dart';
import '../../data/source/api/friend/friend_api_client.dart';

abstract class AuthRepository {
  factory AuthRepository({
    required AuthApiClient authApiClient,
    required FriendApiClient friendApiClient,
  }) = AuthRepositoryImpl;

  Future<void> login(String email, String password);
}
