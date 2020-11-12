import 'package:flutter/material.dart';

class sps_feedback_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff06044C),
        title: Text(
          'FEEDBACK',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Image.asset('images/desenvolvimento.png',),
          Text('Macorattix.net')
        ],
      ),
    );
  }
}
