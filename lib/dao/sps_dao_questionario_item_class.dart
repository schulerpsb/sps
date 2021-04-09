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
      'subcodigo_tpresposta INTEGER, '
      'descr_sub_tpresposta TEXT, '
      'tamanho_texto_adicional INTEGER, '
      'obrigatorio_texto_adicional TEXT, '
      'subcodigo_resposta INTEGER, '
      'texto_adicional TEXT, '
      'sincronizado TEXT, '
      'PRIMARY KEY (codigo_empresa, codigo_programacao, '
      '             registro_colaborador, identificacao_utilizador, item_checklist, subcodigo_tpresposta))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    //debugPrint('path: $path');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(SpsDaoQuestionarioItem.tableSql);
        //debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoQuestionarioItem.tableSql);
    //debugPrint('Tabela (checklist_item) criada com sucesso ou já existente!');
  }

  Future<int> save(List<Map<String, dynamic>> dadosQuestionarioItem) async {
    final Database db = await getDatabase();
    await Future.forEach(dadosQuestionarioItem, (item) async {
      item['registro_colaborador'] = "";
      item['identificacao_utilizador'] = "";

      if (item['inicio_escala'].toString() == "") {
        item['inicio_escala'] = null;
      }
      if (item['fim_escala'].toString() == "") {
        item['fim_escala'] = null;
      }
      if (item['intervalo_escala'].toString() == "") {
        item['intervalo_escala'] = null;
      }
      if (item['comentario_escala'].toString() == "") {
        item['comentario_escala'] = null;
      }
      if (item['tamanho_resposta_fixa'].toString() == "") {
        item['tamanho_resposta_fixa'] = null;
      }
      if (item['resp_numero'].toString() == "") {
        item['resp_numero'] = null;
      }
      if (item['resp_escala'].toString() == "") {
        item['resp_escala'] = null;
      }
      if (item['subcodigo_tpresposta'].toString() == "") {
        item['subcodigo_tpresposta'] = null;
      }
      if (item['tamanho_texto_adicional'].toString() == "") {
        item['tamanho_texto_adicional'] = null;
      }
      if (item['subcodigo_resposta'].toString() == "") {
        item['subcodigo_resposta'] = null;
      }
      var _query2 = 'SELECT * FROM checklist_item where codigo_empresa = "' +
          item['codigo_empresa'] +
          '" and codigo_programacao = ' +
          item['codigo_programacao'].toString() +
          ' and registro_colaborador = "' +
          item['registro_colaborador'] +
          '" and identificacao_utilizador = "' +
          item['identificacao_utilizador'] +
          '" and item_checklist = ' +
          item['item_checklist'].toString() +
          ' and subcodigo_tpresposta = ' +
          item['subcodigo_tpresposta'].toString();
      List<Map<String, dynamic>> result2 = await db.rawQuery(_query2);
      if (result2.length <= 0) {
        var _query = 'insert into checklist_item values ("' +
            item['codigo_empresa'] +
            '",' +
            item['codigo_programacao'].toString() +
            ',"' +
            item['registro_colaborador'] +
            '","' +
            item['identificacao_utilizador'] +
            '",' +
            item['item_checklist'].toString() +
            ',"' +
            item['sessao_checklist'] +
            '","' +
            item['codigo_grupo'] +
            '",' +
            item['codigo_checklist'].toString() +
            ',' +
            item['seq_pergunta'].toString() +
            ',"' +
            item['descr_pergunta'] +
            '","' +
            item['codigo_pergunta_dependente'] +
            '","' +
            item['resposta_pergunta_dependente'] +
            '","' +
            item['tipo_resposta'] +
            '","' +
            item['comentario_resposta_nao'] +
            '","' +
            item['descr_escala'] +
            '",' +
            item['inicio_escala'].toString() +
            ',' +
            item['fim_escala'].toString() +
            ',' +
            item['intervalo_escala'].toString() +
            ',' +
            item['comentario_escala'].toString() +
            ',"' +
            item['midia'] +
            '","' +
            item['opcao_nao_se_aplica'] +
            '","' +
            item['comentarios'] +
            '","' +
            item['tipo_resposta_fixa'] +
            '",' +
            item['tamanho_resposta_fixa'].toString() +
            ',"' +
            item['resp_simnao'] +
            '","' +
            item['resp_texto'] +
            '",' +
            item['resp_numero'].toString() +
            ',"' +
            item['resp_data'] +
            '","' +
            item['resp_hora'] +
            '",' +
            item['resp_escala'].toString() +
            ',"' +
            item['resp_cq'] +
            '","' +
            item['resp_nao_se_aplica'] +
            '","' +
            item['descr_comentarios'] +
            '","' +
            item['status_resposta'] +
            '","' +
            item['status_aprovacao'] +
            '","' +
            item['sugestao_resposta'] +
            '",' +
            item['subcodigo_tpresposta'].toString() +
            ',"' +
            item['descr_sub_tpresposta'].toString() +
            '",' +
            item['tamanho_texto_adicional'].toString() +
            ',"' +
            item['obrigatorio_texto_adicional'].toString() +
            '",' +
            item['subcodigo_resposta'].toString() +
            ',"' +
            item['texto_adicional'].toString() +
            '","")';
        //print ("adriano => query =>"+_query);
        await db.rawInsert(_query);
      }
    });
    return 1;
  }

  Future<int> update_opcao(_hcodigoEmpresa,
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
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    //debugPrint("SQLITE - Alterado referencia (checklist_item)");
    return 1;
  }

  Future<int> update_resposta(_hcodigoEmpresa,
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

    var _query = 'update checklist_item set resp_texto = "' +
        _hrespTexto.toString() +
        '", resp_numero = ' +
        int.parse(_hrespNumero.toString(), onError: (e) => null).toString() +
        ', resp_data = "' +
        _hrespData.toString() +
        '", resp_hora = "' +
        _hrespHora.toString() +
        '", resp_simnao = "' +
        _hrespSimnao.toString() +
        '", resp_escala = ' +
        int.parse(_hrespEscala.toString(), onError: (e) => null).toString() +
        ', resp_nao_se_aplica = null' +
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
    print ("adriano query=>"+_query.toString());
    db.rawUpdate(_query);
    return 1;
  }

  Future<int> update_resposta_nao_se_aplica(_hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hnaoSeAplica,
      _hsincronizado) async {
    final Database db = await getDatabase();

    var _query = 'update checklist_item set resp_texto = null,'
        'resp_numero = null, resp_data = null, resp_hora = null, resp_simnao = null,'
        'resp_escala = null, resp_nao_se_aplica = "'+ _hnaoSeAplica +'", descr_comentarios = null, '
        'sincronizado = "N" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _hregistroColaborador +
        '" and identificacao_utilizador = "' +
        _hidentificacaoUtilizador +
        '" and item_checklist = ' +
        _hitemChecklist.toString();
    print ("adriano query2=>"+_query.toString());
    db.rawUpdate(_query);

    //Limpar arquivos anexados
    var _query2 = 'update sps_checklist_tb_resp_anexo set sincronizado = "D"'
        ' where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _hregistroColaborador +
        '" and identificacao_utilizador = "' +
        _hidentificacaoUtilizador +
        '" and item_checklist = ' +
        _hitemChecklist.toString();
    //debugPrint("query => " + _query);
    db.rawUpdate(_query2);
    return 1;
  }

  Future<int> update_status_resposta(_hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hstatusResposta,
      _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set status_resposta = "' +
        _hstatusResposta.toString() +
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
    print("query update status resposta ====> " + _query.toString());
    db.rawUpdate(_query);
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
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    //debugPrint("SQLITE - Alterado aprovação (checklist_item)");
    return 1;
  }

  Future<int> update_comentarios(_hcodigoEmpresa,
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
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    //debugPrint("SQLITE - Alterado comentario (checklist_item)");
    return 1;
  }

  //Usado somente na sincronização por demanda
  Future<List<Map<String, dynamic>>> select_sincronizacao(_hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador) async {
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
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  //Usado na sincronizaçõa em background
  Future<List<Map<String, dynamic>>> selectSincronizacaoItens() async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_item where sincronizado = "N"';
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> select_chave_primaria(_hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist) async {
    final Database db = await getDatabase();
    var _query =
        'SELECT *, (select count(*) from sps_checklist_tb_resp_anexo b where b.codigo_empresa = a.codigo_empresa and b.codigo_programacao = a.codigo_programacao and b.registro_colaborador = a.registro_colaborador and b.identificacao_utilizador = a.identificacao_utilizador and b.item_checklist = a.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null")) as qtde_anexos FROM checklist_item a where codigo_empresa = "' +
            _hcodigoEmpresa +
            '" and a.codigo_programacao = ' +
            _hcodigoProgramacao.toString() +
            ' and a.registro_colaborador = "' +
            _hregistroColaborador.toString() +
            '" and a.identificacao_utilizador = "' +
            _hidentificacaoUtilizador.toString() +
            '" and a.item_checklist = ' +
            _hitemChecklist.toString();
    //print("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> emptyTable(_hcodigoEmpresa, _hcodigoProgramacao) async {
    final Database db = await getDatabase();
    var _query = 'delete from checklist_item where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and (sincronizado is null or sincronizado = "")';
    //debugPrint("query => " + _query);
    return db.rawDelete(_query);
  }

  Future<int> emptyTableSincronizacao(_hcodigoEmpresa) async {
    final Database db = await getDatabase();
    var _query = 'delete from checklist_item where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and (sincronizado is null or sincronizado = "")';
    //debugPrint("query => " + _query);
    return db.rawDelete(_query);
  }  

  Future<List<Map<String, dynamic>>> listarQuestionarioItemLocal(
      _hcodigoEmpresa, _hcodigoProgramacao, _hacao, _hsessaoChecklist) async {
    final Database db = await getDatabase();
    final SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao =
    SpsDaoQuestionarioMidia();
    await objQuestionarioCqMidiaDao.create_table();
    var _query = 'SELECT *, '
        '(select count(*) from checklist_item item2 where item2.codigo_empresa = item.codigo_empresa and item2.codigo_programacao = item.codigo_programacao and item2.sessao_checklist > item.sessao_checklist) as sessao_posterior, '
        '(select count(*) from checklist_item item2 where item2.codigo_empresa = item.codigo_empresa and item2.codigo_programacao = item.codigo_programacao and item2.sessao_checklist < item.sessao_checklist) as sessao_anterior,  '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D")) as anexos,  '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) in ("jpg","JPG", "png", "PNG", "gif", "GIF")) as imagens,  '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) in ("mp4","MP4")) as videos, '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) not in ("mp4","MP4","jpg","JPG", "png", "PNG", "gif", "GIF")) as outros '
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
      if (_hacao.toString() == "ANTERIOR") {
        _query = _query +
            ' and item.sessao_checklist < "' +
            _hsessaoChecklist.toString() +
            '" order by item.sessao_checklist desc, item.seq_pergunta';
      } else {
        if (_hacao.toString() == "RECARREGAR") {
          _query = _query +
              ' and item.sessao_checklist = "' +
              _hsessaoChecklist.toString() +
              '" order by item.seq_pergunta';
        }
      }
    }
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> updateQuestionarioItemSincronizacao(_codigoEmpresa,
      _codigoProgramacao,
      _registroColaborador,
      _identificacaoUtilizador,
      _itemChecklist) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set sincronizado = "'
        '" where codigo_empresa = "' +
        _codigoEmpresa +
        '" and codigo_programacao = ' +
        _codigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _registroColaborador +
        '" and identificacao_utilizador = "' +
        _identificacaoUtilizador +
        '" and item_checklist = ' +
        _itemChecklist.toString();
    //print(_query.toString());
    db.rawUpdate(_query);
    return 1;
  }
}
