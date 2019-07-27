import 'package:farm_app/app/components/login/register.dart';
import 'package:flutter/material.dart';

class RegisterVm extends StatefulWidget {
  @override
  _RegisterVmState createState() => _RegisterVmState();
}

class _RegisterVmState extends State<RegisterVm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("注册"),
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
        child: RegisterForm(),
      ),
      // resizeToAvoidBottomPadding: false,
    );
  }
}
