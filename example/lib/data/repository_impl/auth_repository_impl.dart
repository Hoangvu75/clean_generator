import '../../domain/repositories/auth_repository.dart';
import '../source/sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient authApiClient;
  final FriendApiClient friendApiClient;
  AuthRepositoryImpl({
    required this.authApiClient,
    required this.friendApiClient,
  });
}
