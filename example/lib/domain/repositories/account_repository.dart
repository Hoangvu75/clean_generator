import '../../data/repository_impl/account_repository_impl.dart';

abstract class AccountRepository {
  factory AccountRepository() = AccountRepositoryImpl;
}
