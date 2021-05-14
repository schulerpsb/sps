import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import 'package:sps/screens/sps_questionario_cq_lista_screen.dart';
import 'package:sps/models/sps_log.dart';

class sps_questionario_cq_ext_filtro_screen extends StatefulWidget {
  @override
  _sps_questionario_cq_ext_filtro_screen createState() =>
      _sps_questionario_cq_ext_filtro_screen();
}

class _sps_questionario_cq_ext_filtro_screen
    extends State<sps_questionario_cq_ext_filtro_screen> {
  final SpsQuestionario spsquestionario = SpsQuestionario();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CQ_EXT_FILTRO_SCREEN ");

    TextEditingController _filtroProjeto = TextEditingController();
    TextEditingController _filtroReferencia = TextEditingController();
    TextEditingController _filtroPedido = TextEditingController();

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
            'FOLLOW-UP',
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
              'EXTERNO',
              'CONTROLE DE QUALIDADE',
              'CONTAR',
              null,
              null,
              null,
              null,
              null,
              null),
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
                    '(Ponto 8) Falha de conexão! \n\n(' + werror + ')',
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
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text("PARCEIRO",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            child: montaFiltros(snapshot, context),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 10, right: 10, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    Text("Código do projeto",
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
                                              controller: _filtroProjeto,
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      ' Informe o código do projeto (WBS)'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Column(
                                  children: [
                                    Text("Referência do parceiro",
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
                                              controller: _filtroReferencia,
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      ' Informe o código de referência do parceiro'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Column(
                                  children: [
                                    Text("Código do pedido",
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
                                              controller: _filtroPedido,
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      ' Informe o código do pedido'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FloatingActionButton(
                                    onPressed: () => _filtroProjeto.text ==
                                                "" &&
                                            _filtroReferencia.text == "" &&
                                            _filtroPedido.text == ""
                                        ? {}
                                        : {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      sps_questionario_cq_lista_screen(
                                                          "EXTERNO",
                                                          null,
                                                          _filtroProjeto.text,
                                                          _filtroReferencia
                                                              .text,
                                                          _filtroPedido.text,
                                                          null)),
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

  Column montaFiltros(AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
      BuildContext context) {
    int larguraTela = MediaQuery.of(context).size.width.toInt();
    int alturaTela = MediaQuery.of(context).size.height.toInt();
    //print ("adriano =>larguraTela=>"+larguraTela.toString());
    if (larguraTela > 320) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 80,
                child: RaisedButton(
                  onPressed: () => _obter_contador(snapshot, "PENDENTE") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "PENDENTE", null, null, null, null)),
                          )
                        },
                  color: Colors.purple,
                  padding: EdgeInsets.fromLTRB(1, 15, 1, 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.grey,
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Center(
                          child: Text(" PENDENTE \n",
                              style: TextStyle(color: Colors.white,fontSize: 13))),
                      Center(
                          child: Text(
                              _obter_contador(snapshot, "PENDENTE").toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)))
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 80,
                child: RaisedButton(
                  onPressed: () => _obter_contador(snapshot, "PARCIAL") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "PARCIAL", null, null, null, null)),
                          )
                        },
                  color: Colors.orange,
                  padding: EdgeInsets.fromLTRB(1, 15, 1, 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.grey,
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Center(child: Text("   PARCIAL   \n", style: TextStyle(color: Colors.black,fontSize: 13))),
                      Center(
                          child: Text(
                              _obter_contador(snapshot, "PARCIAL").toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)))
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 80,
                child: RaisedButton(
                  onPressed: () => _obter_contador(snapshot, "OK S/FUP") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "OK S/FUP", null, null, null, null)),
                          )
                        },
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(1, 15, 1, 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.grey,
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Center(child: Text("CONCLUÍDO\n", style: TextStyle(color: Colors.black,fontSize: 13))),
                      Center(
                          child: Text(
                              _obter_contador(snapshot, "OK S/FUP").toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)))
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 80,
                child: RaisedButton(
                  onPressed: () => _obter_contador(snapshot, "OK C/FUP") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "OK C/FUP", null, null, null, null)),
                          )
                        },
                  color: Colors.blueAccent,
                  padding: EdgeInsets.fromLTRB(1, 15, 1, 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.grey,
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Center(child: Text("FOLLOW-UP\n", style: TextStyle(color: Colors.black,fontSize: 13))),
                      Center(
                          child: Text(
                              _obter_contador(snapshot, "OK C/FUP").toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _obter_contador(snapshot, "PENDENTE") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "PENDENTE", null, null, null, null)),
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
                              style: TextStyle(color: Colors.white))),
                      Center(
                          child: Text(
                              _obter_contador(snapshot, "PENDENTE").toString(),
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
                  onPressed: () => _obter_contador(snapshot, "PARCIAL") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "PARCIAL", null, null, null, null)),
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
                              _obter_contador(snapshot, "PARCIAL").toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _obter_contador(snapshot, "OK S/FUP") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "OK S/FUP", null, null, null, null)),
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
                              _obter_contador(snapshot, "OK S/FUP").toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)))
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: () => _obter_contador(snapshot, "OK C/FUP") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen("EXTERNO",
                                        "OK C/FUP", null, null, null, null)),
                          )
                        },
                  color: Colors.blueAccent,
                  padding: EdgeInsets.fromLTRB(8, 25, 8, 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Colors.grey,
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Center(child: Text("FOLLOW-UP\n")),
                      Center(
                          child: Text(
                              _obter_contador(snapshot, "OK C/FUP").toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  _obter_contador(_snapshot, _status) {
    print("Adriano=>status=>" + _snapshot.data.toString());
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
