import 'package:flutter/material.dart';
import 'sps_checklist_screen.dart';
import 'sps_cotacao_screen.dart';
import 'sps_feedback_screen.dart';

class sps_menu_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004077),
        title: Text(
          'FORNECEDORES - APLICATIVOS',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 80, left: 22, right: 20, bottom: 20),
            child: RaisedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => sps_checklist_screen()),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              icon: Icon(Icons.receipt, color: Colors.white, size: 30.0),
              label: Text(
                'SISTEMA CHECKLIST (FOLLOW UP)              ',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.fromLTRB(10, 40, 5, 40),
              textColor: Colors.white,
              splashColor: Colors.white,
              color: Color(0xFF004077),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 22, right: 20, bottom: 20),
            child: RaisedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => sps_feedback_screen()),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              icon: Icon(Icons.equalizer, color: Colors.white, size: 30.0),
              label: Text(
                'GESTÃO DE FORNECEDORES (FEEDBACK)   ',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.fromLTRB(10, 40, 5, 40),
              textColor: Colors.white,
              splashColor: Colors.white,
              color: Color(0xFF004077),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 22, right: 20, bottom: 20),
            child: RaisedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sps_cotacao_screen()),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              icon:
                  Icon(Icons.monetization_on, color: Colors.white, size: 30.0),
              label: Text(
                'GESTÃO DE FORNECEDORES (COTAÇÃO)    ',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.fromLTRB(10, 40, 5, 40),
              textColor: Colors.white,
              splashColor: Colors.white,
              color: Color(0xFF004077),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 70, left: 18, right: 18, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Developed by Prensas Schuler Brasil',
                    style: TextStyle(
                      color: Color(0xFF004077),
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
    ));
  }
}
