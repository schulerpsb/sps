import 'package:flutter/material.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_questionario_ext_filtro_screen.dart';
import 'package:sps/screens/sps_questionario_int_filtro_screen.dart';
import 'sps_cotacao_screen.dart';
import 'sps_feedback_screen.dart';

class sps_menu_screen extends StatelessWidget {
//  final sps_usuario usuarioAtual;
//  sps_menu_screen({this.usuarioAtual});
  String _origemUsuario;

  @override
  Widget build(BuildContext context) {
    if (usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA") { //"INTERNO / COLIGADA/ CLIENTE / FORNECEDOR / CLIENTE-FORNECEDOR / OUTROS ")
      _origemUsuario = "INTERNO";
    }else{
      _origemUsuario = "EXTERNO";
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 80, left: 27, right: 20, bottom: 20),
                  child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => _origemUsuario == "EXTERNO"
                                ? sps_questionario_ext_filtro_screen()
                                : sps_questionario_int_filtro_screen()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    icon: Icon(Icons.receipt, color: Colors.white, size: 25.0),
                    label: Text(
                      'SISTEMA CHECKLIST (FOLLOW UP)           ',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 40, 5, 40),
                    textColor: Colors.white,
                    splashColor: Colors.white,
                    color: Color(0xFF004077),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 27, right: 20, bottom: 20),
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
                    icon:
                        Icon(Icons.equalizer, color: Colors.white, size: 25.0),
                    label: Text(
                      'GESTÃO DE FORNECEDORES (FEEDBACK)',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 40, 5, 40),
                    textColor: Colors.white,
                    splashColor: Colors.white,
                    color: Color(0xFF004077),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 27, right: 20, bottom: 20),
                  child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sps_cotacao_screen()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    icon: Icon(Icons.monetization_on,
                        color: Colors.white, size: 25.0),
                    label: Text(
                      'GESTÃO DE FORNECEDORES (COTAÇÃO) ',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 40, 5, 30),
                    textColor: Colors.white,
                    splashColor: Colors.white,
                    color: Color(0xFF004077),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 100,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Developed by Prensas Schuler Brasil',
              style: TextStyle(
                color: Color(0xFF004077),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ), // Your footer widget
        ),
        Container(
          height: 50,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Version 1.0.0\n',
              style: TextStyle(
                color: Color(0xFF004077),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ), // Your footer widget
        ),
      ],
    );
  }
}
