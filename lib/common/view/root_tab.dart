import 'package:flutter/material.dart';
import 'package:flutter_studytwo/common/const/colors.dart';
import 'package:flutter_studytwo/common/layout/defalut_layout.dart';
import 'package:flutter_studytwo/product/view/product_screen.dart';
import 'package:flutter_studytwo/restaurant/view/restaurant_screen.dart';
import 'package:flutter_studytwo/user/view/profile_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';

  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  //vsync는 with SingleTickerProviderStateMixin랑 같이 써줘야 한다.
  late TabController controller; //사용 하기 전에 선언을 먼저 해줘야 한다.
  //TabController? controller 이렇게 써도 되는데 단점이 사용할 때마다 널처리를 해줘야함

  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);//선언

    controller.addListener(tabListener);
  }

  void dispose(){
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener(){
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), //화면상에서 옆으로 넘기는 것이 안된다.
        controller: controller,
        children: [
          RestaurantScreen(),
          ProductScreen(),
          Center(child: Container(child: Text('주문'),)),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        onTap: (int index){ //클릭한 탭의 인덱스가 들어간다.
          controller.animateTo(index); //선택한 탭으로 이동하게끔
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '주문'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: '프로필'),
        ],
      ),
    );
  }
}
