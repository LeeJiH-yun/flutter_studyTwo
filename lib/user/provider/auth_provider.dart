import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/common/view/root_tab.dart';
import 'package:flutter_studytwo/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_studytwo/user/model/user_model.dart';
import 'package:flutter_studytwo/user/provider/user_me_provider.dart';
import 'package:flutter_studytwo/user/view/login_screen.dart';
import 'package:flutter_studytwo/user/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (_, __) => RootTab(),
      routes: [
        GoRoute(
          path: 'restaurant/:rid',
          name: RestaurantDetailScreen.routeName,
          builder: (_, state) => RestaurantDetailScreen(
            id: state.params['rid']!,
          )
        )
      ]
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen()
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen()
    ),
  ];

  void logout(){
    ref.read(userMeProvider.notifier).logout();
    notifyListeners();
  }

  //splashScreen
  //앱을 처음 시작할 때 토큰이 존재하는지 확인하고 이동할 화면을 정한다.
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.location == '/login';

    //유저 정보가 없는데 로그인 중일 때
    if(user == null) {
      return logginIn ? null : '/login';
    }

    //사용자 정보가 있는 상태고 로그인 중이거나 현재 위치가 splashScreen이면 홈으로 이동
    if(user is UserModel){
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    //에러
    if(user is UserModelError){
      return logginIn ? '/login' : null;
    }

    return null;
  }
}
