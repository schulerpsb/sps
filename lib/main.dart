import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sps/screens/sps_login.dart';

void main() {
  runApp(Sps());
}

class Sps extends StatelessWidget {
  const Sps({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF004077),
        accentColor: Color(0xFF004077),
      ),
      home: MyHomePage(title: 'Schuler Production System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 5,
        navigateAfterSeconds: Sps_login(),
        loaderColor: Colors.transparent,
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/logo_schuler.gif"),
            fit: BoxFit.none,
          ),
        ),
      ),
    ],
  );
}