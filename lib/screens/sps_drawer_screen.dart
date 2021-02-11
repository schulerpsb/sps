import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';

class sps_drawer extends StatelessWidget {
  const sps_drawer({
    Key key,
    @required this.spslogin,
  }) : super(key: key);

  final SpsLogin spslogin;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
              return Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(
                      height: 88.0,
                      child: new DrawerHeader(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeSpsAuthenticatedFromLocal();
                                    },
                                  ),
                                );
                              },
                              child: Text("Schuler production system",style: TextStyle(color: Colors.white)),
                            ),
                            usuarioAtual.mensagem == "nao_permitir_trocar" ?
                            IconButton(
                              icon: const Icon(Icons.cloud_off, color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeSpsAuthenticatedFromLocal();
                                    },
                                  ),
                                );
                              },
                            ): Text(''),
                          ],
                        ),
                        decoration: new BoxDecoration(color: Color(0xFF004077)),
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: ListTile(
                        title: Text("Usuário: "+snapshot.data[0]['codigo_usuario'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: ListTile(
                        title: Text("Nome: "+snapshot.data[0]['nome_usuario'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: ListTile(
                        title: Text("E-mail: "+snapshot.data[0]['email_usuario'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80.0,
                      child: ListTile(
                        title: Text("Tipo: "+snapshot.data[0]['tipo'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    usuarioAtual.mensagem == "permitir_trocar" ?
                    SizedBox(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              spslogin.logoutUser();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomeSpsAuthenticatedFromLocal();
                                  },
                                ),
                              );
                            },
                          ),
                          FlatButton(
                            onPressed: () {
                              spslogin.logoutUser();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomeSpsAuthenticatedFromLocal();
                                  },
                                ),
                              );
                            },
                            child: Text("Trocar Usuário"),
                          ),
                        ],
                      ),
                    ) : Text(''),
                    SizedBox(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.exit_to_app),
                            onPressed: () {
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            },
                          ),
                          FlatButton(
                            onPressed: () {
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            },
                            child: Text("Sair"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }else{
              return Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(
                      height: 88.0,
                      child: new DrawerHeader(
                        child: new Text('Schuler Production system - App',
                            style: TextStyle(color: Colors.white)),
                        decoration: new BoxDecoration(color: Color(0xFF004077)),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.exit_to_app),
                            onPressed: () {
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            },
                          ),
                          FlatButton(
                            onPressed: () {
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            },
                            child: Text("Sair"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            break;
        }
        return Text('Unkown error');
      },
    );
  }
}