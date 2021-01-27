import 'package:flutter/cupertino.dart';
import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';

class SpsQuestionarioItem {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioItem(
      h_codigo_empresa,
      h_codigo_programacao,
      h_codigo_grupo,
      h_codigo_checklist) async {
    final acao = 'PROXIMO';
    final sessao_checklist = '';
    final codigo_empresa = h_codigo_empresa;
    final codigo_programacao = h_codigo_programacao;
    final registro_colaborador = '';
    final identificacao_utilizador = '';
    final codigo_grupo = h_codigo_grupo;
    final codigo_checklist = h_codigo_checklist;

    final SpsHttpQuestionarioItem objQuestionarioItemHttp =
        SpsHttpQuestionarioItem();
    final List<Map<String, dynamic>> dadosQuestionarioItem =
        await objQuestionarioItemHttp.listarQuestionarioItem(
            acao,
            sessao_checklist,
            codigo_empresa,
            codigo_programacao,
            registro_colaborador,
            identificacao_utilizador,
            codigo_grupo,
            codigo_checklist);
    if (dadosQuestionarioItem != null) {
      final SpsDaoQuestionarioItem objQuestionarioItemDao =
          SpsDaoQuestionarioItem();
      final int resulcreate = await objQuestionarioItemDao.create_table();
      final int resullimpar = await objQuestionarioItemDao.emptyTable(h_codigo_empresa, h_codigo_programacao);
      final int resultsave =
          await objQuestionarioItemDao.save(dadosQuestionarioItem);
      final List<Map<String, dynamic>> DadosSessao =
          await objQuestionarioItemDao.listarQuestionarioItemLocal();
      if (DadosSessao != null) {
        return DadosSessao;
      } else {
        return DadosSessao;
      }
    }
    ;
  }
}
