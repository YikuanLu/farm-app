import 'package:flutter/material.dart';

class BottomNavigationBarVm extends StatelessWidget {
  final int currentIndex;
  final callBack;
  BottomNavigationBarVm({Key key, this.currentIndex, this.callBack})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        unselectedItemColor: Colors.grey[500],
        currentIndex: currentIndex,
        onTap: (index) => callBack(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe607, fontFamily: 'iconfont'), size: 26.0),
            title: Text(
              "首页",
              style: TextStyle(fontSize: 12.0),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe60d, fontFamily: 'iconfont'), size: 26.0),
            title: Text(
              "订单",
              style: TextStyle(fontSize: 12.0),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe627, fontFamily: 'iconfont'), size: 26.0),
            title: Text(
              "我的",
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
