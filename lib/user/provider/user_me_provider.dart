import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_studytwo/common/const/data.dart';
import 'package:flutter_studytwo/common/secure_storage/secure_storage.dart';
import 'package:flutter_studytwo/user/model/user_model.dart';
import 'package:flutter_studytwo/user/repository/auth_repository.dart';
import 'package:flutter_studytwo/user/repository/user_me_repository.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    repository: userMeRepository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;

  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier(
      {required this.authRepository,
      required this.repository,
      required this.storage})
      : super(UserModelLoading()) {
    getMe(); //내 정보 가져오기
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null; //토큰이 둘 다 없으면 상태를 널로 바꿔줘야 한다.
      return;
    }

    final resp = await repository.getMe(); //토큰이 둘 중 하나라도 있으면 반환

    state = resp;
  }

  Future<UserModelBase> login(
      {required String username, required String password}) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(
          key: REFRESH_TOKEN_KEY, value: resp.refreshToken); //발급받은 토큰 스토리지에 저장
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp =
          await repository.getMe(); //토근 발급 받았으니 해당되는 유저를 가져와서 기억해두기 위해

      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패해버렸따');

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      //동시에 실행 가능
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
