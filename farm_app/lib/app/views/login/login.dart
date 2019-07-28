import 'package:flutter/material.dart';
import 'package:farm_app/app/components/login/login.dart';

class LoginVm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        actions: <Widget>[
          IconButton(
            icon: Icon(IconData(0xe616, fontFamily: 'iconfont'), size: 26.0),
            tooltip: 'register',
            onPressed: () => Navigator.pushNamed(context, "/register"),
          )
        ],
      ),
      body: Theme(
        // // 替换全局主题
        data: ThemeData(
          primaryColor: Color.fromRGBO(248, 68, 80, 1.0),
          // hintColor: Colors.white,
          // 环境颜色
          // accentColor: Colors.grey[200],
        ),
        // // 替换全局主题部分样式
        // data: Theme.of(context).copyWith(primaryColor: Colors.indigo),
        child: LoginForm(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.arrow_back),
        onPressed: () {
          // 无返回按钮的路由跳转
          Navigator.pushReplacementNamed(context, "/home");
        },
      ),
    );
  }
}
