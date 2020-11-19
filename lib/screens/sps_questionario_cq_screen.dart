import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario_item.dart';
import 'package:grouped_checkbox/grouped_checkbox.dart';
import 'package:sps/screens/sps_questionario_cq_midia_screen.dart';

class sps_questionario_cq_screen extends StatefulWidget {
  //Teste Adriano
  //final String h_codigo_programacao;
  //const sps_questionario_cq_screen({Key key, this.h_codigo_programacao}): super(key: key);

  @override
  _sps_questionario_cq_screen createState() => _sps_questionario_cq_screen();
}

class _sps_questionario_cq_screen extends State<sps_questionario_cq_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  List<String> allItemList = [
    'Não se aplica',
    'Rejeitado',
    'Aprovado parcial',
    'Aprovado',
  ];

  //List<String> checkedItemList = ['Green', 'Yellow'];
  List<String> checkedItemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
      appBar: AppBar(
        backgroundColor: Color(0xFF004077),
        title: Text(
          'QUESTIONÁRIO',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                return Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 3, right: 3, bottom: 0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity, maxHeight: 100),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 5),
                        color: Color(0xFF494d4a), // Cinza
                        child: Text(
                            "descr_programacao" +
                                "\n\n" +
                                "PEDIDO: " +
                                "codigo_pedido" +
                                "/" +
                                "item_pedido" +
                                " (" +
                                "codigo_material" +
                                ")\n" +
                                "REFERÊNCIA: " +
                                "referencia_parceiro" +
                                "\nPROJETO: " +
                                "codigo_projeto",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 5),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          child: Column(children: <Widget>[
                            ListTile(
                                title: Text(
                                    '${snapshot.data[index]["seq_pergunta"]}' +
                                        " - " +
                                        '${snapshot.data[index]["descr_pergunta"]}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                subtitle: Text(""),
                                trailing: Icon(Icons.collections),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            sps_questionario_cq_midia_screen()),
                                  );
                                }),
                            GroupedCheckbox(
                                itemList: allItemList,
                                checkedItemList: checkedItemList,
                                disabled: ['Black'],
                                onChanged: (itemList) {
                                  setState(() {
                                    //selectedItemList = itemList;
                                    print('SELECTED ITEM LIST $itemList');
                                  });
                                },
                                orientation: CheckboxOrientation.HORIZONTAL,
                                checkColor: Colors.blue,
                                activeColor: Colors.red),
                          ]),
                        );
                      },
                    ),
                  ),
                ]);
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
