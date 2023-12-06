import '../../data/repository_impl/user_repository_impl.dart';
import '../../data/source/api/auth/auth_api_client.dart';

abstract class UserRepository {
  factory UserRepository({
    required AuthApiClient authApiClient,
  }) = UserRepositoryImpl;
}
