import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_questionario.dart';

class sps_checklist_screen extends StatefulWidget {
  @override
  _sps_checklist_screen createState() => _sps_checklist_screen();
}

class _sps_checklist_screen extends State<sps_checklist_screen> {
  final SpsQuestionario spsquestionario = SpsQuestionario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff06044C),
        title: Text(
          'CHECKLIST (Follow up)',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: spsquestionario.listarQuestionario(),
        builder: (context, snapshot) {
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
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.receipt),
                      title: Text('${snapshot.data[index]["codigo_empresa"]}' + "  " + '${snapshot.data[index]["descr_programacao"]}'),
                      subtitle: Text(snapshot.data[index]["status"]),
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
