import 'package:sps/dao/sps_dao_questionario_cq_midia_class.dart';
import 'package:sps/http/sps_http_questionario_cq_midia_class.dart';
import 'package:sps/models/sps_usuario_class.dart';

class SpsQuestionarioCqMidia {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioCqMidia({String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0}) async {
      final SpsDaoQuestionarioCqMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioCqMidia();
      final int resulcreate = await objQuestionarioCqMidiaDao.create_table();
      //final int resullimpar = await objQuestionarioCqMidiaDao.emptyTable();
      //final int resultsave = await objQuestionarioCqMidiaDao.save(dadosQuestionario);
      final List<Map<String, dynamic>> DadosSessao = await objQuestionarioCqMidiaDao
          .listarQuestionarioCqMidia(codigo_empresa: codigo_empresa,codigo_programacao: codigo_programacao,item_checklist: item_checklist);
      if (DadosSessao != null) {
        return DadosSessao;
      } else {
        return DadosSessao;
      }
  }
}