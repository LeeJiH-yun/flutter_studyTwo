import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/common/component/custorm_text_field.dart';
import 'package:flutter_studytwo/common/const/colors.dart';
import 'package:flutter_studytwo/common/layout/defalut_layout.dart';
import 'package:flutter_studytwo/user/model/user_model.dart';
import 'package:flutter_studytwo/user/provider/user_me_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return DefaultLayout(
      child: SingleChildScrollView(
        //밑에 있는 위젯을 스크롤 할 수 있게 해준다.
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        //드래그 하는 순간에 키보드가 사라진다.
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16.0),
                _SubTitle(),
                Image.asset('asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width /
                        3 *
                        2, //전체 너비의 3분의 2 가져오기
                    height: 300.0),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintTxt: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    username = value; //입력받은 값 저장
                  },
                ),
                const SizedBox(height: 11.0),
                CustomTextFormField(
                  hintTxt: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureTxt: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: state is UserModelLoading ? null : () async {
                    ref.read(userMeProvider.notifier).login(
                        username: username,
                        password: password,
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                    onPressed: () async {},
                    style: TextButton.styleFrom(primary: Colors.black),
                    child: Text('회원가입'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다.',
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요.\n오늘도 성공적인 주문이 되길 :0',
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}
