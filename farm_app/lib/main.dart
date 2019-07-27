import 'package:flutter/material.dart';
import 'app/views/login/register.dart';
import 'splash.dart'; //Splash/欢迎页
// import 'home.dart'; //HomePage/首页
import 'app/views/login/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(248, 68, 80, 1.0),
        // backgroundColor: Color.fromRGBO(35, 39, 47, 1.0),
        // bottomAppBarColor: Color.fromRGBO(45, 49, 59, 1.0),
        backgroundColor:Colors.white
      ),
      // home: Splash(),
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/login': (context) => LoginVm(),
        '/register': (context) => RegisterVm(),
        // '/form': (context) => FormDemo()
      },
    );
  }
}
