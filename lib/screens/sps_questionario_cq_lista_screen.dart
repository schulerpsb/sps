import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_cq_int_item_screen.dart';
import 'package:sps/screens/sps_questionario_cq_ext_filtro_screen.dart';
import 'package:sps/screens/sps_questionario_cq_int_filtro_screen.dart';
import 'sps_questionario_cq_ext_item_screen.dart';
import 'package:intl/intl.dart';

class sps_questionario_cq_lista_screen extends StatefulWidget {
  final String _origemUsuario;
  final String _filtro;
  final String _filtroProjeto;
  final String _filtroReferencia;
  final String _filtroPedido;
  final String _nomeFornecedor;

  sps_questionario_cq_lista_screen(
      this._origemUsuario,
      this._filtro,
      this._filtroProjeto,
      this._filtroReferencia,
      this._filtroPedido,
      this._nomeFornecedor);

  @override
  _sps_questionario_cq_lista_screen createState() =>
      _sps_questionario_cq_lista_screen(
          this._origemUsuario,
          this._filtro,
          this._filtroProjeto,
          this._filtroReferencia,
          this._filtroPedido,
          this._nomeFornecedor);
}

class _sps_questionario_cq_lista_screen
    extends State<sps_questionario_cq_lista_screen> {
  final SpsQuestionario spsquestionario_cq = SpsQuestionario();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  _sps_questionario_cq_lista_screen(_origemUsuario, _filtro, _filtroProjeto,
      _filtroReferencia, _filtroPedido, _nomeFornecedor);

  var formato = new NumberFormat("##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CQ_LISTA_SCREEN");
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
            'FOLLOW UP',
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
                            this.widget._origemUsuario == "EXTERNO"
                                ? sps_questionario_cq_ext_filtro_screen()
                                : sps_questionario_cq_int_filtro_screen(
                                    this.widget._nomeFornecedor)),
                  );
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsquestionario_cq.listarQuestionario(
              this.widget._origemUsuario,
              'CONTROLE DE QUALIDADE',
              'LISTAR',
              this.widget._filtro,
              this.widget._filtroProjeto,
              this.widget._filtroReferencia,
              this.widget._filtroPedido,
              null,
              this.widget._nomeFornecedor),
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
                    '(Ponto 12) Falha de conexão! \n\n(' + werror + ')',
                    icon: Icons.error,
                  );
                }
                if (erroConexao.msg_erro_conexao.toString() == "") {
                  if (snapshot.data.isNotEmpty) {
                    final DateFormat formatter = DateFormat('yyyyMMdd');
                    final String _dataAtual =
                        formatter.format(DateTime.now()).toString();

                    return ListView.builder(
                      padding: EdgeInsets.only(top: 5),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        String _wdtfim_aplicacao = snapshot.data[index]
                                ["dtfim_aplicacao"]
                            .replaceAll("-", "");
                        String _wdtvalidade_checklist = snapshot.data[index]
                                ["dtvalidade_checklist"]
                            .replaceAll("-", "");
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              int.parse(_wdtfim_aplicacao) >
                                          int.parse(_dataAtual) &&
                                      int.parse(_wdtvalidade_checklist) >
                                          int.parse(_dataAtual)
                                  ? '${snapshot.data[index]["codigo_programacao"]}'
                                  : '${snapshot.data[index]["codigo_programacao"]}' +
                                      " (PRAZO VENCIDO)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: int.parse(_wdtfim_aplicacao) >
                                              int.parse(_dataAtual) &&
                                          int.parse(_wdtvalidade_checklist) >
                                              int.parse(_dataAtual)
                                      ? Colors.black
                                      : Colors.red),
                            ),
                            subtitle: prepararTextoPrincipal(snapshot, index),
                            trailing: snapshot.data[index]["status"] == "OK"
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 40,
                                  )
                                : snapshot.data[index]["status"] == "PARCIAL"
                                    ? Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.yellow,
                                        size: 40,
                                      )
                                    : Icon(
                                        Icons.timer,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                            onTap: () {
                              int.parse(_wdtfim_aplicacao) >
                                          int.parse(_dataAtual) &&
                                      int.parse(_wdtvalidade_checklist) >
                                          int.parse(_dataAtual)
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => this
                                                      .widget
                                                      ._origemUsuario ==
                                                  "EXTERNO"
                                              ? sps_questionario_cq_ext_item_screen(
                                                  snapshot.data[index]
                                                      ["codigo_empresa"],
                                                  snapshot.data[index]
                                                      ["codigo_programacao"],
                                                  snapshot.data[index]
                                                      ["registro_colaborador"],
                                                  snapshot.data[index][
                                                      "identificacao_utilizador"],
                                                  snapshot.data[index]
                                                      ["codigo_grupo"],
                                                  snapshot.data[index]
                                                      ["codigo_checklist"],
                                                  snapshot.data[index]
                                                      ["descr_programacao"],
                                                  snapshot.data[index]
                                                      ["codigo_pedido"],
                                                  snapshot.data[index]
                                                      ["item_pedido"],
                                                  snapshot.data[index]
                                                      ["codigo_material"],
                                                  snapshot.data[index]
                                                      ["referencia_parceiro"],
                                                  snapshot.data[index]
                                                      ["nome_fornecedor"],
                                                  snapshot.data[index]
                                                      ["qtde_pedido"],
                                                  snapshot.data[index]
                                                      ["codigo_projeto"],
                                                  snapshot.data[index]
                                                      ["sincronizado"],
                                                  snapshot.data[index]
                                                      ["status_aprovacao"],
                                                  this.widget._origemUsuario,
                                                  this.widget._filtro,
                                                  0,
                                                  this.widget._filtroProjeto,
                                                  this.widget._filtroReferencia,
                                                  this.widget._filtroPedido,
                                                )
                                              : sps_questionario_cq_int_item_screen(
                                                  snapshot.data[index]
                                                      ["codigo_empresa"],
                                                  snapshot.data[index]
                                                      ["codigo_programacao"],
                                                  snapshot.data[index]
                                                      ["registro_colaborador"],
                                                  snapshot.data[index][
                                                      "identificacao_utilizador"],
                                                  snapshot.data[index]
                                                      ["codigo_grupo"],
                                                  snapshot.data[index]
                                                      ["codigo_checklist"],
                                                  snapshot.data[index]
                                                      ["descr_programacao"],
                                                  snapshot.data[index]
                                                      ["codigo_pedido"],
                                                  snapshot.data[index]
                                                      ["item_pedido"],
                                                  snapshot.data[index]
                                                      ["codigo_material"],
                                                  snapshot.data[index]
                                                      ["referencia_parceiro"],
                                                  snapshot.data[index]
                                                      ["nome_fornecedor"],
                                                  snapshot.data[index]
                                                      ["qtde_pedido"],
                                                  snapshot.data[index]
                                                      ["codigo_projeto"],
                                                  snapshot.data[index]
                                                      ["sincronizado"],
                                                  snapshot.data[index]
                                                      ["status_aprovacao"],
                                                  this.widget._origemUsuario,
                                                  this.widget._filtro,
                                                  0,
                                                  this.widget._filtroProjeto,
                                                  this.widget._filtroReferencia,
                                                  this.widget._filtroPedido,
                                                )),
                                    )
                                  : _popup_vencido(context);
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return CenteredMessage(
                      'Checklist não encontrado',
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

  RichText prepararTextoPrincipal(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
    if (this.widget._origemUsuario.toString() == "EXTERNO") {}

    return RichText(
      text: new TextSpan(
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        children: <TextSpan>[
          new TextSpan(
              text: snapshot.data[index]["descr_programacao"] + "\n\n"),
          new TextSpan(
            text: this.widget._origemUsuario == "INTERNO"
                ? "PARCEIRO:       "
                : "",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(
              text: this.widget._origemUsuario == "INTERNO"
                  ? snapshot.data[index]["nome_fornecedor"] + "\n"
                  : "\n"),
          new TextSpan(
            text: "PEDIDO:            ",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(
              text: snapshot.data[index]["codigo_pedido"] +
                  " / " +
                  snapshot.data[index]["item_pedido"]),
          new TextSpan(
              text: " (" + snapshot.data[index]["codigo_material"] + ")\n",
              style: TextStyle(color: Colors.blue)),
          new TextSpan(
            text: snapshot.data[index]["referencia_parceiro"] != ""
                ? "REFERÊNCIA:  "
                : "",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(
              text: snapshot.data[index]["referencia_parceiro"] != ""
                  ? snapshot.data[index]["referencia_parceiro"] + "\n"
                  : ""),
          new TextSpan(
            text: "PROJETO:        ",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(text: snapshot.data[index]["codigo_projeto"] + "\n"),
          new TextSpan(
            text: "QUANTIDADE: ",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(
              text: snapshot.data[index]["qtde_pedido"].toString() + "\n\n"),
          new TextSpan(
            text: "DT.FIM CHECKLIST:             ",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(
              text: snapshot.data[index]["dtfim_aplicacao"].substring(8, 10) +
                  "/" +
                  snapshot.data[index]["dtfim_aplicacao"].substring(5, 7) +
                  "/" +
                  snapshot.data[index]["dtfim_aplicacao"].substring(0, 4) +
                  "\n"),
          new TextSpan(
            text: snapshot.data[index]["status"] == "PARCIAL" ||
                    snapshot.data[index]["status"] == "PENDENTE"
                ? "EVOLUÇÃO FORNECEDOR: "
                : "",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(
              text: (snapshot.data[index]["status"] == "PARCIAL" ||
                          snapshot.data[index]["status"] == "PENDENTE") &&
                      this.widget._origemUsuario == "INTERNO"
                  ? formato
                          .format(snapshot.data[index]
                                      ["percentual_evolucao_fornecedor"] >=
                                  99.9
                              ? 100
                              : snapshot.data[index]
                                  ["percentual_evolucao_fornecedor"])
                          .toString() +
                      " %\n"
                  : ""),
          new TextSpan(
              text: (snapshot.data[index]["status"] == "PARCIAL" ||
                          snapshot.data[index]["status"] == "PENDENTE") &&
                      this.widget._origemUsuario == "EXTERNO"
                  ? formato
                          .format(snapshot.data[index]["percentual_evolucao"] >=
                                  99.9
                              ? 100
                              : snapshot.data[index]["percentual_evolucao"])
                          .toString() +
                      " %\n"
                  : ""),
          new TextSpan(
            text: snapshot.data[index]["status"] == "PARCIAL" &&
                    this.widget._origemUsuario == "INTERNO"
                ? "APROVAÇÃO FUP:                "
                : "",
            style: TextStyle(color: Colors.grey),
          ),
          new TextSpan(
              text: snapshot.data[index]["status"] == "PARCIAL" &&
                      this.widget._origemUsuario == "INTERNO"
                  ? formato
                          .format(snapshot.data[index]["percentual_evolucao"] >=
                                  99.9
                              ? 100
                              : snapshot.data[index]["percentual_evolucao"])
                          .toString() +
                      " %\n"
                  : ""),
        ],
      ),
    );
  }

  _popup_vencido(context) {
    Alert(
      context: context,
      title: "ATENÇÃO!\n",
      content: Column(
        children: [
          Text(
              "Prazo para preenchimento está vencido.\n\nEntre em contato com o responsável na PRENSAS SCHULER.",
              style: TextStyle(color: Colors.red, fontSize: 15)),
        ],
      ),
      buttons: [
        DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop())
      ],
    ).show();
  }
}
