import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_login.dart';

class HomeSps extends StatefulWidget {

  final TextEditingController _controladorusuario;
  final TextEditingController _controladorsenha;

  HomeSps(this._controladorusuario, this._controladorsenha);

  @override
  _HomeSpsState createState() =>
      _HomeSpsState(this._controladorusuario, this._controladorsenha);

}

class _HomeSpsState extends State<HomeSps> {


  final SpsLogin spslogin = SpsLogin();

  _HomeSpsState(_controladorusuario, _controladorsenha);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seja bem vindo ao SPS'),
      ),
      // 2 - Utilizar o FutureBuilder
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: spslogin.efetuaLogin(
            this.widget._controladorusuario, widget._controladorsenha),
        //future: findAll(),
        //future: Future.delayed(Duration(seconds: 1)).then((value) => findAll()),
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
                return CenteredMessage(
                  'Falha de conexão!',
                  icon: Icons.error,
                );
              }
              if (snapshot.data.isNotEmpty) {
                return ListView(children: <Widget>[
                  Center(
                      child: FlatButton(
                        onPressed: null,
                        child: Icon(
                          Icons.account_box,
                          size: 50,
                        ),
                      )),
                  Center(
                      child: Text('Minha conta')),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Nome')),
                        DataCell(Text(snapshot.data[0]['nmfunciona'])),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Registro')),
                        DataCell(Text(snapshot.data[0]['nrregistro'])),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Departamento')),
                        DataCell(Text(snapshot.data[0]['cddepartam'])),
                      ]),
                    ],
                  ),
                ]
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
