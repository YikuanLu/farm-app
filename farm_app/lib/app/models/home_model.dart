import 'dart:convert';
import 'package:meta/meta.dart';

class HomeModel {
  String name; //名字
  int level; //级别
  double worth; //价值
  String time; //时间
  double integral; //积分
  String income; //收益
  int state; //状态
  String imgUrl; //图片地址

  HomeModel({
    @required this.name,
    @required this.level,
    @required this.worth,
    @required this.time,
    @required this.integral,
    @required this.income,
    @required this.state,
    @required this.imgUrl,
  });

  static List<HomeModel> formJson(String json) {
    List<HomeModel> _home = [];

    JsonDecoder decoder = new JsonDecoder();

    var mapData = decoder.convert(json)['list'];

    mapData.forEach((obj) {
      HomeModel home = HomeModel(
        name: obj['name'],
        level: obj['level'],
        worth: obj['worth'],
        time: obj['time'],
        integral: obj['integral'],
        income: obj['income'],
        state: obj['state'],
        imgUrl: obj['imgUrl'],
      );
      _home.add(home);
    });
    return _home;
  }
}
