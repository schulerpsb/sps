import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sps/dao/sps_dao_questionario_midia_class.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionarioItem {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS checklist_item('
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'item_checklist INTEGER, '
      'sessao_checklist TEXT, '
      'codigo_grupo TEXT, '
      'codigo_checklist INTEGER, '
      'seq_pergunta INTEGER, '
      'descr_pergunta TEXT, '
      'codigo_pergunta_dependente TEXT, '
      'resposta_pergunta_dependente TEXT, '
      'tipo_resposta TEXT, '
      'comentario_resposta_nao TEXT, '
      'descr_escala TEXT, '
      'inicio_escala INTEGER, '
      'fim_escala INTEGER, '
      'intervalo_escala INTEGER, '
      'comentario_escala INTEGER, '
      'midia TEXT, '
      'opcao_nao_se_aplica TEXT, '
      'comentarios TEXT, '
      'tipo_resposta_fixa TEXT, '
      'tamanho_resposta_fixa INTEGER, '
      'resp_simnao TEXT, '
      'resp_texto TEXT, '
      'resp_numero INTEGER, '
      'resp_data TEXT, '
      'resp_hora TEXT, '
      'resp_escala INTEGER, '
      'resp_cq TEXT, '
      'resp_nao_se_aplica TEXT, '
      'descr_comentarios TEXT, '
      'status_resposta TEXT, '
      'status_aprovacao TEXT, '
      'sugestao_resposta TEXT, '
      'sincronizado TEXT, '
      'PRIMARY KEY (codigo_empresa, codigo_programacao, '
      '             registro_colaborador, identificacao_utilizador, item_checklist))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    //debugPrint('path: $path');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(SpsDaoQuestionarioItem.tableSql);
        debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoQuestionarioItem.tableSql);
    debugPrint('Tabela (checklist_item) criada com sucesso ou já existente!');
  }

  Future<int> save(List<Map<String, dynamic>> dadosQuestionarioItem) async {
    final Database db = await getDatabase();
    var wregistros = dadosQuestionarioItem.length;
    var windex = 0;
    while (windex < wregistros) {
      if (dadosQuestionarioItem[windex]['inicio_escala'].toString() == "") {
        dadosQuestionarioItem[windex]['inicio_escala'] = null;
      }
      if (dadosQuestionarioItem[windex]['fim_escala'].toString() == "") {
        dadosQuestionarioItem[windex]['fim_escala'] = null;
      }
      if (dadosQuestionarioItem[windex]['intervalo_escala'].toString() == "") {
        dadosQuestionarioItem[windex]['intervalo_escala'] = null;
      }
      if (dadosQuestionarioItem[windex]['comentario_escala'].toString() == "") {
        dadosQuestionarioItem[windex]['comentario_escala'] = null;
      }
      if (dadosQuestionarioItem[windex]['tamanho_resposta_fixa'].toString() ==
          "") {
        dadosQuestionarioItem[windex]['tamanho_resposta_fixa'] = null;
      }
      if (dadosQuestionarioItem[windex]['resp_numero'].toString() == "") {
        dadosQuestionarioItem[windex]['resp_numero'] = null;
      }
      if (dadosQuestionarioItem[windex]['resp_escala'].toString() == "") {
        dadosQuestionarioItem[windex]['resp_escala'] = null;
      }
      var _query = 'insert into checklist_item values ("' +
          dadosQuestionarioItem[windex]['codigo_empresa'] +
          '",' +
          dadosQuestionarioItem[windex]['codigo_programacao'].toString() +
          ',"' +
          dadosQuestionarioItem[windex]['registro_colaborador'] +
          '","' +
          dadosQuestionarioItem[windex]['identificacao_utilizador'] +
          '",' +
          dadosQuestionarioItem[windex]['item_checklist'].toString() +
          ',"' +
          dadosQuestionarioItem[windex]['sessao_checklist'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['codigo_grupo'].toString() +
          '",' +
          dadosQuestionarioItem[windex]['codigo_checklist'].toString() +
          ',' +
          dadosQuestionarioItem[windex]['seq_pergunta'].toString() +
          ',"' +
          dadosQuestionarioItem[windex]['descr_pergunta'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['codigo_pergunta_dependente']
              .toString() +
          '","' +
          dadosQuestionarioItem[windex]['resposta_pergunta_dependente']
              .toString() +
          '","' +
          dadosQuestionarioItem[windex]['tipo_resposta'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['comentario_resposta_nao'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['descr_escala'].toString() +
          '",' +
          dadosQuestionarioItem[windex]['inicio_escala'].toString() +
          ',' +
          dadosQuestionarioItem[windex]['fim_escala'].toString() +
          ',' +
          dadosQuestionarioItem[windex]['intervalo_escala'].toString() +
          ',' +
          dadosQuestionarioItem[windex]['comentario_escala'].toString() +
          ',"' +
          dadosQuestionarioItem[windex]['midia'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['opcao_nao_se_aplica'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['comentarios'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['tipo_resposta_fixa'].toString() +
          '",' +
          dadosQuestionarioItem[windex]['tamanho_resposta_fixa'].toString() +
          ',"' +
          dadosQuestionarioItem[windex]['resp_simnao'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['resp_texto'].toString() +
          '",' +
          dadosQuestionarioItem[windex]['resp_numero'].toString() +
          ',"' +
          dadosQuestionarioItem[windex]['resp_data'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['resp_hora'].toString() +
          '",' +
          dadosQuestionarioItem[windex]['resp_escala'].toString() +
          ',"' +
          dadosQuestionarioItem[windex]['resp_cq'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['resp_nao_se_aplica'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['descr_comentarios'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['status_resposta'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['status_aprovacao'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['sugestao_resposta'].toString() +
          '","' +
          dadosQuestionarioItem[windex]['sincronizado'].toString() +
          '")';
      //String _new_query = _query.replaceAll(',,',',0,');
      debugPrint("query => " + _query);
      db.rawInsert(_query);
      windex = windex + 1;
    }
    return 1;
  }

  Future<int> update_opcao(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hrespCq,
      _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set resp_cq = "' +
        _hrespCq +
        '", sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _hregistroColaborador +
        '" and identificacao_utilizador = "' +
        _hidentificacaoUtilizador +
        '" and item_checklist = ' +
        _hitemChecklist.toString();
    debugPrint("query => " + _query);
    db.rawUpdate(_query);
    debugPrint("SQLITE - Alterado referencia (checklist_item)");
    return 1;
  }

  Future<int> update_resposta(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hrespTexto,
      _hrespNumero,
      _hrespData,
      _hrespHora,
      _hrespSimnao,
      _hrespEscala,
      _hsincronizado) async {
    final Database db = await getDatabase();

    if (_hrespNumero.toString() == "") {
      _hrespNumero = null;
    }

    var _query = 'update checklist_item set resp_texto = "' +
        _hrespTexto +
        '", resp_numero = ' +
        int.parse(_hrespNumero.toString(), onError: (e) => null).toString() +
        ', resp_data = "' +
        _hrespData.toString() +
        '", resp_hora = "' +
        _hrespHora +
        '", resp_simnao = "' +
        _hrespSimnao +
        '", resp_escala = ' +
        int.parse(_hrespEscala.toString(), onError: (e) => null).toString() +
        ', sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _hregistroColaborador +
        '" and identificacao_utilizador = "' +
        _hidentificacaoUtilizador +
        '" and item_checklist = ' +
        _hitemChecklist.toString();
    debugPrint("query => " + _query);
    db.rawUpdate(_query);
    debugPrint("SQLITE - Alterado resposta (checklist_item)");
    return 1;
  }

  Future<int> update_status_resposta(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hstatusResposta,
      _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set status_resposta = "' +
        _hstatusResposta +
        '", sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _hregistroColaborador +
        '" and identificacao_utilizador = "' +
        _hidentificacaoUtilizador +
        '" and item_checklist = ' +
        _hitemChecklist.toString();
    db.rawUpdate(_query);
    debugPrint("SQLITE - Alterado resposta (checklist_item)");
    return 1;
  }

  Future<int> update_aprovacao(_hcodigoEmpresa, _hcodigoProgramacao,
      _hitemChecklist, _hstatusAprovacao, _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set status_aprovacao = "' +
        _hstatusAprovacao +
        '", sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and item_checklist = ' +
        _hitemChecklist.toString();
    debugPrint("query => " + _query);
    db.rawUpdate(_query);
    debugPrint("SQLITE - Alterado aprovação (checklist_item)");
    return 1;
  }

  Future<int> update_comentarios(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hdescrComentarios) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set descr_comentarios = "' +
        _hdescrComentarios.toString() +
        '", sincronizado = "N" where codigo_empresa = "' +
        _hcodigoEmpresa.toString() +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        '  and item_checklist = ' +
        _hitemChecklist.toString();
    debugPrint("query => " + _query);
    db.rawUpdate(_query);
    debugPrint("SQLITE - Alterado comentario (checklist_item)");
    return 1;
  }

  Future<List<Map<String, dynamic>>> select_sincronizacao(
      _hcodigoEmpresa, _hcodigoProgramacao, _hregistroColaborador, _hidentificacaoUtilizador) async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_item where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _hregistroColaborador.toString() +
        '" and identificacao_utilizador = "' +
        _hidentificacaoUtilizador.toString() +
        '" and sincronizado = "N"';
    debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> select_chave_primaria(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist) async {
    final Database db = await getDatabase();
    var _query =
        'SELECT *, (select count(*) from sps_checklist_tb_resp_anexo b where b.codigo_empresa = a.codigo_empresa and b.codigo_programacao = a.codigo_programacao and b.registro_colaborador = a.registro_colaborador and b.identificacao_utilizador = a.identificacao_utilizador and b.item_checklist = a.item_checklist) as qtde_anexos FROM checklist_item a where codigo_empresa = "' +
            _hcodigoEmpresa +
            '" and a.codigo_programacao = ' +
            _hcodigoProgramacao.toString() +
            ' and a.registro_colaborador = "' +
            _hregistroColaborador.toString() +
            '" and a.identificacao_utilizador = "' +
            _hidentificacaoUtilizador.toString() +
            '" and a.item_checklist = ' +
            _hitemChecklist.toString();
    print("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> emptyTable(_hcodigoEmpresa, _hcodigoProgramacao) async {
    final Database db = await getDatabase();
    var _query = 'delete from checklist_item where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString();
    debugPrint("query => " + _query);
    return db.rawDelete(_query);
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioItemLocal(
      _hcodigoEmpresa, _hcodigoProgramacao, _hacao, _hsessaoChecklist) async {
    final Database db = await getDatabase();
    final SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao = SpsDaoQuestionarioMidia();
    await objQuestionarioCqMidiaDao.create_table();
    var _query = 'SELECT *, '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D")) as anexos, '
        '(select count(*) from checklist_item item2 where item2.codigo_empresa = item.codigo_empresa and item2.codigo_programacao = item.codigo_programacao and item2.sessao_checklist > item.sessao_checklist) as sessao_posterior, '
        '(select count(*) from checklist_item item2 where item2.codigo_empresa = item.codigo_empresa and item2.codigo_programacao = item.codigo_programacao and item2.sessao_checklist < item.sessao_checklist) as sessao_anterior '
    'FROM checklist_item item where item.codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and item.codigo_programacao = ' +
        _hcodigoProgramacao.toString();
    if (_hacao.toString() == "PROXIMO") {
      _query = _query +
          ' and item.sessao_checklist > "' +
          _hsessaoChecklist.toString() +
          '" order by item.sessao_checklist, item.seq_pergunta';
    } else {
      _query = _query +
          ' and item.sessao_checklist < "' +
          _hsessaoChecklist.toString() +
          '" order by item.sessao_checklist desc, item.seq_pergunta';
    }
    debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }
}
