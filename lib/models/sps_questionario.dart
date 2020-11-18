import 'package:sps/dao/sps_dao_questionario_class.dart';
import 'package:sps/http/sps_http_questionario_class.dart';

class SpsQuestionario {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionario() async {
    final doc_action = 'PREENCHER_CQ';
    final registro_colaborador = '008306';
    final identificacao_utilizador = 'SCHULER';
    final tipo_frequencia = 'CONTROLE DE QUALIDADE';
    final tipo_checklist = 'CHECKLIST';

    final SpsHttpQuestionario objQuestionarioHttp = SpsHttpQuestionario();
    final List<Map<String, dynamic>> dadosQuestionario = await objQuestionarioHttp.listarQuestionario(doc_action, registro_colaborador, identificacao_utilizador, tipo_frequencia, tipo_checklist);
    if (dadosQuestionario != null) {
      final SpsDaoQuestionario objQuestionarioDao = SpsDaoQuestionario();
      final int resulcreate = await objQuestionarioDao.create_table();
      final int resullimpar = await objQuestionarioDao.emptyTable();
      final int resultsave = await objQuestionarioDao.save(dadosQuestionario);
      final List<Map<String, dynamic>> DadosSessao = await objQuestionarioDao
          .listarQuestionarioLocal();
      if (DadosSessao != null) {
        return DadosSessao;
      } else {
        return DadosSessao;
      }
    };
  }
}