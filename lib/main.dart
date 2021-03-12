import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sps/screens/sps_home_authenticated_fromlocal_screen.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:cron/cron.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'http/sps_http_verificar_conexao_class.dart';
import 'models/sps_login.dart';
import 'models/sps_sincronizacao.dart';

void isolateSincronizacao(String arg) async  {
  final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
  final SpsLogin spslogin = SpsLogin();
  final cron = Cron();
  DateTime now = new DateTime.now();
  DateTime dataHoraAtual = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
  print('Verificando sincronização '+ dataHoraAtual.toString());
  print(arg);
  bool statusSincronizarQuestionarios = true;

  //verificação para inicio da primeira execução
  final bool conectadoInicial = await ObjVerificarConexao.verificar_conexao();
  if (conectadoInicial == true) {
    //Verifica se existe usuário logado
    List<Map<String, dynamic>> dadosSessaoInicial = await spslogin.verificaUsuarioAutenticado();
    print(dadosSessaoInicial.toString());
    if(dadosSessaoInicial.length >= 1){
      usuarioAtual.codigo_usuario = dadosSessaoInicial[0]['codigo_usuario'];
      usuarioAtual.nome_usuario = dadosSessaoInicial[0]['nome_usuario'];
      usuarioAtual.email_usuario = dadosSessaoInicial[0]['email_usuario'];
      usuarioAtual.lingua_usuario = dadosSessaoInicial[0]['lingua_usuario'];
      usuarioAtual.status_usuario = dadosSessaoInicial[0]['status_usuario'];
      usuarioAtual.tipo = dadosSessaoInicial[0]['tipo'];
      usuarioAtual.registro_usuario = dadosSessaoInicial[0]['registro_usuario'];
      //Inicio da sincronização Recorrente de 1 em 1 minuto
      print('Sincronizando Dados em background - Primeira execução');
      print('Sincronizando Dados de questionários - Primeira execução');
      statusSincronizarQuestionarios = await spsSincronizacao.sincronizarQuestionarios();
    }else{
      print('Sincronização Primeira execução - Não executada - SEM DADOS DE LOGON LOCAL');
    }
  }else{
    print('Sincronização Primeira execução - Não executada - Dispositivo OFFLINE');
  }

  //Verificação recorrente - 1 em 1 minuto
  //  bool statusSincronizandoArquivos = false;
  int numsinc;
  cron.schedule(Schedule.parse('* * * * *'), () async {
    DateTime now = new DateTime.now();
    DateTime dataHoraAtual = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
    print('Verificando sincronização recorrente '+ dataHoraAtual.toString());

    final bool conectadoRecorrente = await ObjVerificarConexao.verificar_conexao();
    if (conectadoRecorrente == true) {
      //Verifica se existe usuário logado
      List<Map<String, dynamic>> dadosSessao = await spslogin.verificaUsuarioAutenticado();
      if(dadosSessao.length >= 1){
        usuarioAtual.codigo_usuario = dadosSessao[0]['codigo_usuario'];
        usuarioAtual.nome_usuario = dadosSessao[0]['nome_usuario'];
        usuarioAtual.email_usuario = dadosSessao[0]['email_usuario'];
        usuarioAtual.lingua_usuario = dadosSessao[0]['lingua_usuario'];
        usuarioAtual.status_usuario = dadosSessao[0]['status_usuario'];
        usuarioAtual.tipo = dadosSessao[0]['tipo'];
        usuarioAtual.registro_usuario = dadosSessao[0]['registro_usuario'];
        //Inicio da sincronização Recorrente de 1 em 1 minuto
        print('Verificando a possibilidade de rodar a sincronização Dados em background - Recorrente');
        if(statusSincronizarQuestionarios == true){
          numsinc = 0;
          print('Sincronizando Dados de questionários - Recorrente - numsync:'+numsinc.toString());
          statusSincronizarQuestionarios = false;
          statusSincronizarQuestionarios = await spsSincronizacao.sincronizarQuestionarios();
        }else{
          if(numsinc == 3){
            statusSincronizarQuestionarios = true;
            numsinc = 0;
          }else{
            numsinc++;
          }
          print('Sincronização recorrente não executada - '+ dataHoraAtual.toString()+ ' - JA EXISTE UMA SINCRONIZAÇÃO EM ANDAMENTO - numsync:'+numsinc.toString());
        }

      }else{
        print('Sincronização recorrente não executada - '+ dataHoraAtual.toString()+ ' - SEM DADOS DE LOGON LOCAL');
      }
    }else{
      DateTime now = new DateTime.now();
      DateTime dataHoraAtual = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      print('Sincronização recorrente não executada - '+ dataHoraAtual.toString()+ ' - Dispositivo OFFLINE');
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Timer(Duration(seconds:5), (){
    //final isolate = FlutterIsolate.spawn(isolateSincronizacao, "Início da sincronização em background - ISOLATE");
  });
  //runApp(Sps(),
  //runApp(MaterialApp(home: sps_menu_screen()),
  runApp(
    MaterialApp(home: Sps()),
  );
}

class Sps extends StatelessWidget {
  const Sps({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF004077),
        accentColor: Color(0xFF004077),
      ),
      //splash Screen
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: MyHomePage(title: 'Schuler Production System'),
      //home: SpsLoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 3,
        navigateAfterSeconds: HomeSpsAuthenticatedFromLocal(),
        loaderColor: Colors.transparent,
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/logo_schuler.gif"),
            fit: BoxFit.none,
          ),
        ),
      ),
    ],
  );
}
