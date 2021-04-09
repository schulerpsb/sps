import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:sps/models/sps_usuario_class.dart';
import 'Json_interceptor.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class SpsHttpQuestionarioItem {
  //Servidor de produção
  //static const baseUrl_readItem = 'https://teklist.schuler.de/webapi/api/questionario/read_item.php';
  //static const baseUrl_saveOpcao = 'https://teklist.schuler.de/webapi/api/questionario/save_opcao.php';
  //static const baseUrl_saveComentarios = 'http://teklist.schuler.de/webapi/api/questionario/save_comentarios.php';
  //static const baseUrl_saveAprovacao = 'http://teklist.schuler.de/webapi/api/questionario/save_aprovacao.php';
  //static const baseUrl_saveResposta = 'http://teklist.schuler.de/webapi/api/questionario/save_resposta.php';
  //static const baseUrl_saveStatusResposta = 'http://teklist.schuler.de/webapi/api/questionario/save_status_resposta.php';

  //Servidor DEV
  static const baseUrl_readItem = 'http://10.17.20.45/webapi/api/questionario/read_item.php'; //ok jwt
  static const baseUrl_readItemAll = 'http://10.17.20.45/webapi/api/questionario/read_item_all.php'; //ok jwt
  static const baseUrl_saveOpcao = 'http://10.17.20.45/webapi/api/questionario/save_opcao.php'; //ok jwt
  static const baseUrl_saveComentarios = 'http://10.17.20.45/webapi/api/questionario/save_comentarios.php'; //ok jwt
  static const baseUrl_saveAprovacao = 'http://10.17.20.45/webapi/api/questionario/save_aprovacao.php'; //ok jwt
  static const baseUrl_saveResposta = 'http://10.17.20.45/webapi/api/questionario/save_resposta.php'; //ok jwt
  static const baseUrl_saveStatusResposta = 'http://10.17.20.45/webapi/api/questionario/save_status_resposta.php'; //ok jwt

  SpsHttpQuestionarioItem();

  Future<List<Map<String, dynamic>>> listarQuestionarioItem(
      String acao,
      String sessao_checklist,
      String codigo_empresa,
      int codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      String codigo_grupo,
      int codigo_checklist) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'acao': acao,
        'sessao_checklist': sessao_checklist,
        'codigo_empresa': codigo_empresa,
        'codigo_programacao': codigo_programacao,
        'registro_colaborador': registro_colaborador,
        'identificacao_utilizador': identificacao_utilizador,
        'codigo_grupo': codigo_grupo,
        'codigo_checklist': codigo_checklist,

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
    final String dadosQuestionarioItemJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum
    //print ("token:"+dadosQuestionarioItemJson.toString()); // Utilizar site https://jwt.io/ para abrir variaveis

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_readItem,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioItemJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );
    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> transactionJsonItemOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'codigo_empresa': element['codigo_empresa'],
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'sessao_checklist': element['sessao_checklist'],
        'codigo_grupo': element['codigo_grupo'],
        'codigo_checklist': element['codigo_checklist'],
        'seq_pergunta': element['seq_pergunta'],
        'descr_pergunta': element['descr_pergunta'],
        'codigo_pergunta_dependente': element['codigo_pergunta_dependente'],
        'resposta_pergunta_dependente': element['resposta_pergunta_dependente'],
        'tipo_resposta': element['tipo_resposta'],
        'comentario_resposta_nao': element['comentario_resposta_nao'],
        'descr_escala': element['descr_escala'],
        'inicio_escala': element['inicio_escala'],
        'fim_escala': element['fim_escala'],
        'intervalo_escala': element['intervalo_escala'],
        'comentario_escala': element['comentario_escala'],
        'midia': element['midia'],
        'opcao_nao_se_aplica': element['opcao_nao_se_aplica'],
        'comentarios': element['comentarios'],
        'tipo_resposta_fixa': element['tipo_resposta_fixa'],
        'tamanho_resposta_fixa': element['tamanho_resposta_fixa'],
        'resp_simnao': element['resp_simnao'],
        'resp_texto': element['resp_texto'],
        'resp_numero': element['resp_numero'],
        'resp_data': element['resp_data'],
        'resp_hora': element['resp_hora'],
        'resp_escala': element['resp_escala'],
        'resp_cq': element['resp_cq'],
        'resp_nao_se_aplica': element['resp_nao_se_aplica'],
        'descr_comentarios': element['descr_comentarios'],
        'status_resposta': element['status_resposta'],
        'status_aprovacao': element['status_aprovacao'],
        'sugestao_resposta': element['sugestao_resposta'],
        'subcodigo_tpresposta': element['subcodigo_tpresposta'],
        'descr_sub_tpresposta': element['descr_sub_tpresposta'],
        'tamanho_texto_adicional': element['tamanho_texto_adicional'],
        'obrigatorio_texto_adicional': element['obrigatorio_texto_adicional'],
        'subcodigo_resposta': element['subcodigo_resposta'],
        'texto_adicional': element['texto_adicional'],
      };
      transactionJsonItemOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonItemOcorrencias;
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioItemAll(
      String codigo_empresa,
      String registro_colaborador,
      String identificacao_utilizador) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': codigo_empresa,
        'registro_colaborador': registro_colaborador,
        'identificacao_utilizador': identificacao_utilizador,
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
    final String dadosQuestionarioItemJson = jsonEncode(dadosParaLogon);
    //print ("token:"+dadosQuestionarioItemJson.toString()); // Utilizar site https://jwt.io/ para abrir variaveis
