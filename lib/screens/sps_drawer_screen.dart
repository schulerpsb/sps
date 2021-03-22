import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_sincronizacao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import '../main.dart';

class sps_drawer extends StatefulWidget {
  sps_drawer({
    Key key,
    @required this.spslogin,
  }) : super(key: key);

  final SpsLogin spslogin;

  @override
  _sps_drawerState createState() => _sps_drawerState();
}

class _sps_drawerState extends State<sps_drawer> {
  var dadosSincronizacaoAtual;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.spslogin.verificaUsuarioAutenticado(),
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
                    //Cabecalho do drawer
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
                              child: Text("Schuler production system", style: TextStyle(color: Colors.white)),
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
                            ) : Text(''),
                          ],
                        ),
                        decoration: new BoxDecoration(color: Color(0xFF004077)),
                      ),
                    ),
                    //Dados do usuario
                    SizedBox(
                      height: 45.0,
                      child: ListTile(
                        title: Text("Usuário: " + snapshot.data[0]['codigo_usuario'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: ListTile(
                        title: Text("Nome: " + snapshot.data[0]['nome_usuario'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      child: ListTile(
                        title: Text("E-mail: " + snapshot.data[0]['email_usuario'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 80.0,
                      child: ListTile(
                        title: Text("Tipo: " + snapshot.data[0]['tipo'].toString()),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    //Cabecalho Status de conexao
                    SizedBox(
                      height: 25.0,
                      child: new Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Status da sincronização", style: TextStyle(color: Colors.white)),
                        ),
                        decoration: new BoxDecoration(color: Color(0xFF004077)),
                      ),
                    ),
                    // Dados de status de conexao
                    statusAtualizacao(context),
                    //Cabecalho de sair ou trocar usuario
                    SizedBox(
                      height: 25.0,
                      child: new Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Conta", style: TextStyle(color: Colors.white)),
                        ),
                        decoration: new BoxDecoration(color: Color(0xFF004077)),
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
                              widget.spslogin.logoutUser();
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
                              widget.spslogin.logoutUser();
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
            } else {
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

  SizedBox statusAtualizacao(BuildContext context) {
    var statusTexto;
    if ((usuarioAtual.data_ultima_sincronizacao.toString() == "null" || usuarioAtual.data_ultima_sincronizacao.toString() == null || usuarioAtual.data_ultima_sincronizacao.toString() == "") && usuarioAtual.status_sincronizacao != 2) {
      return SizedBox(
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text("SPS App - Sincronização"),
                          content: Text("Deseja sincronizar os dados com servidor agora?"),
                          actions: [
                            FlatButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context,
                                    rootNavigator:
                                    true)
                                    .pop();
                              },
                            ),
                            FlatButton(
                                child: Text("Sim"),
                                onPressed: () {
                                  final isolate = FlutterIsolate.spawn(isolateSincronizacao, usuarioAtual.id_isolate + 1);
                                  SpsDaoSincronizacao objSpsDaoSincronizacao = SpsDaoSincronizacao();
                                  objSpsDaoSincronizacao.emptyTable();
                                  Map<String, dynamic> dadosSincronizacao;
                                  dadosSincronizacao = null;
                                  dadosSincronizacao = {
                                    'id_isolate': usuarioAtual.id_isolate + 1,
                                    'data_ultima_sincronizacao': '',
                                    'status': 0,
                                  };
                                  objSpsDaoSincronizacao.save(dadosSincronizacao);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return HomeSpsAuthenticatedFromLocal();
                                      },
                                    ),
                                  );
                                }),
                          ]);
                    });
              },
            ),
            FlatButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text("SPS App - Sincronização"),
                          content: Text("Deseja sincronizar os dados com servidor agora?"),
                          actions: [
                            FlatButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context,
                                    rootNavigator:
                                    true)
                                    .pop();
                              },
                            ),
                            FlatButton(
                                child: Text("Sim"),
                                onPressed: () {
                                  final isolate = FlutterIsolate.spawn(isolateSincronizacao, usuarioAtual.id_isolate + 1);
                                  SpsDaoSincronizacao objSpsDaoSincronizacao = SpsDaoSincronizacao();
                                  objSpsDaoSincronizacao.emptyTable();
                                  Map<String, dynamic> dadosSincronizacao;
                                  dadosSincronizacao = null;
                                  dadosSincronizacao = {
                                    'id_isolate': usuarioAtual.id_isolate + 1,
                                    'data_ultima_sincronizacao': '',
                                    'status': 0,
                                  };
                                  objSpsDaoSincronizacao.save(dadosSincronizacao);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return HomeSpsAuthenticatedFromLocal();
                                      },
                                    ),
                                  );
                                }),
                          ]);
                    });
              },
              child: Text("Não sincronizado! Sincronizar?"),
            ),
          ],
        ),
      );
    } else {
      if (usuarioAtual.status_sincronizacao == 1) {
        return SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("SPS App - Sincronização"),
                            content: Text("Deseja sincronizar os dados com servidor agora?"),
                            actions: [
                              FlatButton(
                                child: Text("Cancelar"),
                                onPressed: () {
                                  Navigator.of(context,
                                      rootNavigator:
                                      true)
                                      .pop();
                                },
                              ),
                              FlatButton(
                                  child: Text("Sim"),
                                  onPressed: () {
                                    final isolate = FlutterIsolate.spawn(isolateSincronizacao, usuarioAtual.id_isolate + 1);
                                    SpsDaoSincronizacao objSpsDaoSincronizacao = SpsDaoSincronizacao();
                                    objSpsDaoSincronizacao.emptyTable();
                                    Map<String, dynamic> dadosSincronizacao;
                                    dadosSincronizacao = null;
                                    dadosSincronizacao = {
                                      'id_isolate': usuarioAtual.id_isolate + 1,
                                      'data_ultima_sincronizacao': '',
                                      'status': 0,
                                    };
                                    objSpsDaoSincronizacao.save(dadosSincronizacao);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return HomeSpsAuthenticatedFromLocal();
                                        },
                                      ),
                                    );
                                  }),
                            ]);
                      });
                },
              ),
              FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("SPS App - Sincronização"),
                            content: Text("Deseja sincronizar os dados com servidor agora?"),
                            actions: [
                              FlatButton(
                                child: Text("Cancelar"),
                                onPressed: () {
                                  Navigator.of(context,
                                      rootNavigator:
                                      true)
                                      .pop();
                                },
                              ),
                              FlatButton(
                                  child: Text("Sim"),
                                  onPressed: () {
                                    final isolate = FlutterIsolate.spawn(isolateSincronizacao, usuarioAtual.id_isolate + 1);
                                    SpsDaoSincronizacao objSpsDaoSincronizacao = SpsDaoSincronizacao();
                                    objSpsDaoSincronizacao.emptyTable();
                                    Map<String, dynamic> dadosSincronizacao;
                                    dadosSincronizacao = null;
                                    dadosSincronizacao = {
                                      'id_isolate': usuarioAtual.id_isolate + 1,
                                      'data_ultima_sincronizacao': '',
                                      'status': 0,
                                    };
                                    objSpsDaoSincronizacao.save(dadosSincronizacao);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return HomeSpsAuthenticatedFromLocal();
                                        },
                                      ),
                                    );
                                  }),
                            ]);
                      });
                },
                child: Text(usuarioAtual.data_ultima_sincronizacao.toString()),
              ),
            ],
          ),
        );
      }
      if (usuarioAtual.status_sincronizacao == 2) {
        return SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.sync_problem),
                onPressed: () {
                },
              ),
              FlatButton(
                onPressed: () {
                },
                child: Text("Em andamento...Favor aguardar."),
              ),
            ],
          ),
        );
      }
      if (usuarioAtual.status_sincronizacao == null) {
        statusTexto = "Dispositivo não sincronizado.";
      }
    }
  }
}