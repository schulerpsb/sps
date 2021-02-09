import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario_cq.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import 'package:sps/screens/sps_menu_screen.dart';
import 'package:sps/screens/sps_questionario_cq_lista_screen.dart';

class sps_questionario_ext_filtro_screen extends StatefulWidget {
  @override
  _sps_questionario_ext_filtro_screen createState() =>
      _sps_questionario_ext_filtro_screen();
}

class _sps_questionario_ext_filtro_screen
    extends State<sps_questionario_ext_filtro_screen> {
  final SpsQuestionario_cq spsquestionario = SpsQuestionario_cq();

  @override
  Widget build(BuildContext context) {
    debugPrint("TELA => SPS_QUESTIONARIO_EXT_FILTRO_SCREEN");

    TextEditingController _filtroReferenciaProjeto = TextEditingController();

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
            'CHECKLIST',
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
                    MaterialPageRoute(builder: (context) => HomeSpsAuthenticatedFromLocal()),
                  );
                },
              );
            },
          ),
        ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: spsquestionario.listarQuestionario_cq(
              'EXTERNO', 'CONTAR', null, null),
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
                          child: Text("FOLLOW UP",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () =>
                                    _obter_contador(snapshot, "PENDENTE") == 0
                                        ? {}
                                        : {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      sps_questionario_cq_lista_screen(
                                                          "EXTERNO",
                                                          "PENDENTE",
                                                          null)),
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
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Center(
                                        child: Text(
                                            _obter_contador(
                                                    snapshot, "PENDENTE")
                                                .toString(),
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
                                onPressed: () =>
                                    _obter_contador(snapshot, "PARCIAL") == 0
                                        ? {}
                                        : {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      sps_questionario_cq_lista_screen(
                                                          "EXTERNO",
                                                          "PARCIAL",
                                                          null)),
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
                                            _obter_contador(snapshot, "PARCIAL")
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              RaisedButton(
                                onPressed: () =>
                                    _obter_contador(snapshot, "OK") == 0
                                        ? {}
                                        : {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      sps_questionario_cq_lista_screen(
                                                          "EXTERNO",
                                                          "OK",
                                                          null)),
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
                                            _obter_contador(snapshot, "OK")
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 10, right: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
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
                                        controller: _filtroReferenciaProjeto,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Informa a referência do parceiro'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: FloatingActionButton(
                                  onPressed: () =>
                                      _filtroReferenciaProjeto.text == ""
                                          ? {}
                                          : {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        sps_questionario_cq_lista_screen(
                                                            "EXTERNO",
                                                            null,
                                                            _filtroReferenciaProjeto
                                                                .text)),
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
                    'No transaction found!',
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
