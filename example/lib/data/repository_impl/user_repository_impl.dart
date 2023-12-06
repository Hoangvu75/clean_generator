import '../../domain/repositories/user_repository.dart';
import '../source/sources.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApiClient authApiClient;
  UserRepositoryImpl({
    required this.authApiClient,
  });
}
