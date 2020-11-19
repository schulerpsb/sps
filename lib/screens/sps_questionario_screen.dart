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
          debugPrint(snapshot.data.toString());
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
                            '${snapshot.data[index]["codigo_programacao"]}' +
                                " (" +
                                snapshot.data[index]["status"] +
                                ")",
                            style: TextStyle(
                                color: snapshot.data[index]["status"] == "OK"
                                    ? Color(0xFF0bbf1a) // Verde
                                    : snapshot.data[index]["status"] ==
                                            "PARCIAL"
                                        ? Color(0xFFfffb00) // Amarelo
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        subtitle: Text(
                            snapshot.data[index]["status"] == "PARCIAL"
                                ? '${snapshot.data[index]["descr_programacao"]}' +
                                    "\n\n" +
                                    "PEDIDO: " +
                                    '${snapshot.data[index]["codigo_pedido"]}' +
                                    "/" +
                                    '${snapshot.data[index]["item_pedido"]}' +
                                    " (" +
                                    '${snapshot.data[index]["codigo_material"]}' +
                                    ")\n" +
                                    "REFERÊNCIA: " +
                                    '${snapshot.data[index]["referencia_parceiro"]}' +
                                    "\nPROJETO: " +
                                    '${snapshot.data[index]["codigo_projeto"]}' +
                                    "\n\n" +
                                    "PRAZO: " +
                                    snapshot.data[index]["dtfim_aplicacao"] +
                                    "        EVOLUÇÃO: " +
                                    snapshot.data[index]["percentual_evolucao"]
                                        .toStringAsPrecision(4)
                                        .toString() +
                                    " %"
                                : '${snapshot.data[index]["descr_programacao"]}' +
                                    "\n\n" +
                                    "PEDIDO: " +
                                    '${snapshot.data[index]["codigo_pedido"]}' +
                                    "/" +
                                    '${snapshot.data[index]["item_pedido"]}' +
                                    " (" +
                                    '${snapshot.data[index]["codigo_material"]}' +
                                    ")\n" +
                                    "REFERÊNCIA: " +
                                    '${snapshot.data[index]["referencia_parceiro"]}' +
                                    "\nPROJETO: " +
                                    '${snapshot.data[index]["codigo_projeto"]}' +
                                    "\n\n" +
                                    "PRAZO: " +
                                    snapshot.data[index]["dtfim_aplicacao"],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.open_in_new, color: Colors.black),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    sps_questionario_cq_screen()),
                            //Teste Adriano
                            //sps_questionario_cq_screen(h_codigo_programacao: snapshot.data[index]["descr_programacao"])),
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
