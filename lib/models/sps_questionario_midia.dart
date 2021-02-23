import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:sps/models/sps_usuario_class.dart';

class SpsQuestionarioMidia {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioMidia() async {
    final doc_action = 'PREENCHER_CQ';
    final registro_colaborador = sps_usuario().registro_usuario;
    final identificacao_utilizador = 'SCHULER';
    final tipo_frequencia = 'CONTROLE DE QUALIDADE';
    final tipo_checklist = 'CHECKLIST';

    final SpsHttpQuestionarioMidia objQuestionarioMidiaHttp = SpsHttpQuestionarioMidia();
    final List<Map<String, dynamic>> dadosQuestionario = await objQuestionarioMidiaHttp.listarMidia(doc_action, registro_colaborador, identificacao_utilizador, tipo_frequencia, tipo_checklist);
    if (dadosQuestionario != null) {
      final SpsDaoQuestionarioMidia objQuestionarioMidiaDao = SpsDaoQuestionarioMidia();
      final int resulcreate = await objQuestionarioMidiaDao.create_table();
      final int resullimpar = await objQuestionarioMidiaDao.emptyTable();
      final int resultsave = await objQuestionarioMidiaDao.save(dadosQuestionario);
      final List<Map<String, dynamic>> DadosSessao = await objQuestionarioMidiaDao
          .listarQuestionarioMidia();
      if (DadosSessao != null) {
        return DadosSessao;
      } else {
        return DadosSessao;
      }
    };
  }
}