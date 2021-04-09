import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'Json_interceptor.dart';

class SpsHttpQuestionarioRespMultipla {
  //Servidor de produção
  //static const baseUrl_readRespMultipla = 'https://teklist.schuler.de/webapi/api/questionario/read_resp_multipla.php';
  //static const baseUrl_saveRespMultipla = 'https://teklist.schuler.de/webapi/api/questionario/save_resp_multipla.php';

  //Servidor DEV
  static const baseUrl_readRespMultipla = 'http://10.17.20.45/webapi/api/questionario/read_resp_multipla.php';
  static const baseUrl_readRespMultiplaAll = 'http://10.17.20.45/webapi/api/questionario/read_resp_multipla_all.php';
  static const baseUrl_saveRespMultipla = 'http://10.17.20.45/webapi/api/questionario/save_resp_multipla.php';

  SpsHttpQuestionarioRespMultipla();

  Future<List<Map<String, dynamic>>> listarQuestionarioRespMultipla(
      String codigo_empresa,
      int codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      String codigo_grupo,
      int codigo_checklist) async {
    final Map<String, dynamic> keyQuestionarioRespMultipla = {
      'codigo_empresa': codigo_empresa,
      'codigo_programacao': codigo_programacao,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
      'codigo_grupo': codigo_grupo,
      'codigo_checklist': codigo_checklist,
    };

    final String dadosQuestionarioRespMultiplaJson = jsonEncode(keyQuestionarioRespMultipla);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_readRespMultipla,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioRespMultiplaJson,
        )
        .timeout(
          Duration(
            seconds: 5,
          ),
        );
    final List<dynamic> transactionJsonList = jsonDecode(response.body);
    final List<Map<String, dynamic>> transactionJsonRespMultiplaOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'codigo_empresa': element['codigo_empresa'],
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'codigo_tpresposta': element['codigo_tpresposta'],
        'subcodigo_tpresposta': element['subcodigo_tpresposta'],
        'descr_sub_tpresposta': element['descr_sub_tpresposta'],
        'tamanho_texto_adicional': element['tamanho_texto_adicional'],
        'obrigatorio_texto_adicional': element['obrigatorio_texto_adicional'],
        'subcodigo_resposta': element['subcodigo_resposta'],
        'texto_adicional': element['texto_adicional'],
      };
      transactionJsonRespMultiplaOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonRespMultiplaOcorrencias;
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioRespMultiplaAll(
      String codigo_empresa,
      String registro_colaborador,
      String identificacao_utilizador,
      ) async {
    final Map<String, dynamic> keyQuestionarioRespMultipla = {
      'codigo_empresa': codigo_empresa,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
    };

    final String dadosQuestionarioRespMultiplaJson = jsonEncode(keyQuestionarioRespMultipla);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
      baseUrl_readRespMultiplaAll,
      headers: {'Content-type': 'application/json'},
      body: dadosQuestionarioRespMultiplaJson,
    )
        .timeout(
      Duration(
        seconds: 5,
      ),
    );
    print('resposta: '+response.body.toString());
    final List<dynamic> transactionJsonList = jsonDecode(response.body);

    final List<Map<String, dynamic>> transactionJsonRespMultiplaOcorrencias = [];
    Map<String, dynamic> transactionJsonMap = null;
    for (Map<String, dynamic> element in transactionJsonList) {
      transactionJsonMap = {
        'codigo_empresa': element['codigo_empresa'],
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'codigo_tpresposta': element['codigo_tpresposta'],
        'subcodigo_tpresposta': element['subcodigo_tpresposta'],
        'descr_sub_tpresposta': element['descr_sub_tpresposta'],
        'tamanho_texto_adicional': element['tamanho_texto_adicional'],
        'obrigatorio_texto_adicional': element['obrigatorio_texto_adicional'],
        'subcodigo_resposta': element['subcodigo_resposta'],
        'texto_adicional': element['texto_adicional'],
      };
      transactionJsonRespMultiplaOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonRespMultiplaOcorrencias;
  }

  Future QuestionarioSaveRespMultipla(
      String codigo_empresa,
      String codigo_programacao,
      String registro_colaborador,
      String identificacao_utilizador,
      String item_checklist,
      String subcodigo_resposta,
      String texto_adicional,
      String usuresponsavel,
      String sincronizado) async {
    final Map<String, dynamic> fieldQuestionario = {
      'codigo_empresa': codigo_empresa,
      'codigo_programacao': codigo_programacao,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
      'item_checklist': item_checklist,
      'subcodigo_resposta': subcodigo_resposta,
      'texto_adicional': texto_adicional,
      'usuresponsavel': usuresponsavel,
      'sincronizado': sincronizado,
    };
    final String dadosQuestionarioJson = jsonEncode(fieldQuestionario);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl_saveRespMultipla,
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
