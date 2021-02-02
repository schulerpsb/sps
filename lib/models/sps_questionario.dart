import 'package:flutter/cupertino.dart';
import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';
import 'Dart:io';

class SpsQuestionario {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionario() async {
    var _wservidor_conectado = false;

    final doc_action = 'PREENCHER_CQ';
    final registro_colaborador = '008306'; // substituir por variavell global do Fernando
    final identificacao_utilizador = 'SCHULER'; // substituir por variavell global do Fernando
    final tipo_frequencia = 'CONTROLE DE QUALIDADE';
    final tipo_checklist = 'CHECKLIST';

    //Verificar se existe conexão
    try {
      final result = await InternetAddress.lookup('10.17.20.45');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _wservidor_conectado = true;
        debugPrint('STATUS DA CONEXÃO -> connected');
      }
    } on SocketException catch (_) {
      _wservidor_conectado = false;
      debugPrint('STATUS DA CONEXÃO -> not connected');
    }

    //Quando existir conexão
    if (_wservidor_conectado == true) {
      debugPrint("=== INICIO SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) =============================================");
      //Ler dados não sincronizados do SQlite
      final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
      final List<Map<String, dynamic>> result =
          await objQuestionarioDao.select_sincronizacao();
      var _wregistros = result.length;
      debugPrint("Ler dados não sincronizados do SQlite (quantidade de registro: " + _wregistros.toString() + ")");
      var windex = 0;
      while (windex < _wregistros) {
        var _wsincronizado = "";
        //Atualizar registro no PostgreSQL (via API REST)
        final SpsHttpQuestionario objQuestionarioHttp = SpsHttpQuestionario();
        final retorno = await objQuestionarioHttp.QuestionarioSaveReferencia(
            result[windex]["codigo_empresa"],
            result[windex]["codigo_programacao"],
            result[windex]["referencia_parceiro"],
            '#usuario#'); //Verificar com Fernando
        if (retorno.toString() == true) {
          debugPrint("registro sincronizado: " + result[windex].toString());
        } else {
          debugPrint(
              "ERRO => registro sincronizado: " + result[windex].toString());
        }
        windex = windex + 1;
      }

      //Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite
      debugPrint("Ler registros do PostgreSQL (via API REST) / Deletar dados do SQlite / Gravar dados no SQlite");
      final SpsHttpQuestionario objQuestionarioHttp = SpsHttpQuestionario();
      final List<Map<String, dynamic>> dadosQuestionario =
          await objQuestionarioHttp.listarQuestionario(
              doc_action,
              registro_colaborador,
              identificacao_utilizador,
              tipo_frequencia,
              tipo_checklist);
      if (dadosQuestionario != null) {
        final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
        final int resulcreate = await objQuestionarioDao.create_table();
        final int resullimpar = await objQuestionarioDao.emptyTable();
        final int resultsave = await objQuestionarioDao.save(dadosQuestionario);
      }
      debugPrint("=== FIM SINCRONIZAÇÃO DE DADOS (Tabela: checklist_lista) ============================================");
    }

    //Ler dados do SQlite
    debugPrint("Ler dados do SQlite (Tabela: checklist_lista)");
    final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
    final List<Map<String, dynamic>> DadosSessao =
        await objQuestionarioDao.listarQuestionarioLocal();
    return DadosSessao;
  }
}
