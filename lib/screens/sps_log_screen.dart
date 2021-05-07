import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:flutter/foundation.dart';

class sps_log_screen extends StatefulWidget {
  final String path;

  sps_log_screen({Key key, this.path}) : super(key: key);

  _sps_log_screenState createState() => _sps_log_screenState();
}

class _sps_log_screenState extends State<sps_log_screen> with WidgetsBindingObserver {
  final SpsLogin spslogin = SpsLogin();
  String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
      appBar: AppBar(
        backgroundColor: Color(0xFF004077), // Azul Schuler
        title: Text(
          'SPS _ LOGS',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: sps_drawer(spslogin: spslogin),
      body: Container(),
    );
  }
}