//    FIM implementação de JWT comum

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrl_readItemAll,
      headers: {'Content-type': 'application/json'},
      body: dadosQuestionarioItemJson,
    )
        .timeout(
      Duration(
        seconds: 5,
      ),
    );
    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> transactionJsonItemOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'codigo_empresa': element['codigo_empresa'],
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'sessao_checklist': element['sessao_checklist'],
        'codigo_grupo': element['codigo_grupo'],
        'codigo_checklist': element['codigo_checklist'],
        'seq_pergunta': element['seq_pergunta'],
        'descr_pergunta': element['descr_pergunta'],
        'codigo_pergunta_dependente': element['codigo_pergunta_dependente'],
        'resposta_pergunta_dependente': element['resposta_pergunta_dependente'],
        'tipo_resposta': element['tipo_resposta'],
        'comentario_resposta_nao': element['comentario_resposta_nao'],
        'descr_escala': element['descr_escala'],
        'inicio_escala': element['inicio_escala'],
        'fim_escala': element['fim_escala'],
        'intervalo_escala': element['intervalo_escala'],
        'comentario_escala': element['comentario_escala'],
        'midia': element['midia'],
        'opcao_nao_se_aplica': element['opcao_nao_se_aplica'],
        'comentarios': element['comentarios'],
        'tipo_resposta_fixa': element['tipo_resposta_fixa'],
        'tamanho_resposta_fixa': element['tamanho_resposta_fixa'],
        'resp_simnao': element['resp_simnao'],
        'resp_texto': element['resp_texto'],
        'resp_numero': element['resp_numero'],
        'resp_data': element['resp_data'],
        'resp_hora': element['resp_hora'],
        'resp_escala': element['resp_escala'],
        'resp_cq': element['resp_cq'],
        'resp_nao_se_aplica': element['resp_nao_se_aplica'],
        'descr_comentarios': element['descr_comentarios'],
        'status_resposta': element['status_resposta'],
        'status_aprovacao': element['status_aprovacao'],
        'sugestao_resposta': element['sugestao_resposta'],
        'subcodigo_tpresposta': element['subcodigo_tpresposta'],
        'descr_sub_tpresposta': element['descr_sub_tpresposta'],
        'tamanho_texto_adicional': element['tamanho_texto_adicional'],
        'obrigatorio_texto_adicional': element['obrigatorio_texto_adicional'],
        'subcodigo_resposta': element['subcodigo_resposta'],
        'texto_adicional': element['texto_adicional'],
      };
      transactionJsonItemOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonItemOcorrencias;
  }

  Future QuestionarioSaveOpcao(
      String codigo_empresa,
      String codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      String item_checklist,
      String resp_cq,
      String usuresponsavel) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': codigo_empresa,
        'codigo_programacao': codigo_programacao,
        'registro_colaborador': registro_colaborador,
        'identificacao_utilizador': identificacao_utilizador,
        'item_checklist': item_checklist,
        'resp_cq': resp_cq,
        'usuresponsavel': usuresponsavel,

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
    final String dadosQuestionarioJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum



    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_saveOpcao,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    return true;
  }

  Future QuestionarioSaveRespCQ(
      String codigo_empresa,
      String codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      String item_checklist,
      String resp_cq,
      String usuresponsavel) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': codigo_empresa,
        'codigo_programacao': codigo_programacao,
        'registro_colaborador': registro_colaborador,
        'identificacao_utilizador': identificacao_utilizador,
        'item_checklist': item_checklist,
        'resp_cq': resp_cq,
        'usuresponsavel': usuresponsavel,

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
    final String dadosQuestionarioJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_saveOpcao,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    return true;
  }

  Future QuestionarioSaveResposta(
      String codigo_empresa,
      String codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      String item_checklist,
      String resp_texto,
      String resp_numero,
      String resp_data,
      String resp_hora,
      String resp_simnao,
      String resp_escala,
      String descr_comentarios,
      String resp_nao_se_aplica,
      String usuresponsavel) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': codigo_empresa,
        'codigo_programacao': codigo_programacao,
        'registro_colaborador': registro_colaborador,
        'identificacao_utilizador': identificacao_utilizador,
        'item_checklist': item_checklist,
        'resp_texto': resp_texto,
        'resp_numero': resp_numero,
        'resp_data': resp_data,
        'resp_hora': resp_hora,
        'resp_simnao': resp_simnao,
        'resp_escala': resp_escala,
        'descr_comentarios': descr_comentarios,
        'resp_nao_se_aplica': resp_nao_se_aplica,
        'usuresponsavel': usuresponsavel,

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
    final String dadosQuestionarioJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_saveResposta,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    return true;
  }

  Future QuestionarioSaveStatusResposta(
      String codigo_empresa,
      int codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      int item_checklist,
      String status_resposta,
      String usuresponsavel) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': codigo_empresa,
        'codigo_programacao': codigo_programacao,
        'registro_colaborador': registro_colaborador,
        'identificacao_utilizador': identificacao_utilizador,
        'item_checklist': item_checklist,
        'status_resposta': status_resposta,
        'usuresponsavel': usuresponsavel,

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
    final String dadosQuestionarioJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_saveStatusResposta,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    return true;
  }

  Future QuestionarioSaveAprovacao(
      String codigo_empresa,
      String codigo_programacao,
      String item_checklist,
      String status_aprovacao,
      String usuresponsavel) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'codigo_empresa': codigo_empresa,
        'codigo_programacao': codigo_programacao,
        'item_checklist': item_checklist,
        'status_aprovacao': status_aprovacao,
        'usuresponsavel': usuresponsavel,
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
    final String dadosQuestionarioJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_saveAprovacao,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    return true;
  }

  Future QuestionarioSaveComentario(
      String origem_usuario,
      String codigo_empresa,
      String codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      String item_checklist,
      String descr_comentarios,
      String usuresponsavel) async {

//    implementação de JWT comum
    String token;
    final jwt = JWT(
      {
        //Parte Fixa - Não alterar
        'iis': 'ChecklistApp',
        'sub': usuarioAtual.codigo_usuario,
        //A Partir daqui coloque seus dados que deseja passar para a REST API
        'origem_usuario': origem_usuario,
        'codigo_empresa': codigo_empresa,
        'codigo_programacao': codigo_programacao,
        'registro_colaborador': registro_colaborador,
        'identificacao_utilizador': identificacao_utilizador,
        'item_checklist': item_checklist,
        'descr_comentarios': descr_comentarios,
        'usuresponsavel': usuresponsavel,

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
    final String dadosQuestionarioJson = jsonEncode(dadosParaLogon);
//    FIM implementação de JWT comum

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_saveComentarios,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );

    return true;
  }
}
