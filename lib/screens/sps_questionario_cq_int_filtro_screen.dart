import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import 'package:sps/screens/sps_questionario_cq_filtro_fornecedor_screen.dart';
import 'package:sps/screens/sps_questionario_cq_lista_screen.dart';

class sps_questionario_cq_int_filtro_screen extends StatefulWidget {
  final String _nome_fornecedor;

  sps_questionario_cq_int_filtro_screen(this._nome_fornecedor);

  @override
  _sps_questionario_cq_int_filtro_screen createState() =>
      _sps_questionario_cq_int_filtro_screen(this._nome_fornecedor);
}

class _sps_questionario_cq_int_filtro_screen
    extends State<sps_questionario_cq_int_filtro_screen> {
  final SpsQuestionario spsquestionario_cq = SpsQuestionario();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  _sps_questionario_cq_int_filtro_screen(_nome_fornecedor);

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CQ_INT_FILTRO_SCREEN");

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
                        builder: (context) =>
                            sps_questionario_cq_filtro_fornecedor_screen()),
                  );
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsquestionario_cq.listarQuestionario(
              'INTERNO',
              'CONTROLE DE QUALIDADE',
              'CONTAR',
              null,
              null,
              null,
              null,
              null,
              this.widget._nome_fornecedor),
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
                    '(Ponto 10) Falha de conexão! \n\n(' + werror + ')',
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
                            child: Text("APROVAÇÃO",
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
                                                          "INTERNO",
                                                          null,
                                                          _filtroProjeto.text,
                                                          _filtroReferencia
                                                              .text,
                                                          _filtroPedido.text,
                                                          this
                                                              .widget
                                                              ._nome_fornecedor)),
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
    if (larguraTela > 320) {
      return Column(
        children: [
          Row(
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
                                  sps_questionario_cq_lista_screen(
                                      "INTERNO",
                                      "PENDENTE",
                                      null,
                                      null,
                                      null,
                                      this.widget._nome_fornecedor)),
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
                                  sps_questionario_cq_lista_screen(
                                      "INTERNO",
                                      "PARCIAL",
                                      null,
                                      null,
                                      null,
                                      this.widget._nome_fornecedor)),
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
              SizedBox(
                width: 10,
              ),
              RaisedButton(
                onPressed: () => _obter_contador(snapshot, "OK") == 0
                    ? {}
                    : {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  sps_questionario_cq_lista_screen(
                                      "INTERNO",
                                      "OK",
                                      null,
                                      null,
                                      null,
                                      this.widget._nome_fornecedor)),
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
                        child: Text(_obter_contador(snapshot, "OK").toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)))
                  ],
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
                                    sps_questionario_cq_lista_screen(
                                        "INTERNO",
                                        "PENDENTE",
                                        null,
                                        null,
                                        null,
                                        this.widget._nome_fornecedor)),
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
                                    sps_questionario_cq_lista_screen(
                                        "INTERNO",
                                        "PARCIAL",
                                        null,
                                        null,
                                        null,
                                        this.widget._nome_fornecedor)),
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
                  onPressed: () => _obter_contador(snapshot, "OK") == 0
                      ? {}
                      : {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_lista_screen(
                                        "INTERNO",
                                        "OK",
                                        null,
                                        null,
                                        null,
                                        this.widget._nome_fornecedor)),
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
                              _obter_contador(snapshot, "OK").toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)))
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 92,
                ),
              ],
            ),
          ),
        ],
      );
    }
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
