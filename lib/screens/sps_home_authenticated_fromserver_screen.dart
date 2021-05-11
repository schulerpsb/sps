import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/dao/sps_dao_login_class.dart';
import 'package:sps/dao/sps_dao_sincronizacao_class.dart';
import 'package:sps/models/sps_login.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'package:sps/screens/sps_drawer_screen.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import 'package:sps/models/sps_log.dart';

import '../main.dart';

class HomeSpsAuthenticatedFromServer extends StatefulWidget {

  final TextEditingController _controladorusuario;
  final TextEditingController _controladorsenha;

   HomeSpsAuthenticatedFromServer(this._controladorusuario,
      this._controladorsenha);

  @override
  _HomeSpsAuthenticatedFromServerState createState() =>
      _HomeSpsAuthenticatedFromServerState(
          this._controladorusuario, this._controladorsenha);

}

class _HomeSpsAuthenticatedFromServerState
    extends State<HomeSpsAuthenticatedFromServer> {

  final _controladorCodigoValidacao = TextEditingController();

  final SpsLogin spslogin = SpsLogin();
  int id_isolate;

  _HomeSpsAuthenticatedFromServerState(_controladorusuario, _controladorsenha);


  @override
  void initState() {
    super.initState();
    spsLog.clearLog();
    spsLog.setUpLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        future: spslogin.efetuaLogin(
            this.widget._controladorusuario, widget._controladorsenha),
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
              if (snapshot.data.isNotEmpty) {
                if(snapshot.data[0]['mensagem'] == null){
                  //Usuário ja tem usuário autenticado pelo servidor
                  //Ir direto para o menu
                  usuarioAtual.codigo_usuario = snapshot.data[0]['codigo_usuario'];
                  usuarioAtual.nome_usuario = snapshot.data[0]['nome_usuario'];
                  usuarioAtual.email_usuario = snapshot.data[0]['email_usuario'];
                  usuarioAtual.lingua_usuario = snapshot.data[0]['lingua_usuario'];
                  usuarioAtual.status_usuario = snapshot.data[0]['status_usuario'];
                  usuarioAtual.telefone_usuario = snapshot.data[0]['telefone_usuario'];
                  usuarioAtual.tipo = snapshot.data[0]['tipo'];
                  usuarioAtual.registro_usuario =snapshot.data[0]['registro_usuario'];
                  // print('Codigo gerado: '+usuarioAtual.codigoValidacao.toString());
                  //inicialização dos Logs do Usuário
                  spsLog.log(tipo: "INFO", msg: "Dados do usuario: codigo_usuario: " + usuarioAtual.codigo_usuario + ", nome_usuario: "+ usuarioAtual.nome_usuario + ", telefone_usuario: "+ usuarioAtual.telefone_usuario + ", email_usuario: "+ usuarioAtual.email_usuario);
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/press.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.topCenter,
                            child: null,
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child:Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text('Você receberá um código de atutenticação via SMS'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _controladorCodigoValidacao,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.vpn_key),
                                      labelText: 'Código de autenticação',
                                      hintText: 'Digite o código de autenticação recebido por SMS',
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                                Builder(builder: (context) {
                                  return RaisedButton(
                                    child: Text(
                                      'Verificar',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.black26)),
                                    onPressed: () {
                                      if (_controladorCodigoValidacao != null &&
                                          _controladorCodigoValidacao.text != "" &&
                                          _controladorCodigoValidacao.text == usuarioAtual.codigoValidacao.toString()) {

                                        final SpsDaoLogin objLoginDao = SpsDaoLogin();
                                        objLoginDao.create_table().then((resulcreate){
                                          print('criei');
                                          objLoginDao.emptyTable(snapshot.data[0]).then((resullimpar){
                                            print('limpei');
                                            objLoginDao.save(snapshot.data[0]).then((value){
                                              print('gravei');
                                              if(usuarioAtual.id_isolate == null || usuarioAtual.id_isolate == "null" || usuarioAtual.id_isolate == ""){
                                                id_isolate = 1;
                                              }else {
                                                id_isolate = usuarioAtual.id_isolate + 1;
                                              }
                                              final isolate = FlutterIsolate.spawn(isolateSincronizacao, id_isolate); // comentar para não executar sincronização (ADRIANO)
                                              SpsDaoSincronizacao objSpsDaoSincronizacao = SpsDaoSincronizacao();
                                              objSpsDaoSincronizacao.emptyTable();
                                              Map<String, dynamic> dadosSincronizacao;
                                              dadosSincronizacao = null;
                                              dadosSincronizacao = {
                                                'id_isolate': id_isolate,
                                                'data_ultima_sincronizacao': '',
                                                'status': 0,
                                              };
                                              objSpsDaoSincronizacao.save(dadosSincronizacao);
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) =>
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => HomeSpsAuthenticatedFromLocal()),
                                                  )
                                              );
                                            });
                                          });
                                        });
                                      } else {
                                        mensagemNaBarra(context, 'Código de validação inválido!');
                                      }
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        )
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: MaterialButton(
                              onPressed: () => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text("SPS App"),
                                              content: Text(
                                                  "Um novo código de autenticação será reenviado para seu celular cadastrado. Deseja continuar?"),
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
                                                      print('Reenviar código de autenticação');
                                                      Navigator.of(context,
                                                          rootNavigator:
                                                          true)
                                                          .pop();
                                                      _showAlert(context,
                                                          "Um novo código de autenticação foi enviado para seu celular cadastrado.");
                                                      spslogin.reenviarCodigo(usuarioAtual.codigo_usuario).then((retorno) =>null);
                                                    }),
                                              ]);
                                        })
                              },
                              child: Text('Reenviar Código'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }else{
                  //Tratativas de erro de logon
                  switch (snapshot.data[0]['mensagem']) {
                    case "erro_conexao":
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("SPS App"),
                            content:
                            Text("O servidor não está disponível no momento!\nPor favor verifique sua conexão de internet e tente mais tarde."),
                            actions: [
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeSpsAuthenticatedFromLocal()),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ));
                      return CenteredMessage(
                        'Falha de Logon!',
                        icon: Icons.error,
                      );
                    break;
                    case "erro_codigo":
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("SPS App"),
                            content:
                            Text("Não foi possivel enviar o código de verificação, por favor tente novamente mais tarde."),
                            actions: [
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeSpsAuthenticatedFromLocal()),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ));
                      return CenteredMessage(
                        'Falha de Logon!',
                        icon: Icons.error,
                      );
                      break;
                    case "usuario_errado":
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("SPS App"),
                            content:
                            Text("O Usuário não existe ou está inativo!"),
                            actions: [
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeSpsAuthenticatedFromLocal()),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ));
                      return CenteredMessage(
                        'Falha de Logon!',
                        icon: Icons.error,
                      );
                      break;
                    case "excesso_tentativas":
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("SPS App"),
                            content:
                            Text("Seu usuário Foi bloqueado por escesso de tentativas!\n Selecione a opção 'Esqueci minha senha/usuário bloqueado."),
                            actions: [
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeSpsAuthenticatedFromLocal()),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ));
                      return CenteredMessage(
                        'Falha de Logon!',
                        icon: Icons.error,
                      );
                      break;
                    case "password_errado":
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("SPS App"),
                            content:
                            Text("Senha incorreta!"),
                            actions: [
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeSpsAuthenticatedFromLocal()),
                                      );
                                },
                              )
                            ],
                          );
                        },
                      ));
                      return CenteredMessage(
                        'Falha de Logon!',
                        icon: Icons.error,
                      );
                      break;
                  }
                }
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeSpsAuthenticatedFromLocal()));
                    }
                    break;
                }
                    return Text('Unkown error');
              },
      ),

    );
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
