import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sps/models/sps_sincronizacao.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_log_screen.dart';
import 'package:sps/screens/sps_questionario_ch_filtro_screen.dart';
import 'package:sps/screens/sps_questionario_cq_ext_filtro_screen.dart';
import 'package:sps/screens/sps_questionario_cq_filtro_fornecedor_screen.dart';
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

    if (usuarioAtual.tipo == "INTERNO" || usuarioAtual.tipo == "COLIGADA") {
      //"INTERNO / COLIGADA/ CLIENTE / FORNECEDOR / CLIENTE-FORNECEDOR / OUTROS ")
      _origemUsuario = "INTERNO";
    } else {
      _origemUsuario = "EXTERNO";
    }
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: larguraTela > 320 ? ((larguraTela - 27) / 2).toDouble() : 150,
                      height: larguraTela > 320 ? 100 : 100,
                      padding: EdgeInsets.fromLTRB(2, 2, 5, 5),
                      child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => _origemUsuario == "EXTERNO"
                                    ? sps_questionario_cq_ext_filtro_screen()
                                    : sps_questionario_cq_filtro_fornecedor_screen()),
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
                    Container(
                      width: larguraTela > 320 ? ((larguraTela - 27) / 2).toDouble() : 150,
                      height: larguraTela > 320 ? 100 : 100,
                      padding: EdgeInsets.fromLTRB(2, 0, 5, 5),
                      child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_ch_filtro_screen(
                                        "CHECKLIST")),
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
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: larguraTela > 320 ? ((larguraTela - 27) / 2).toDouble(): 150,
                      height: larguraTela > 320 ? 100 : 100,
                      padding: EdgeInsets.fromLTRB(2, 0, 5, 5),
                      child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_ch_filtro_screen(
                                        "PESQUISA")),
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
                    Container(
                      width: larguraTela > 320 ? ((larguraTela - 27) / 2).toDouble() : 150,
                      height: larguraTela > 320 ? 100 : 100,
                      padding: EdgeInsets.fromLTRB(2, 0, 5, 5),
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
                          'PERFIL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: larguraTela > 320 ? 14.0 : 10.0,
                          ),
                        ),
                        icon: Icon(
                          Icons.assignment_outlined,
                          color: Colors.white,
                        ),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Color(0xFF004077),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: larguraTela > 320 ? (larguraTela - 30).toDouble() : 270,
                      height: larguraTela > 320 ? 90 : 65,
                      padding: EdgeInsets.fromLTRB(2, 10, 0, 2),
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
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: larguraTela > 320 ? (larguraTela - 30).toDouble() : 270,
                      height: larguraTela > 320 ? 90 : 65,
                      padding: EdgeInsets.fromLTRB(2, 5, 2, 2),
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
                          'NOTIFICAÇÃO DE QUALIDADE',
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
                Row(
                  children: [
                    Container(
                      width: larguraTela > 320 ? (larguraTela - 30).toDouble() : 270,
                      height: larguraTela > 320 ? 90 : 65,
                      padding: EdgeInsets.fromLTRB(2, 5, 2, 2),
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
                          'NOTIFICAÇÃO DE MODIFICAÇÃO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: larguraTela > 320 ? 14.0 : 10.0,
                          ),
                        ),
                        icon: Icon(
                          Icons.sd_card_alert_outlined,
                          color: Colors.white,
                        ),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Color(0xFF004077),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              'Version 1.0.0 (07/05/2021)\n',
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
