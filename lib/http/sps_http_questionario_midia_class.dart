import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'Json_interceptor.dart';

class SpsHttpQuestionarioMidia {
  //Servidor de produção
  //static const baseUrl = 'https://teklist.schuler.de/webapi/api/questionario/read.php';

  //Servidor DEV
  static const UrlReadMidiaAll = 'http://10.17.20.45/webapi/api/midia/read_all.php';
  static const UrlReadMidia = 'http://10.17.20.45/webapi/api/midia/read.php';
  static const UrlIsertMidia = 'http://10.17.20.45/webapi/api/midia/create.php';
  static const UrlUpdateMidia = 'http://10.17.20.45/webapi/api/midia/update.php';

  SpsHttpQuestionarioMidia();

  Future<List<Map<String, dynamic>>> listarMidiaAll({Map<String, dynamic> dadosArquivo}) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': dadosArquivo['codigo_empresa'],
        'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),

      },
    );

    final storage = new FlutterSecureStorage();
    String jwtKey;
    jwtKey = await storage.read(key: 'jwtKey');
    token = jwt.sign(SecretKey(jwtKey));

    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuarioAtual.codigo_usuario,
      'jwt': token,
    };
    final String dadosMidiaJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

//    final Map<String, dynamic> keyMidia = {
//      'codigo_empresa': dadosArquivo['codigo_empresa'],
//      'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),
//    };
//    final String dadosMidiaJson = jsonEncode(keyMidia);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      UrlReadMidiaAll,
      headers: {'Content-type': 'application/json'},
      body: dadosMidiaJson,
    )
        .timeout(
      Duration(
        seconds: 5,
      ),
    );

    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> transactionJsonOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'codigo_empresa': element['codigo_empresa'],
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'item_anexo': element['item_anexo'],
        'nome_arquivo': element['nome_arquivo'],
        'titulo_arquivo': element['titulo_arquivo'],
        'usuresponsavel': element['usuresponsavel'],
        'dthratualizacao': element['dthratualizacao'],
        'dthranexo': element['dthranexo'],
      };
      transactionJsonOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonOcorrencias;
  }

  Future<List<Map<String, dynamic>>> listarMidia({Map<String, dynamic> dadosArquivo}) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': dadosArquivo['codigo_empresa'],
        'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),
        'registro_colaborador': dadosArquivo['registro_colaborador'].toString(),
        'identificacao_utilizador': dadosArquivo['identificacao_utilizador'].toString(),
        'item_checklist': dadosArquivo['item_checklist'].toString(),
        'item_anexo': dadosArquivo['item_anexo'].toString(),

      },
    );

    final storage = new FlutterSecureStorage();
    String jwtKey;
    jwtKey = await storage.read(key: 'jwtKey');
    token = jwt.sign(SecretKey(jwtKey));

    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuarioAtual.codigo_usuario,
      'jwt': token,
    };
    final String dadosMidiaJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

//    final Map<String, dynamic> keyMidia = {
//      'codigo_empresa': dadosArquivo['codigo_empresa'],
//      'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),
//      'registro_colaborador': dadosArquivo['registro_colaborador'].toString(),
//      'identificacao_utilizador': dadosArquivo['identificacao_utilizador'].toString(),
//      'item_checklist': dadosArquivo['item_checklist'].toString(),
//      'item_anexo': dadosArquivo['item_anexo'].toString(),
//    };
//
//    final String dadosMidiaJson = jsonEncode(keyMidia);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      UrlReadMidia,
      headers: {'Content-type': 'application/json'},
      body: dadosMidiaJson,
    )
        .timeout(
      Duration(
        seconds: 5,
      ),
    );

    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> transactionJsonOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'codigo_empresa': element['codigo_empresa'],
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'item_anexo': element['item_anexo'],
        'nome_arquivo': element['nome_arquivo'],
        'titulo_arquivo': element['nome_arquivo'],
        'usuresponsavel': element['usuresponsavel'],
        'dthratualizacao': element['dthratualizacao'],
        'dthranexo': element['dthranexo'],
      };
      transactionJsonOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonOcorrencias;
  }

  Future<int> InserirQuestionarioMidia({Map<String, dynamic> dadosArquivo}) async {
    if(dadosArquivo['titulo_arquivo'] == null){
      dadosArquivo['titulo_arquivo'] = '';
    }

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': dadosArquivo['codigo_empresa'],
        'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),
        'registro_colaborador': dadosArquivo['registro_colaborador'].toString(),
        'identificacao_utilizador': dadosArquivo['identificacao_utilizador'].toString(),
        'item_checklist': dadosArquivo['item_checklist'].toString(),
        'item_anexo': dadosArquivo['item_anexo'].toString(),
        'nome_arquivo': dadosArquivo['nome_arquivo'].toString(),
        'titulo_arquivo': dadosArquivo['titulo_arquivo'].toString(),
        'usuresponsavel': dadosArquivo['usuresponsavel'].toString(),
        'dthratualizacao': dadosArquivo['dthratualizacao'].toString(),
        'dthranexo': dadosArquivo['dthranexo'].toString(),

      },
    );

    final storage = new FlutterSecureStorage();
    String jwtKey;
    jwtKey = await storage.read(key: 'jwtKey');
    token = jwt.sign(SecretKey(jwtKey));

    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuarioAtual.codigo_usuario,
      'jwt': token,
    };
    final String dadosMidiaJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

