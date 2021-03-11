import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import 'package:sps/screens/sps_questionario_ch_lista_screen.dart';

class sps_questionario_ch_filtro_screen extends StatefulWidget {
  final String _tipo_questionario;

  sps_questionario_ch_filtro_screen(
    this._tipo_questionario,
  );

  @override
  _sps_questionario_ch_filtro_screen createState() =>
      _sps_questionario_ch_filtro_screen();
}

class _sps_questionario_ch_filtro_screen
    extends State<sps_questionario_ch_filtro_screen> {
  final SpsQuestionario spsquestionario = SpsQuestionario();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CH_FILTRO_SCREEN");

    TextEditingController _filtroDescrProgramacao = TextEditingController();

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
        appBar: AppBar(
          backgroundColor: Color(0xFF004077),
          // Azul Schuler
          title: Text(
            this.widget._tipo_questionario,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeSpsAuthenticatedFromLocal()),
                  );
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsquestionario.listarQuestionario(
              'INTERNO',
              this.widget._tipo_questionario,
              'CONTAR',
              null,
              null,
              _filtroDescrProgramacao),
          builder: (context, snapshot) {
            //debugPrint(snapshot.data.toString());
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Progress();
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  var werror;
                  werror = snapshot.error.toString();
                  return CenteredMessage(
                    'Falha de conexão! \n\n(' + werror + ')',
                    icon: Icons.error,
                  );
                }
                if (erroConexao.msg_erro_conexao.toString() == "") {
                  if (snapshot.data.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () =>
                                      _obter_contador(snapshot, "PENDENTE") == 0
                                          ? {}
                                          : {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        sps_questionario_ch_lista_screen(
                                                            "PENDENTE",
                                                            null,
                                                            this
                                                                .widget
                                                                ._tipo_questionario)),
                                              )
                                            },
                                  color: Colors.purple,
                                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.grey,
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Center(
                                          child: Text(" PENDENTE \n",
                                              style: TextStyle(
                                                  color: Colors.white))),
                                      Center(
                                          child: Text(
                                              _obter_contador(
                                                      snapshot, "PENDENTE")
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                RaisedButton(
                                  onPressed: () =>
                                      _obter_contador(snapshot, "PARCIAL") == 0
                                          ? {}
                                          : {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        sps_questionario_ch_lista_screen(
                                                            "PARCIAL",
                                                            null,
                                                            this
                                                                .widget
                                                                ._tipo_questionario)),
                                              )
                                            },
                                  color: Colors.orange,
                                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.grey,
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Center(child: Text("   PARCIAL   \n")),
                                      Center(
                                          child: Text(
                                              _obter_contador(
                                                      snapshot, "PARCIAL")
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                RaisedButton(
                                  onPressed: () =>
                                      _obter_contador(snapshot, "OK") == 0
                                          ? {}
                                          : {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        sps_questionario_ch_lista_screen(
                                                            "OK",
                                                            null,
                                                            this
                                                                .widget
                                                                ._tipo_questionario)),
                                              )
                                            },
                                  color: Colors.green,
                                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.grey,
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Center(child: Text("CONCLUÍDO\n")),
                                      Center(
                                          child: Text(
                                              _obter_contador(snapshot, "OK")
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Text("Descrição do checklist",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Card(
                                  color: Colors.white,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: _filtroDescrProgramacao,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Informe a descrição'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FloatingActionButton(
                                    onPressed: () =>
                                        _filtroDescrProgramacao.text == ""
                                            ? {}
                                            : {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          sps_questionario_ch_lista_screen(
                                                              null,
                                                              _filtroDescrProgramacao
                                                                  .text,
                                                              this
                                                                  .widget
                                                                  ._tipo_questionario)),
                                                )
                                              },
                                    child: const Icon(Icons.search),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return CenteredMessage(
                      'NÃO FOI ENCONTRADO NENHUM REGISTRO!',
                      icon: Icons.warning,
                    );
                  }
                } else {
                  return CenteredMessage(
                    erroConexao.msg_erro_conexao.toString(),
                    icon: Icons.warning,
                  );
                }
                break;
            }
            return Text('Unkown error');
          },
        ),
      ),
    );
  }

  _obter_contador(_snapshot, _status) {
    var wregistros = _snapshot.data.length;
    var windex = 0;
    while (windex < wregistros) {
      if (_snapshot.data[windex]["status"] == _status) {
        return _snapshot.data[windex]["contador"];
      }
      windex = windex + 1;
    }
    return 0;
  }
}
