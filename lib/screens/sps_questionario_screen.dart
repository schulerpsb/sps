import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario.dart';
import 'sps_questionario_cq_screen.dart';

class sps_questionario_screen extends StatefulWidget {
  @override
  _sps_questionario_screen createState() => _sps_questionario_screen();
}

class _sps_questionario_screen extends State<sps_questionario_screen> {
  final SpsQuestionario spsquestionario = SpsQuestionario();

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
                return ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                            '${snapshot.data[index]["codigo_programacao"]}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        subtitle: Text(
                            texto_principal
                                .wtexto_principal(snapshot.data[index]),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => sps_questionario_cq_screen(
                                snapshot.data[index]["codigo_empresa"],
                                snapshot.data[index]["codigo_programacao"],
                                snapshot.data[index]["codigo_grupo"],
                                snapshot.data[index]["codigo_checklist"],
                                snapshot.data[index]["item_checklist"],
                                snapshot.data[index]["descr_programacao"],
                                snapshot.data[index]["codigo_pedido"],
                                snapshot.data[index]["item_pedido"],
                                snapshot.data[index]["codigo_material"],
                                snapshot.data[index]["referencia_parceiro"],
                                snapshot.data[index]["codigo_projeto"],
                                snapshot.data[index]["descr_comentarios"],
                              ),
                            ),
                          );
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
}

class texto_principal {
  static String wtexto_principal(wsnapshot) {
    return wsnapshot["status"] == "PARCIAL"
        ? '${wsnapshot["descr_programacao"]}' +
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
            wsnapshot["dtfim_aplicacao"] +
            "        EVOLUÇÃO: " +
            wsnapshot["percentual_evolucao"].toStringAsPrecision(4).toString() +
            " %"
        : '${wsnapshot["descr_programacao"]}' +
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
            wsnapshot["dtfim_aplicacao"];
  }
}
