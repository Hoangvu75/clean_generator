import '../../data/repository_impl/auth_repository_impl.dart';

abstract class AuthRepository {
  factory AuthRepository() = AuthRepositoryImpl;
}
