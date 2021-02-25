import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sps/http/sps_http_questionario_midia_class.dart';
import 'package:sps/models/sps_midia_utils.dart';

class SpsQuestionarioMidia {
  @override
  Future<List<Map<String, dynamic>>> listarQuestionarioMidia({String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0}) async {
      final SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
      final int resulcreate = await objQuestionarioCqMidiaDao.create_table();
      //final int resullimpar = await objQuestionarioCqMidiaDao.emptyTable();
      //final int resultsave = await objQuestionarioCqMidiaDao.save(dadosQuestionario);
      final List<Map<String, dynamic>> DadosSessao = await objQuestionarioCqMidiaDao
          .listarQuestionarioMidia(codigo_empresa: codigo_empresa,codigo_programacao: codigo_programacao,item_checklist: item_checklist);
      if (DadosSessao != null) {
        return DadosSessao;
      } else {
        return DadosSessao;
      }
  }

  Future<int> deletarQuestionarioMidia({String arquivo = "", String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0, int item_anexo = 0}) async {
    final spsMidiaUtils objspsMidiaUtils = spsMidiaUtils();
    final SpsDaoQuestionarioMidia objQuestionarioMidiaDao = SpsDaoQuestionarioMidia();
    print('Arquivo a ser deletado==>'+arquivo);
    final delete = await objQuestionarioMidiaDao
        .deletarQuestionarioMidia(codigo_empresa: codigo_empresa,codigo_programacao: codigo_programacao,item_checklist: item_checklist, item_anexo: item_anexo);
    if (delete == 1) {
      objspsMidiaUtils.deleteFile(arquivo);
      print('Arquivo Apagado com sucesso!');
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> salvarTituloQuestionarioMidia({String titulo_arquivo = "", String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0, int item_anexo = 0}) async {
    final spsMidiaUtils objspsMidiaUtils = spsMidiaUtils();
    final SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
    final titulo = await objQuestionarioCqMidiaDao
        .updateTituloQuestionarioMidia(titulo_arquivo: titulo_arquivo, codigo_empresa: codigo_empresa,codigo_programacao: codigo_programacao,item_checklist: item_checklist, item_anexo: item_anexo);
    if (titulo == 1) {
      print('titulo editado com sucesso!');
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> atualizarArquivosQuestionarioMidia({String codigo_empresa = "", int codigo_programacao = 0,String registro_colaborador = "",String identificacao_utilizador = ""}) async {
    final SpsHttpQuestionarioMidia objSpsHttpQuestionarioMidia = SpsHttpQuestionarioMidia();
    final SpsDaoQuestionarioMidia objSpsDaoQuestionarioMidia = SpsDaoQuestionarioMidia();
    Map<String, dynamic> dadosArquivo = {
      'codigo_empresa': codigo_empresa,
      'codigo_programacao': codigo_programacao,
      'registro_colaborador': registro_colaborador,
      'identificacao_utilizador': identificacao_utilizador,
    };
    final List<Map<String, dynamic>> arquivosServidor = await objSpsHttpQuestionarioMidia.listarMidiaAll(dadosArquivo: dadosArquivo);
    final int criarTabelaLocal = await objSpsDaoQuestionarioMidia.create_table();
    final int limparTabeLaLOCAL = await objSpsDaoQuestionarioMidia.emptyTable();
    final int ResultadoSave = await objSpsDaoQuestionarioMidia.save(arquivosServidor);
    if (ResultadoSave == 1) {
      print('Arquivos de midia sincronizados com sucesso');
      return 1;
    } else {
      return 0;
    }
//  return 1;
  }

}