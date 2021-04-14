import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sps/models/sps_sincronizacao.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_questionario_ch_filtro_screen.dart';
import 'package:sps/screens/sps_questionario_cq_ext_filtro_screen.dart';
import 'package:sps/screens/sps_questionario_cq_int_filtro_screen.dart';
import 'sps_cotacao_screen.dart';
import 'sps_feedback_screen.dart';
import 'package:sps/models/sps_notificacao.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class sps_menu_screen extends StatelessWidget {
//  final sps_usuario usuarioAtual;
//  sps_menu_screen({this.usuarioAtual});
  String _origemUsuario;


  @override
  Widget build(BuildContext context) {
    int larguraTela = MediaQuery.of(context).size.width.toInt();
    int alturaTela = MediaQuery.of(context).size.height.toInt();
    //Debug de sincronização
    //spsSincronizacao.sincronizarQuestionarios();

    if (usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA") { //"INTERNO / COLIGADA/ CLIENTE / FORNECEDOR / CLIENTE-FORNECEDOR / OUTROS ")
      _origemUsuario = "INTERNO";
    }else{
      _origemUsuario = "EXTERNO";
    }
    return ListView(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(height: 30),
              Container(
                width: larguraTela > 320 ? 360 : 300,
                height: larguraTela > 320 ? 80 : 65,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => _origemUsuario == "EXTERNO"
                              ? sps_questionario_cq_ext_filtro_screen()
                              : sps_questionario_cq_int_filtro_screen()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    'FOLLOW-UP',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.red,
                  color: Color(0xFF004077),
                ),
              ),
              Container(height: 10),
              Container(
                width: larguraTela > 320 ? 360 : 300,
                height: larguraTela > 320 ? 80 : 65,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => sps_questionario_ch_filtro_screen("CHECKLIST")),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    'CHECKLIST',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.fact_check_outlined,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.red,
                  color: Color(0xFF004077),
                ),
              ),
              Container(height: 10),
              Container(
                width: larguraTela > 320 ? 360 : 300,
                height: larguraTela > 320 ? 80 : 65,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => sps_questionario_ch_filtro_screen("PESQUISA")),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    'PESQUISA',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.web,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.red,
                  color: Color(0xFF004077),
                ),
              ),
              Container(height: 40),
              Container(
                width: larguraTela > 320 ? 360 : 300,
                height: larguraTela > 320 ? 80 : 65,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => sps_feedback_screen()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    'GESTÃO DE FORNECEDORES (FEEDBACK)',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: larguraTela > 320 ? 14.0 : 10.0,
                    ),
                  ),
                  icon: Icon(
                    Icons.equalizer,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.red,
                  color: Color(0xFF004077),
                ),
              ),
              Container(height: 30),
              Container(
                width: larguraTela > 320 ? 360 : 300,
                height: larguraTela > 320 ? 80 : 65,
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => sps_cotacao_screen()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0))),
                  label: Text(
                    'GESTÃO DE FORNECEDORES (COTAÇÃO)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: larguraTela > 320 ? 14.0 : 10.0,
                    ),
                  ),
                  icon: Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.red,
                  color: Color(0xFF004077),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: larguraTela > 320 ? 50 : 30,
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
          height: 20,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Version 1.0.0 (12/04/2021)\n',
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


