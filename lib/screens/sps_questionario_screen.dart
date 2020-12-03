import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario.dart';
import 'sps_questionario_cq_screen.dart';
import 'package:intl/intl.dart';

class sps_questionario_screen extends StatefulWidget {
  @override
  _sps_questionario_screen createState() => _sps_questionario_screen();
}

class _sps_questionario_screen extends State<sps_questionario_screen> {
  final MediaPlayer spsquestionario = MediaPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
      appBar: AppBar(
        backgroundColor: Color(0xFF004077), // Azul Schuler
        title: Text(
          'FOLLOW UP',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: spsquestionario.listarQuestionario(),
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
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          int.parse(_wdtfim_aplicacao) > int.parse(_dataAtual)
                              ? '${snapshot.data[index]["codigo_programacao"]}'
                              : '${snapshot.data[index]["codigo_programacao"]}' +
                                  " (PRAZO VENCIDO)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: int.parse(_wdtfim_aplicacao) >
                                      int.parse(_dataAtual)
                                  ? Colors.black
                                  : Colors.red),
                        ),
                        subtitle: Text(
                            texto_principal
                                .wtexto_principal(snapshot.data[index]),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
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
                          int.parse(_wdtfim_aplicacao) > int.parse(_dataAtual)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          sps_questionario_cq_screen(
                                            snapshot.data[index]
                                                ["codigo_empresa"],
                                            snapshot.data[index]
                                                ["codigo_programacao"],
                                            snapshot.data[index]
                                                ["codigo_grupo"],
                                            snapshot.data[index]
                                                ["codigo_checklist"],
                                            snapshot.data[index]
                                                ["item_checklist"],
                                            snapshot.data[index]
                                                ["descr_programacao"],
                                            snapshot.data[index]
                                                ["codigo_pedido"],
                                            snapshot.data[index]["item_pedido"],
                                            snapshot.data[index]
                                                ["codigo_material"],
                                            snapshot.data[index]
                                                ["referencia_parceiro"],
                                            snapshot.data[index]
                                                ["codigo_projeto"],
                                            snapshot.data[index]
                                                ["descr_comentarios"],
                                            snapshot.data[index]
                                                ["status_resposta"],
                                            snapshot.data[index]
                                                ["status_aprovacao"],
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
                  'No transaction found!',
                  icon: Icons.warning,
                );
              }
              break;
          }
          return Text('Unkown error');
        },
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
              style: TextStyle(color: Colors.red, fontSize: 20)),
        ],
      ),
      buttons: [
        DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop())
      ],
    ).show();
  }
}

class texto_principal {
  static String wtexto_principal(wsnapshot) {
    String _texto_principal;

    final String _dtfim_aplicacao =
        wsnapshot["dtfim_aplicacao"].substring(8, 10) +
            "/" +
            wsnapshot["dtfim_aplicacao"].substring(5, 7) +
            "/" +
            wsnapshot["dtfim_aplicacao"].substring(0, 4);

    _texto_principal = '${wsnapshot["descr_programacao"]}' +
        "\n\n" +
        "PEDIDO: " +
        '${wsnapshot["codigo_pedido"]}' +
        "/" +
        '${wsnapshot["item_pedido"]}' +
        " (" +
        '${wsnapshot["codigo_material"]}' +
        ")\n" +
        "REFERÊNCIA: " +
        '${wsnapshot["referencia_parceiro"]}' +
        "\nPROJETO: " +
        '${wsnapshot["codigo_projeto"]}' +
        "\n\n" +
        "PRAZO: " +
        _dtfim_aplicacao;

    if (wsnapshot["status"] == "PARCIAL") {
      _texto_principal = _texto_principal +
          "        EVOLUÇÃO: " +
          wsnapshot["percentual_evolucao"].toStringAsPrecision(4).toString() +
          " %";
    }

    return _texto_principal;
  }
}
