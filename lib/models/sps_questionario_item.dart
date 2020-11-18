import 'package:sps/dao/sps_dao_questionario_item_class.dart';
import 'package:sps/http/sps_http_questionario_item_class.dart';

class SpsQuestionarioItem {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioItem() async {
    final acao = '';
    final sessao_checklist = '01 PRINCIPAL';
    final codigo_empresa = '7000';
    final codigo_programacao = '1009';
    final registro_colaborador = '';
    final identificacao_utilizador = '';
    final codigo_grupo = '01';
    final codigo_checklist = '100';

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
      final int resullimpar = await objQuestionarioItemDao.emptyTable();
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
