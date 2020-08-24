import 'package:flutter/material.dart';

class homeSps extends StatefulWidget {
  @override
  _homeSpsState createState() => _homeSpsState();
}

class _homeSpsState extends State<homeSps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'images/logo_sps.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(child: Text('Home SPS')),
              Icon(Icons.person),
            ],
          )),
      body: Container(),
    );
  }
}
