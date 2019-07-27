import 'package:flutter/material.dart';
import 'dart:async';
import 'package:farm_app/app/components/public/base_listview.dart';
import 'package:farm_app/app/components/home/item.dart';
import 'package:farm_app/app/models/home_model.dart';
// import '../../components/home/item.dart';
// import '../../models/home_model.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  PageRequest pageRequest;
  ItemBuilder<Widget> itemBuilder;
  BaseListView<Widget> baseListView;

  Future<Map> loadData(int page, int pageSize) async {
    HomeModel homeModel;
    homeModel = HomeModel(
      name: "WangHuahua",
      level: page,
      worth: 2.0,
      time: "2019-07-17",
      integral: 0.7,
      income: "8\$",
      state: 1,
      imgUrl: "url",
    );
    var data = await Future.delayed(Duration(seconds: 1)).then((res) => 30);
    List<Widget> list = new List.generate(
      pageSize,
      (index) {
        return HomeListItem(homeModel);
      },
    );
    return {
      "data": data,
      "list": list,
    };
  }

  Widget getItem(List<Widget> list, int index) {
    return Container(
      child: list[index],
    );
  }

  @override
  void initState() {
    super.initState();
    itemBuilder = getItem;
    pageRequest = loadData;
    baseListView = new BaseListView<Widget>(
      pageRequest,
      itemBuilder,
      enableLoadmore: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return baseListView;
  }
}
