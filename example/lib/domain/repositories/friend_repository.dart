import '../../data/repository_impl/friend_repository_impl.dart';
import '../../data/source/api/friend/friend_api_client.dart';
import '../../data/source/api/auth/auth_api_client.dart';

abstract class FriendRepository {
  factory FriendRepository({
    required FriendApiClient friendApiClient,
    required AuthApiClient authApiClient,
  }) = FriendRepositoryImpl;
}
