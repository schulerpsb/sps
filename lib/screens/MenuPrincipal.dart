import 'package:flutter/material.dart';

class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff06044C),
        title: Text(
          'APLICATIVOS',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:80,left:18,right:18, bottom: 20),
            child: Container(
              padding: EdgeInsets.all(15.0),
              height: 100,
              width: 500,
              color: Color(0xff06044C),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.description,
                          color: Colors.white, size: 35.0)),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'SISTEMA CHECKLIST (FOLLOW UP)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              padding: EdgeInsets.all(15.0),
              height: 100,
              width: 500,
              color: Color(0xff06044C),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.equalizer,
                          color: Colors.white, size: 35.0)),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'GESTÃO DE FORNECEDORES (FEEDBACK)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              padding: EdgeInsets.all(15.0),
              height: 100,
              width: 500,
              color: Color(0xff06044C),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.monetization_on,
                          color: Colors.white, size: 35.0)),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'GESTÃO DE FORNECEDORES (COTAÇÃO)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:100,left:18,right:18, bottom: 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter ,
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
    ));
  }
}
