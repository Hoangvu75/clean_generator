import '../../domain/repositories/auth_repository.dart';
import '../source/sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient authApiClient;
  final FriendApiClient friendApiClient;
  AuthRepositoryImpl({
    required this.authApiClient,
    required this.friendApiClient,
  });

  @override
  Future<void> login(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };
    final response = await authApiClient.api.login(body);
  }
}