//    final Map<String, dynamic> keyMidia = {
//      'codigo_empresa': dadosArquivo['codigo_empresa'],
//      'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),
//      'registro_colaborador': dadosArquivo['registro_colaborador'].toString(),
//      'identificacao_utilizador': dadosArquivo['identificacao_utilizador'].toString(),
//      'item_checklist': dadosArquivo['item_checklist'].toString(),
//      'item_anexo': dadosArquivo['item_anexo'].toString(),
//      'nome_arquivo': dadosArquivo['nome_arquivo'].toString(),
//      'titulo_arquivo': dadosArquivo['titulo_arquivo'].toString(),
//      'usuresponsavel': dadosArquivo['usuresponsavel'].toString(),
//      'dthratualizacao': dadosArquivo['dthratualizacao'].toString(),
//      'dthranexo': dadosArquivo['dthranexo'].toString(),
//    };
//
//    final String dadosMidiaJson = jsonEncode(keyMidia);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      UrlIsertMidia,
      headers: {'Content-type': 'application/json'},
      body: dadosMidiaJson,
    )
        .timeout(
      Duration(
        seconds: 5,
      ),
    );

    final int transactionJson = int.parse(jsonDecode(response.body));
    if(transactionJson > 0){
      return transactionJson;
    }else{
      return 0;
    }
  }

  Future<String> atualizarQuestionarioMidia({Map<String, dynamic> dadosArquivo}) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': dadosArquivo['codigo_empresa'],
        'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),
        'registro_colaborador': dadosArquivo['registro_colaborador'].toString(),
        'identificacao_utilizador': dadosArquivo['identificacao_utilizador'].toString(),
        'item_checklist': dadosArquivo['item_checklist'].toString(),
        'item_anexo': dadosArquivo['item_anexo'].toString(),
        'nome_arquivo': dadosArquivo['nome_arquivo'].toString(),
        'titulo_arquivo': dadosArquivo['titulo_arquivo'].toString(),
        'usuresponsavel': dadosArquivo['usuresponsavel'].toString(),
        'dthratualizacao': dadosArquivo['dthratualizacao'].toString(),
        'dthranexo': dadosArquivo['dthranexo'].toString(),
        'sincronizado': dadosArquivo['sincronizado'].toString(),

      },
    );

    final storage = new FlutterSecureStorage();
    String jwtKey;
    jwtKey = await storage.read(key: 'jwtKey');
    token = jwt.sign(SecretKey(jwtKey));

    final Map<String, dynamic> dadosParaLogon = {
      'codigo_usuario': usuarioAtual.codigo_usuario,
      'jwt': token,
    };
    final String dadosMidiaJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

//    final Map<String, dynamic> keyMidia = {
//      'codigo_empresa': dadosArquivo['codigo_empresa'],
//      'codigo_programacao': dadosArquivo['codigo_programacao'].toString(),
//      'registro_colaborador': dadosArquivo['registro_colaborador'].toString(),
//      'identificacao_utilizador': dadosArquivo['identificacao_utilizador'].toString(),
//      'item_checklist': dadosArquivo['item_checklist'].toString(),
//      'item_anexo': dadosArquivo['item_anexo'].toString(),
//      'nome_arquivo': dadosArquivo['nome_arquivo'].toString(),
//      'titulo_arquivo': dadosArquivo['titulo_arquivo'].toString(),
//      'usuresponsavel': dadosArquivo['usuresponsavel'].toString(),
//      'dthratualizacao': dadosArquivo['dthratualizacao'].toString(),
//      'dthranexo': dadosArquivo['dthranexo'].toString(),
//      'sincronizado': dadosArquivo['sincronizado'].toString(),
//    };
//
//    final String dadosMidiaJson = jsonEncode(keyMidia);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      UrlUpdateMidia,
      headers: {'Content-type': 'application/json'},
      body: dadosMidiaJson,
    )
        .timeout(
      Duration(
        seconds: 5,
      ),
    );

    final int transactionJson = jsonDecode(response.body);
    return transactionJson.toString();
  }


}
