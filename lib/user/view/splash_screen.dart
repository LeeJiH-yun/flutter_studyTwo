import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_studytwo/common/const/colors.dart';
import 'package:flutter_studytwo/common/layout/defalut_layout.dart';

class SplashScreen extends ConsumerWidget {
  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width, //너비를 최대한으로 하면 자동으로 가운데 정렬이 된다.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo/logo.png',
                width: MediaQuery.of(context).size.width /2,
              ),
              const SizedBox(height: 16.0,),
              CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        )
    );
  }
}
