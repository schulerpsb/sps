import 'package:sps/dao/sps_dao_questionario_cq_midia_class.dart';
import 'package:sps/http/sps_http_questionario_cq_midia_class.dart';
import 'package:sps/models/sps_usuario_class.dart';

class SpsQuestionarioCqMidia {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioCqMidia() async {
    final doc_action = 'PREENCHER_CQ';
    final registro_colaborador = sps_usuario().registro_usuario;
    final identificacao_utilizador = 'SCHULER';
    final tipo_frequencia = 'CONTROLE DE QUALIDADE';
    final tipo_checklist = 'CHECKLIST';

    final SpsHttpQuestionarioCqMidia objQuestionarioCqMidiaHttp = SpsHttpQuestionarioCqMidia();
    final List<Map<String, dynamic>> dadosQuestionario = await objQuestionarioCqMidiaHttp.listarMidia(doc_action, registro_colaborador, identificacao_utilizador, tipo_frequencia, tipo_checklist);
    if (dadosQuestionario != null) {
      final SpsDaoQuestionarioCqMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioCqMidia();
      final int resulcreate = await objQuestionarioCqMidiaDao.create_table();
      final int resullimpar = await objQuestionarioCqMidiaDao.emptyTable();
      final int resultsave = await objQuestionarioCqMidiaDao.save(dadosQuestionario);
      final List<Map<String, dynamic>> DadosSessao = await objQuestionarioCqMidiaDao
          .listarQuestionarioCqMidia();
      if (DadosSessao != null) {
        return DadosSessao;
      } else {
        return DadosSessao;
      }
    };
  }
}