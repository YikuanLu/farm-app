/**
 * onTapCallback => 点击回调(一般为发送短信请求接口)
 * changeAvailable => 改变可点击状态(点击状态父组件传递进来的)
 * available => 可点击状态
 */
import 'dart:async';
import 'package:flutter/material.dart';

/// 墨水瓶（`InkWell`）可用时使用的字体样式。
final TextStyle _availableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color.fromRGBO(248, 68, 80, 1.0),
);

/// 墨水瓶（`InkWell`）不可用时使用的样式。
final TextStyle _unavailableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color(0xFFCCCCCC),
);

class CountDown extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int countdown;

  /// 用户点击时的回调函数。
  final Function onTapCallback;

  /// 改变状态方法
  final Function changeAvailable;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;

  CountDown({
    this.countdown: 60,
    this.onTapCallback,
    this.changeAvailable,
    this.available: false,
  });

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle inkWellStyle = _availableStyle;

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';

  // 可点击状态时的方法
  void _tapHandle() async {
    if (await widget.onTapCallback()) {
      widget.changeAvailable(false);
      if (widget.available) {
        _startTimer();
      }
      inkWellStyle = _unavailableStyle;
      // _verifyStr = '已发送$_seconds' + 's';
    }
  }

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
    // flag = widget.available;
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
    _timer = null;
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    setState(() {
      _seconds--;
      _verifyStr = '$_seconds' + '秒后重新发送';
    });
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds == 1) {
          _cancelTimer();
          _seconds = widget.countdown;
          inkWellStyle = _availableStyle;
          widget.changeAvailable(true);
          _verifyStr = '重新发送';
          _cancelTimer();
          _timer = null;
          return;
        }
        _seconds--;
        _verifyStr = '$_seconds' + '秒后重新发送';
      });
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        _verifyStr,
        style: widget.available ? inkWellStyle : _unavailableStyle,
      ),
      onTap: (_seconds == widget.countdown && widget.available)
          ? _tapHandle
          : null,
    );
  }
}
