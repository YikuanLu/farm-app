import 'package:flutter/material.dart';
import '../../models/home_model.dart';

class HomeListItem extends StatefulWidget {
  final HomeModel homeModel;
  HomeListItem(this.homeModel);
  @override
  _HomeListItemState createState() => _HomeListItemState(homeModel);
}

class _HomeListItemState extends State<HomeListItem> {
  HomeModel homeModel;
  int level;
  _HomeListItemState(this.homeModel);

  String show = "show";

  @override
  void initState() {
    super.initState();
    level = homeModel.level;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 3.0,
        right: 6.0,
        bottom: 3.0,
        left: 6.0,
      ),
      child: SizedBox(
        child: Card(
          elevation: 0.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /**
               * Row、Column、Flex会被Expanded撑开，充满主轴可用空间。
               * MainAxisSize：在主轴方向占有空间的值，默认是max。
               * MainAxisSize的取值有两种：
               * max：根据传入的布局约束条件，最大化主轴方向的可用空间；
               * min：与max相反，是最小化主轴方向的可用空间；
               **/
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(homeModel.name),
                    Text(level.toString()),
                    Text(homeModel.name),
                    Text(homeModel.name),
                    Text(homeModel.name),
                    Text(show),
                    RaisedButton(
                      child: Text("$level"),
                      onPressed: () {
                        setState(() {
                          level += 1;
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
