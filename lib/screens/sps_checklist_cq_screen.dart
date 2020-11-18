import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario_item.dart';

class sps_checklist_cq_screen extends StatefulWidget {
  //Teste Adriano
  //final String h_codigo_programacao;
  //const sps_checklist_cq_screen({Key key, this.h_codigo_programacao}): super(key: key);

  @override
  _sps_checklist_cq_screen createState() => _sps_checklist_cq_screen();
}

class _sps_checklist_cq_screen extends State<sps_checklist_cq_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004077),
        title: Text(
          'FOLLOW UP - QUESTIONÁRIO',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: spsQuestionarioItem.listarQuestionarioItem(),
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
                      color: Color(0xFFded5d5),
                      child: ListTile(
                        title: Text('${snapshot.data[index]["seq_pergunta"]}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        subtitle: Text(
                            '${snapshot.data[index]["descr_pergunta"]}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.open_in_new, color: Colors.black),
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
