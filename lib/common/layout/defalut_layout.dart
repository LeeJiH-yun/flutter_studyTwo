import 'package:flutter/material.dart';
//모든 스크린에 적용하는 layout

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor; //만약 입력 받지 않으면 기본색이 적용되게
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null; //null을 리턴해주기 위해 AppBar에 ?를 붙여준다.
    }
    else {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, //앞으로 튀어나온 것 같은 느낌을 준다.
        title: Text(
          title!, //!를 붙여서 널이 없다고 확인시켜주기
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
