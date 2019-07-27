import 'package:flutter/material.dart';
import 'app/components/bottomNavigationBarVm.dart'; //BottomNavigationBarVm 底部导航组件
import 'app/views/home/home_list.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  void _onTapHandle(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List _pages = [
    HomeList(),
    Text(
      "订单",
      style: TextStyle(color: Colors.black),
    ),
    Text(
      "我的",
      style: TextStyle(color: Colors.black),
    ),
  ];

  List _title = ["首页", "订单", "我的"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          _title[_currentIndex],
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(IconData(0xe602, fontFamily: 'iconfont'), size: 26.0),
            tooltip: 'search',
            // onPressed: () => Navigator.pushNamed(context, "/login"),
            onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
          )
        ],
      ),
      body: Container(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBarVm(
        currentIndex: _currentIndex,
        callBack: (val) => _onTapHandle(val),
      ),
    );
  }
}
