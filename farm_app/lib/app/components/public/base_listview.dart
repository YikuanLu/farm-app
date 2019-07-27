import 'dart:async';
import 'package:flutter/material.dart';

//类型定义
typedef Future<Map> PageRequest(int page, int pageSize);
typedef Widget ItemBuilder<T>(List<T> list, int position);

class BaseListView<T> extends StatefulWidget {
  final PageRequest pageRequest;
  final ItemBuilder<T> itemBuilder;
  final int pageSize;
  final int page;
  final bool enableLoadmore;
  final bool enableRefresh;
  final bool hasHeader;
  final Widget header;
  // @required
  // final int total;

  BaseListView(
    this.pageRequest,
    this.itemBuilder, {
    Key kye,
    this.pageSize = 10,
    this.page = 0,
    this.enableLoadmore = false,
    this.enableRefresh = true,
    this.hasHeader = false,
    this.header,
    // this.total,
  });

  @override
  State<StatefulWidget> createState() => new _BaseListViewState<T>();
}

class _BaseListViewState<T> extends State<BaseListView<T>> {
  List<T> _list = new List();
  ScrollController controller;
  bool _enableLoadmore;
  int _page;
  int _total = 20;
  bool isLoading = false; //是否正在加载数据的标志

  //这个future是用来给FutureBuilder进行获取数据的，另一个方面是可以避免没必要的重绘
  Future future;

  FutureBuilder<List<T>> futureBuilder;

  @override
  void initState() {
    super.initState();
    _enableLoadmore = widget.enableLoadmore;
    _page = widget.page;
    future = loadData(_page, widget.pageSize);
    futureBuilder = buildFutureBuilder();
    /**这部分代码主要是设置滑动监听，滑动到距离底部100单位的时候，开始进行loadmore操作
        如果controller.position.pixels==controller.position.maxScrollExtent再去
        进行loadmore操作的话，实际的显示和操作会有点奇怪，所以这里设置距离底部100
     */
    controller = new ScrollController();
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 100) {
        if (!isLoading) {
          isLoading = true;
          loadmore();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * 问题：赋值给一个变量的话，会导致setState无法更新的问题
     * 不赋值给变量的话，外部的setState会导致列表也会跟着setState
     * 暂时的解决方法：每次refresh和loadmore的时候重新赋值futurebuilder，
     * 这样可以刷新。并且外部其他进行setState的时候，内部并不会跟着进行没必要的刷新
     */
    return futureBuilder;
  }

  // 构造FutureBuilder
  FutureBuilder<List<T>> buildFutureBuilder() {
    return FutureBuilder<List<T>>(
      builder: (BuildContext context, AsyncSnapshot<List<T>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          isLoading = true;
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }

        if (async.connectionState == ConnectionState.done) {
          isLoading = false;
          if (async.hasError) {
            //有错误的时候
            return new RetryItem(() {
              refresh();
            });
          } else if (!async.hasData) {
            //返回值为空的时候
            return new EmptyItem(() {
              refresh();
            });
          } else if (async.hasData) {
            //如果是刷新的操作
            if (_page == 0) {
              _list.addAll(async.data);
            }
            if (_total > 0 && _total <= _list.length) {
              _enableLoadmore = false;
            } else {
              _enableLoadmore = true;
            }
            //计算最终的list长度
            int length = _list.length + (widget.hasHeader ? 1 : 0);

            return new RefreshIndicator(
              child: new ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _enableLoadmore ? controller : null,
                itemBuilder: (context, index) {
                  //可以加载更多的时候，最后一个item显示菊花
                  if (_enableLoadmore && index == length) {
                    return new LoadMoreItem();
                  }
                  return widget.itemBuilder(_list, index);
                },
                itemCount: length + (_enableLoadmore ? 1 : 0),
                separatorBuilder: (BuildContext context, int index) {
                  return new Divider();
                },
              ),
              onRefresh: refresh,
            );
          }
        }
        return null;
      },
      future: future,
    );
  }

  Future refresh() async {
    if (!widget.enableRefresh) {
      return;
    }
    if (isLoading) {
      return;
    }
    _list.clear();
    setState(() {
      isLoading = true;
      _page = 0;
      future = loadData(_page, widget.pageSize);
      futureBuilder = buildFutureBuilder();
      // callBack();
    });
  }

  void loadmore() async {
    debugPrint("loadData:loadmore,list:${_list.length}");
    loadData(++_page, widget.pageSize).then((List<T> data) {
      setState(() {
        isLoading = false;
        _list.addAll(data);
        futureBuilder = buildFutureBuilder();
      });
    });
  }

  Future<List<T>> loadData(int page, int pageSize) async {
    var data = await widget.pageRequest(page, pageSize);
    _total = data["data"];
    return data["list"];
  }
}

class LoadMoreItem extends StatefulWidget {
  @override
  _LoadMoreItemState createState() => new _LoadMoreItemState();
}

class _LoadMoreItemState extends State<LoadMoreItem> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }
}

class RetryItem extends StatelessWidget {
  final GestureTapCallback ontap;
  RetryItem(this.ontap);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Center(
        child: new Text("加载出错,点击重试"),
      ),
      onTap: ontap,
    );
  }
}

class EmptyItem extends StatelessWidget {
  final GestureTapCallback ontap;
  EmptyItem(this.ontap);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: new Center(
          child: new Text("列表数据为空"),
        ),
        onTap: ontap);
  }
}
