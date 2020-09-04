import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_login_class.dart';
import 'package:sps/http/sps_http_login_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/screens/sps_home_screen.dart';

class SpsLoginScreen extends StatefulWidget {
  @override
  _SpsLoginScreenState createState() => _SpsLoginScreenState();
}

class _SpsLoginScreenState extends State<SpsLoginScreen> {
  final _controladorusuario = TextEditingController();
  final _controladorsenha = TextEditingController();

  _SpsLoginScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'images/logo_sps.png',
            fit: BoxFit.contain,
            height: 32,
          ),
          Icon(Icons.person),
        ],
      )),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controladorusuario,
                style: TextStyle(
                  fontSize: 24.8,
                ),
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Usuário',
                  hintText: 'Digite o Usuário',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controladorsenha,
                style: TextStyle(
                  fontSize: 24.8,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: 'Senha',
                  hintText: 'Digite a senha',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Builder(builder: (context) {
              return RaisedButton(
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 24.8,
                  ),
                ),
                onPressed: () {
                  if (_controladorusuario != null &&
                      _controladorsenha != null &&
                      _controladorusuario.text != "" &&
                      _controladorsenha.text != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeSps(
                              _controladorusuario, _controladorsenha);
                        },
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Favor Preencher usuário e senha!'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
//                  final SpsLogin spsLogin = SpsLogin();
//                  spsLogin.efetuaLogin(context,_controladorusuario,_controladorsenha);
                  //SpsLoginClass.efetuaLogin(context,_controladorusuario,_controladorsenha);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
