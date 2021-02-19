import 'package:sps/dao/sps_dao_questionario_cq_midia_class.dart';
import 'package:sps/models/sps_midia_utils.dart';

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

  Future<int> deletarQuestionarioCqMidia({String arquivo = "", String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0, int item_anexo = 0}) async {
    final spsMidiaUtils objspsMidiaUtils = spsMidiaUtils();
    final SpsDaoQuestionarioCqMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioCqMidia();
    print('Arquivo a ser deletado==>'+arquivo);
    final delete = await objQuestionarioCqMidiaDao
        .deletarQuestionarioCqMidia(codigo_empresa: codigo_empresa,codigo_programacao: codigo_programacao,item_checklist: item_checklist, item_anexo: item_anexo);
    if (delete == 1) {
      objspsMidiaUtils.deleteFile(arquivo);
      print('Arquivo Apagado com sucesso!');
      return 1;
    } else {
      return 0;
    }
  }

}