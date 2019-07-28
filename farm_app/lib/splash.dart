/* 导航页 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer _t;
  @override
  void initState() {
    super.initState();

    _t = new Timer(const Duration(milliseconds: 2000), () {
      try {
        // pushAndRemoveUntil 跳转页面并销毁当前页面
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
            (Route route) => route == null);
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    _t.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.only(top: 150.0),
        child: Column(
          children: <Widget>[
            Text(
              "welcome".toUpperCase(),
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
