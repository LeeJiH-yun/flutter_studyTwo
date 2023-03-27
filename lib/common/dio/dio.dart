//1. 요청 보낼 때 2. 응답을 받을 때 3. 에러가 났을 때

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_studytwo/common/const/data.dart';
import 'package:flutter_studytwo/common/secure_storage/secure_storage.dart';
import 'package:flutter_studytwo/user/provider/auth_provider.dart';

final dioProvider = Provider<Dio>((ref){
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  
  dio.interceptors.add(
    CustomInterceptor(storage: storage)
  );
  return dio;

});

class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage storage;

  CustomInterceptor({ //스토리지 안에서 토큰을 가져오기 위함으로 사용
    required this.storage
  });

  //1. 요청을 보낼 때
  //요청의 헤더에 accessToken: true 값이 있다면 실제 토큰을 가져와서 헤더를 변경한다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async { //토큰을 자동으로 적용
    //요청이 보내지기 전
    print('[REQ] [${options.method}] ${options.uri}');

    if(options.headers['accessToken'] == 'true') { //실제 요청의 헤더
      options.headers.remove('accessToken'); //헤더 삭제

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization' : 'Bearer $token',
      });
    }

    if(options.headers['refreshToken'] == 'true') { //실제 요청의 헤더
      options.headers.remove('refreshToken'); //헤더 삭제

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization' : 'Bearer $token',
      });
    }

    return super.onRequest(options, handler); //여기서 요청이 보내진다.
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[ERR] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3. 에러 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler, WidgetRef ref) async {
    //401에러가 났을때 (status code)
    //토큰을 재발급 받는 시도를 하고 재발급되면 다시 새로운 토큰으로 요청한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //resfreshToken 아예 없으면 에러를 던지는데 handler.reject사용
    if (refreshToken == null) {
      return handler.reject(err); //handler.reject를 하면 에러를 생성시킬 수 있다.
    }

    final isStatus401 = err.response?.statusCode == 401; //requestOptions: 요청의 모든 값을 가져올 수 있다.
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && !isPathRefresh) {
      //!isPathRefresh = 토큰을 새로 발급받는 요청이 아니다.
      final dio = Dio();

      try{ //토큰 새로 발급 받기
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization' : 'Bearer $refreshToken',
            }
          )
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        //토큰 변경하기
        options.headers.addAll({
          'authorization' : 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);//스토리지에도 새로 발급 받은 토큰을 저장해야함

        //요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch(e){ //Dio에러만 잡기
        ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }
}