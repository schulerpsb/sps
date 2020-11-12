import 'package:flutter/material.dart';

class sps_cotacao_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff06044C),
        title: Text(
          'COTAÇÃO',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
