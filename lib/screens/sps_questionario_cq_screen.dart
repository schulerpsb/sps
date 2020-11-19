import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario_item.dart';
import 'package:grouped_checkbox/grouped_checkbox.dart';
import 'package:sps/screens/sps_questionario_cq_midia_screen.dart';

class sps_questionario_cq_screen extends StatefulWidget {
  //Teste Adriano.
  //final String h_codigo_programacao;
  //const sps_questionario_cq_screen({Key key, this.h_codigo_programacao}): super(key: key);

  @override
  _sps_questionario_cq_screen createState() => _sps_questionario_cq_screen();
}

class _sps_questionario_cq_screen extends State<sps_questionario_cq_screen> {
  final SpsQuestionarioItem spsQuestionarioItem = SpsQuestionarioItem();

  var _singleValue = List();

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
          _singleValue.clear();
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
                        switch (snapshot.data[index]["seq_pergunta"]) {
                          case 'NÃO SE APLICA':
                            _singleValue.add("NÃO SE APLICA");
                            break;
                          case 'REJEITADO':
                            _singleValue.add("REJEITADO");
                            break;
                          case 'APROVADO PARCIAL':
                            _singleValue.add("APROVADO PARCIAL");
                            break;
                          case 'APROVADO':
                            _singleValue.add("APROVADO");
                            break;
                          default:
                            _singleValue.add("AA");
                            break;
                        }

                        debugPrint("tamanho:" + _singleValue.length.toString());
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
                            Row(children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 40)),
                              Container(
                                color: Color(0xFF9fbded),
                                child: CustomRadioWidget(
                                  value: "NÃO SE APLICA",
                                  groupValue: _singleValue[index],
                                  onChanged: (value) => setState(
                                    () => _singleValue[index] = value,
                                  ),
                                ),
                              ),
                              Text("          "),
                              Container(
                                color: Colors.red,
                                child: CustomRadioWidget(
                                  value: "REJEITADO",
                                  groupValue: _singleValue[index],
                                  onChanged: (value) => setState(
                                    () => _singleValue[index] = value,
                                  ),
                                ),
                              ),
                              Text("          "),
                              Container(
                                color: Colors.orange,
                                child: CustomRadioWidget(
                                  value: "APROVADO PARCIAL",
                                  groupValue: _singleValue[index],
                                  onChanged: (value) => setState(
                                    () => _singleValue[index] = value,
                                  ),
                                ),
                              ),
                              Text("          "),
                              Container(
                                color: Colors.green,
                                child: CustomRadioWidget(
                                  value: "APROVADO",
                                  groupValue: _singleValue[index],
                                  onChanged: (value) => setState(
                                    () => _singleValue[index] = value,
                                  ),
                                ),
                              ),
                              Text("          "),
                            ]),
                            Text(""),
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

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  CustomRadioWidget({this.value, this.groupValue, this.onChanged, this.width = 32, this.height = 32});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          onChanged(this.value);
        },
        child: Container(
          height: this.height,
          width: this.width,
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black,
              ],
            ),
          ),

          child: Center(
            child: Container(
              height: this.height - 5,
              width: this.width - 5,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                gradient: LinearGradient(
                  colors: value == groupValue ? [
                    Color(0xFFE13684),
                    Color(0xFFFF6EEC),
                  ] : [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}