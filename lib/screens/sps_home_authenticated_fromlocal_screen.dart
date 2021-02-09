import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_login_class.dart';
import 'package:sps/http/sps_http_login_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_home_authenticated_fromserver_screen.dart';
import 'package:sps/screens/sps_menu_screen.dart';

class HomeSpsAuthenticatedFromLocal extends StatefulWidget {
  @override
  _HomeSpsAuthenticatedFromLocalState createState() =>
      _HomeSpsAuthenticatedFromLocalState();
}

class _HomeSpsAuthenticatedFromLocalState
    extends State<HomeSpsAuthenticatedFromLocal> {
  final _controladorusuario = TextEditingController();
  final _controladorsenha = TextEditingController();

  _HomeSpsAuthenticatedFromLocalState();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  String textHolder = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF004077),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'images/logo_sps.png',
                  fit: BoxFit.contain,
                  height: 32,
                ),
              ],
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                );
              },
            ),
          ),
          endDrawer: sps_drawer(spslogin: spslogin),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: spslogin.verificaUsuarioAutenticado(),
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
                    //Usuário ja tem usuário local autenticado
                    //Ir direto para o menu
                    //final dadossessao = sps_usuario();
                    //dadossessao.name = snapshot.data[0]['codigo_usuario'].toString();
                    return sps_menu_screen();
                  } else {
                    return Container(
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
                                        return HomeSpsAuthenticatedFromServer(
                                            _controladorusuario,
                                            _controladorsenha);
                                      },
                                    ),
                                  );
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Favor Preencher usuário e senha!'),
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
                              },
                            );
                          }),
                        ],
                      ),
                    );
                  }
                  break;
              }
              return Text('Unkown error');
            },
          ),
        ));
  }
}


