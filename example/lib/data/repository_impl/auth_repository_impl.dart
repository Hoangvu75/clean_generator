import '../../domain/repositories/auth_repository.dart';
import '../source/sources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient authApiClient;
  AuthRepositoryImpl({
    required this.authApiClient,
  });
}
