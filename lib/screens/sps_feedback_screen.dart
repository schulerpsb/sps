import 'package:flutter/material.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/screens/sps_drawer_screen.dart';

class sps_feedback_screen extends StatelessWidget {

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
      appBar: AppBar(
        backgroundColor: Color(0xFF004077),
        title: Text(
          'FEEDBACK',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: sps_drawer(spslogin: spslogin),
      body: Column(
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.only(top: 90, left: 18, right: 18, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset('images/desenvolvimento.png',),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Developed by Prensas Schuler Brasil',
                    style: TextStyle(
                      color: Color(0xff06044C),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
