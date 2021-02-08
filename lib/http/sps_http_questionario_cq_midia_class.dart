import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'Json_interceptor.dart';

class SpsHttpQuestionarioCqMidia {
  //Servidor de produção
  //static const baseUrl = 'https://teklist.schuler.de/webapi/api/questionario/read.php';

  //Servidor DEV
  static const baseUrl = 'http://10.17.20.45/webapi/api/questionario/read.php';

  SpsHttpQuestionarioCqMidia();

  Future<List<Map<String, dynamic>>> listarMidia(String doc_action, String registro_colaborador, String identificacao_utilizador, String tipo_frequencia, String tipo_checklist) async {
    final Map<String, dynamic> keyQuestionario = {
      'doc_action': doc_action,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
      'tipo_frequencia': tipo_frequencia,
      'tipo_checklist': tipo_checklist,
    };

    final String dadosQuestionarioJson = jsonEncode(keyQuestionario);

    Client client = HttpClientWithInterceptor.build(interceptors: [
      JsonInterceptor(),
    ]);

    final Response response = await client
        .post(
          baseUrl,
          headers: {'Content-type': 'application/json'},
          body: dadosQuestionarioJson,
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
        'codigo_empresa': element['codigo_empresa'].trim(),
        'codigo_programacao': element['codigo_programacao'],
        'registro_colaborador': element['registro_colaborador'],
        'identificacao_utilizador': element['identificacao_utilizador'],
        'item_checklist': element['item_checklist'],
        'descr_programacao': element['descr_programacao'],
        'dtfim_aplicacao': element['dtfim_aplicacao'],
        'percentual_evolucao': element['percentual_evolucao'],
        'status': element['status'],
        'referencia_parceiro': element['referencia_parceiro'],
        'codigo_pedido': element['codigo_pedido'],
        'item_pedido': element['item_pedido'],
        'codigo_projeto': element['codigo_projeto'],
        'descr_projeto': element['descr_projeto'],
        'codigo_material': element['codigo_material'],
        'descr_comentarios': element['descr_comentarios'],
      };
      transactionJsonOcorrencias.add(transactionJsonMap);
    }
    return transactionJsonOcorrencias;
  }
}
