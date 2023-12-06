import '../../domain/repositories/friend_repository.dart';
import '../source/sources.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendApiClient friendApiClient;
  final AuthApiClient authApiClient;
  FriendRepositoryImpl({
    required this.friendApiClient,
    required this.authApiClient,
  });
}
