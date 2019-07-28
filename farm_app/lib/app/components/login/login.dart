// import 'package:farm_app/app/components/public/count_down.dart';
import 'package:flutter/material.dart';
import 'package:farm_app/app/util/check.dart';
import 'package:farm_app/app/util/shared_preferences.dart';
import 'dart:convert';
import 'package:farm_app/app/util/http.dart';
import 'package:farm_app/app/api/login.dart'; //api地址

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String mobile, password, code;
  bool _autovalidate = false;
  bool available = true;
  final _loginFormKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  Widget imgCodeVm = Container(); //短信验证码组件
  String id; //图形验证码接口返回 id

  // 获取图形验证码
  Future<void> getImg() async {
    try {
      var result = await HttpUtil(context).post(ApiUrlLogin.getCaptchaImg);
      var url = result["image"];
      id = result["id"];
      setState(
        () {
          imgCodeVm = InkWell(
            onTap: getImg,
            child: Image.memory(
              base64.decode(url.split(',')[1]),
              height: 36, //设置高度
              width: 78, //设置宽度
              fit: BoxFit.fill, //填充
              gaplessPlayback: true, //防止重绘
            ),
          );
        },
      );
    } catch (e) {
      setState(
        () {
          imgCodeVm = InkWell(
            onTap: getImg,
            child: Text(
              "获取图片验证码",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          );
        },
      );
    }
  }

  // 初始化方法(获取本地记住账号密码、获取图形验证码请求)
  void init() async {
    mobileController.text = await SharedStorage.getItem("mobile") ?? null;
    passwordController.text = await SharedStorage.getItem("password") ?? null;
    await getImg();
  }

  // 点击提交按钮方法
  void _submitForm() async {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      try {
        Map data = {
          "id": id,
          "code": code,
          "mobile": mobile,
          "password": password
        };
        print("data：$data");
        HttpUtil(context)
            .post(
          ApiUrlLogin.loginApi,
          data: data,
        )
            .then(
          (res) {
            SharedStorage.setItem("mobile", mobile);
            SharedStorage.setItem("password", password);
            Navigator.pushReplacementNamed(context, "/home");
          },
        );
      } catch (e) {}
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  // 验证手机号方法
  String _validateMobile(value) {
    if (value.isEmpty) {
      return "请输入手机号";
    }
    if (!CheckFn.isChinaPhoneLegal(value)) {
      return "请输入正确手机号";
    }
    return null;
  }

  // 通用判空方法
  Function _validate(String str) {
    return (value) {
      if (value.isEmpty) {
        return str;
      }
      return null;
    };
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _loginFormKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // 用户名
              TextFormField(
                controller: mobileController,
                onSaved: (value) {
                  mobile = value;
                },
                validator: _validateMobile,
                // 是否自动验证
                autovalidate: _autovalidate,
                decoration: InputDecoration(
                  hintText: "手机号",
                  // labelText: '用户名',
                  helperText: '',
                ),
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  TextFormField(
                    controller: passwordController,
                    onSaved: (value) {
                      password = value;
                    },
                    validator: _validate("请输入密码"),
                    // 是否隐藏输入内容
                    obscureText: true,
                    // 是否自动验证
                    autovalidate: _autovalidate,
                    decoration: InputDecoration(
                      hintText: "密码",
                      // labelText: '密码',
                      helperText: '',
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  TextFormField(
                    maxLength: 4,
                    onSaved: (value) {
                      code = value;
                    },
                    validator: _validate("请输入验证码"),
                    // 是否自动验证
                    autovalidate: _autovalidate,
                    decoration: InputDecoration(
                      hintText: "验证码",
                      // labelText: '验证码',
                      helperText: '',
                    ),
                  ),
                  Positioned(
                    child: imgCodeVm,
                    right: 0.0,
                    bottom: 30.0,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                height: 42.0,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    '登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 10.0,
                    ),
                  ),
                  elevation: 0.0,
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
