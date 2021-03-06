import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_erro_conexao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_questionario_ch_item_screen.dart';
import 'package:sps/screens/sps_questionario_ch_filtro_screen.dart';
import 'sps_questionario_ch_item_screen.dart';
import 'package:intl/intl.dart';

class sps_questionario_ch_lista_screen extends StatefulWidget {
  final String _filtro;
  final String _filtroDescrProgramacao;
  final String _tipoQuestionario;

  sps_questionario_ch_lista_screen(
      this._filtro, this._filtroDescrProgramacao, this._tipoQuestionario);

  @override
  _sps_questionario_ch_lista_screen createState() =>
      _sps_questionario_ch_lista_screen(
          this._filtro, this._filtroDescrProgramacao, this._tipoQuestionario);
}

class _sps_questionario_ch_lista_screen
    extends State<sps_questionario_ch_lista_screen> {
  final SpsQuestionario spsquestionario = SpsQuestionario();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  _sps_questionario_ch_lista_screen(
      _filtro, _filtroDescrProgramacao, _tipoQuestionario);

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_CH_LISTA_SCREEN");

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
            this.widget._tipoQuestionario,
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
                        builder: (context) => sps_questionario_ch_filtro_screen(
                            this.widget._tipoQuestionario)),
                  );
                },
              );
            },
          ),
        ),
        endDrawer: sps_drawer(spslogin: spslogin),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsquestionario.listarQuestionario(
              null,
              this.widget._tipoQuestionario,
              'LISTAR',
              this.widget._filtro,
              null,
              null,
              null,
              this.widget._filtroDescrProgramacao,
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
                    '(Ponto 1) Falha de conexão! \n\n(' + werror + ')',
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
                                          builder: (context) =>
                                              sps_questionario_ch_item_screen(
                                                  snapshot.data[index][
                                                      "codigo_empresa"],
                                                  snapshot.data[index][
                                                      "codigo_programacao"],
                                                  snapshot.data[index][
                                                      "registro_colaborador"],
                                                  snapshot.data[
                                                          index]
                                                      [
                                                      "identificacao_utilizador"],
                                                  snapshot.data[index][
                                                      "codigo_grupo"],
                                                  snapshot
                                                              .data[
                                                          index][
                                                      "codigo_checklist"],
                                                  snapshot
                                                              .data[
                                                          index]
                                                      ["descr_programacao"],
                                                  snapshot.data[index]
                                                      ["sincronizado"],
                                                  snapshot.data[index]
                                                      ["status_aprovacao"],
                                                  this.widget._filtro,
                                                  this
                                                      .widget
                                                      ._filtroDescrProgramacao,
                                                  "PROXIMO",
                                                  "",
                                                  0,
                                                  this
                                                      .widget
                                                      ._tipoQuestionario)),
                                    )
                                  : _popup_vencido(context);
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return CenteredMessage(
                      'Checklist não encontrado.',
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

RichText prepararTextoPrincipal(
    AsyncSnapshot<List<Map<String, dynamic>>> snapshot, int index) {
  var formato = new NumberFormat("##0.00", "en_US");
  return RichText(
    text: new TextSpan(
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      children: <TextSpan>[
        new TextSpan(text: snapshot.data[index]["descr_programacao"] + "\n\n"),
        new TextSpan(
          text: "DT.FIM CHECKLIST: ",
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
          text: snapshot.data[index]["status"] == "PARCIAL" ? "EVOLUÇÃO: " : "",
          style: TextStyle(color: Colors.grey),
        ),
        new TextSpan(
            text: snapshot.data[index]["status"] == "PARCIAL"
                ? formato
                        .format(snapshot.data[index]["percentual_evolucao"])
                        .toString() +
                    " %\n"
                : ""),
      ],
    ),
  );
}
