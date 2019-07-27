import 'package:flutter/material.dart';
import 'package:farm_app/app/components/public/count_down.dart';
import 'package:farm_app/app/util/check.dart';
import 'package:farm_app/app/util/http.dart';
import 'dart:convert';
import 'package:farm_app/app/api/login.dart'; //api地址
// import 'package:dio/dio.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String mobile;
  String password;
  String nickname; //昵称
  String referrer; //介绍人
  String imgCode;
  String code; //短信验证码

  bool _autovalidate = false; //是否自动验证
  bool _available = false; //短信验证码按钮是否可点击
  Widget imgCodeVm = Container(); //短信验证码组件
  String id; //图形验证码接口返回 id
  final _registerFormKey = GlobalKey<FormState>();
  final imgCodeController = TextEditingController(); //图像验证码控制器
  final mobileController = TextEditingController(); //手机号控制器

  // 验证手机
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

  // 发送短信按钮可否点击状态
  _changeAvailable(bool available) {
    setState(() {
      _available = available;
    });
  }

  // 点击发送短信验证码
  Future _sendCaptcha() async {
    if (_validateMobile(mobileController.text) != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("提示"),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text(_validateMobile(mobileController.text)),
              )
            ],
          );
        },
      );
      return false;
    }
    var data = {
      "id": id,
      "code": imgCodeController.text,
      "mobile": mobileController.text,
    };
    try {
      await HttpUtil(context).post(
        ApiUrlLogin.getCaptcha,
        data: data,
      );
      setState(() {
        _available = true;
      });
      return true;
    } catch (e) {} finally {}
  }

  // 获取图形验证码
  void getImg() async {
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

  // 保存点击方法
  void _submitForm() async {
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();
      Map data = {
        "mobile": mobile,
        "password": password,
        "nickname": nickname,
        "referrer": referrer,
        "code": code,
      };
      try {
        await HttpUtil(context).post(
          ApiUrlLogin.registerApi,
          data: data,
        );
      } catch (e) {}
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (mobileController.text.isEmpty && imgCodeController.text.isEmpty) {
      getImg();
      imgCodeController.addListener(() {
        setState(() {
          _available = imgCodeController.text.length == 4 ? true : false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    imgCodeController.dispose();
    mobileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView
    return SingleChildScrollView(
      child: Form(
        key: _registerFormKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
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
              TextFormField(
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
                  // labelText: '用户名',
                  helperText: '',
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  nickname = value;
                },
                validator: _validate("请输入昵称"),
                autovalidate: _autovalidate,
                decoration: InputDecoration(
                  hintText: "昵称",
                  // labelText: '用户名',
                  helperText: '',
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  referrer = value;
                },
                decoration: InputDecoration(
                  hintText: "推荐人",
                  helperText: '',
                ),
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  TextFormField(
                    onSaved: (value) {
                      imgCode = value;
                    },
                    controller: imgCodeController,
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: "图形验证码",
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
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  TextFormField(
                    onSaved: (value) {
                      code = value;
                    },
                    validator: _validate("请输入短信验证码"),
                    // 是否自动验证
                    autovalidate: _autovalidate,
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: "短信验证码",
                      helperText: '',
                    ),
                  ),
                  Positioned(
                    child: CountDown(
                      onTapCallback: _sendCaptcha,
                      changeAvailable: _changeAvailable,
                      available: _available,
                    ),
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
                    '注册',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: 10.0,
                    ),
                  ),
                  elevation: 0.0,
                  onPressed: _submitForm,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
