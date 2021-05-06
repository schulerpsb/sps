import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_log.dart';
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

  // //tratativas para inicialização de logs em arquivos.
  // var TAG = "SPSsupplierPortal";
  // var _my_log_file_name = "SPSsupplierPortal_log";
  // var toggle = false;
  // static Completer _completer = new Completer<String>();

  _HomeSpsAuthenticatedFromLocalState();

  final SpsLogin spslogin = SpsLogin();
  GlobalKey<ScaffoldState> _key = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //     setUpLogs();
  // }



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
                      '(Ponto 4) Falha de conexão!',
                      icon: Icons.error,
                    );
                  }
                  //if (erroConexao.msg_erro_conexao.toString() == "") {
                    if (snapshot.data.isNotEmpty) {
                      // spsLog.logToFile(msg: "teste de mensagem teste");
                      //Usuário ja tem usuário local autenticado
                      //Ir direto para o menu
                      //final dadossessao = sps_usuario();
                      //final usuarioAtual = sps_usuario(codigo_usuario:snapshot.data[0]['codigo_usuario'],nome_usuario:snapshot.data[0]['nome_usuario'],email_usuario:snapshot.data[0]['email_usuario'],lingua_usuario:snapshot.data[0]['lingua_usuario'],status_usuario:snapshot.data[0]['status_usuario'],tipo:snapshot.data[0]['tipo'],registro_usuario:snapshot.data[0]['registro_usuario']);
                      usuarioAtual.codigo_usuario =
                          snapshot.data[0]['codigo_usuario'];
                      usuarioAtual.nome_usuario =
                          snapshot.data[0]['nome_usuario'];
                          snapshot.data[0]['nome_usuario'];
                      usuarioAtual.email_usuario =
                          snapshot.data[0]['email_usuario'];
                      usuarioAtual.lingua_usuario =
                          snapshot.data[0]['lingua_usuario'];
                      usuarioAtual.status_usuario =
                          snapshot.data[0]['status_usuario'];
                      usuarioAtual.telefone_usuario =
                      snapshot.data[0]['telefone_usuario'];
                      usuarioAtual.tipo = snapshot.data[0]['tipo'];
                      usuarioAtual.registro_usuario =
                          snapshot.data[0]['registro_usuario'];
                      return sps_menu_screen();
                    } else {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/press.jpg"),
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset('images/Logo_Schuler_alta.png'),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: _controladorusuario,
                                            style: TextStyle(
                                              fontSize: 17.0,
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
                                            fontSize: 17.0,
                                          ),
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            icon: Icon(Icons.lock),
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
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                              side: BorderSide(color: Colors.black26)),
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
                                              mensagemNaBarra(context,
                                                  'Favor Preencher usuário e senha!');
                                            }
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                              Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: MaterialButton(
                                      onPressed: () => {
                                        if (_controladorusuario != null &&
                                            _controladorusuario.text != "")
                                          {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      title: Text("SPS App"),
                                                      content: Text(
                                                          "As intruções para redefinição da senha serão enviadas para seu e-mail cadastrado. Deseja continuar?"),
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
                                                              print('enviar senha');
                                                              Navigator.of(context,
                                                                  rootNavigator:
                                                                  true)
                                                                  .pop();
                                                              _showAlert(context,
                                                                  "As intruções para redefinição da form enviadas para seu e-mail cadastrado.");
                                                              spslogin
                                                                  .esqueciMinhaSenha(
                                                                  _controladorusuario
                                                                      .text)
                                                                  .then((retorno) =>
                                                              null);
                                                            }),
                                                      ]);
                                                })
                                          }
                                        else
                                          {
                                            mensagemNaBarra(context,
                                                'Favor Preencher o usuário!'),
                                          }
                                      },
                                      child: Text('Esqueci minha senha'),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      );
                    }
//                  } else {
//                    return CenteredMessage(
//                      'Falha de conexão!',
//                      icon: Icons.warning,
//                    );
//                  }
                  break;
              }
              return Text('Unkown error');
            },
          ),
        ));
  }

  void mensagemNaBarra(BuildContext context, String texto) {
    final snackBar = SnackBar(
      content: Text(texto),
      action: SnackBarAction(
        label: 'voltar',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showAlert(BuildContext context, String texto) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("SPS App"),
              content: Text(texto),
              actions: [
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
