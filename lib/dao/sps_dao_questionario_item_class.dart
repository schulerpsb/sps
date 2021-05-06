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
      'codigo_pergunta INT, '
      'seq_pergunta INTEGER, '
      'descr_pergunta TEXT, '
      'codigo_pergunta_dependente INT, '
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
      //item['registro_colaborador'] = "";
      //item['identificacao_utilizador'] = "";

      if (item['codigo_pergunta_dependente'].toString() == "") {
        item['codigo_pergunta_dependente'] = null;
      }
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
        item['subcodigo_tpresposta'] = 0;
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
            item['codigo_pergunta'].toString() +
            ',' +
            item['seq_pergunta'].toString() +
            ',"' +
            item['descr_pergunta'] +
            '",' +
            item['codigo_pergunta_dependente'].toString() +
            ',"' +
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
        //print ("query =>"+_query);
        await db.rawInsert(_query);
      }
    });
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
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    //debugPrint("SQLITE - Alterado referencia (checklist_item)");
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
      _hsubcodigoTpresposta,
      _hsubcodigoResposta,
      _htextoAdicional,
      _hsincronizado) async {
    final Database db = await getDatabase();

    //_hregistroColaborador = "";
    //_hidentificacaoUtilizador = "";

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
        ', subcodigo_resposta = ' +
        int.parse(_hsubcodigoResposta.toString(), onError: (e) => null)
            .toString() +
        ', texto_adicional = "' +
        _htextoAdicional.toString() +
        '", sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        //' and registro_colaborador = "' +
        //_hregistroColaborador +
        //'" and identificacao_utilizador = "' +
        //_hidentificacaoUtilizador +
        ' and item_checklist = ' +
        _hitemChecklist.toString() +
        ' and subcodigo_tpresposta = ' +
        _hsubcodigoTpresposta.toString();
    //print("adriano query1=>" + _query.toString());
    db.rawUpdate(_query);

    return 1;
  }

  Future<int> update_resposta_pergunta_dependente(
      _hcodigoEmpresa,
      _hcodigoProgramacao) async {
    final Database db = await getDatabase();

    var _query = 'update checklist_item set resp_texto = "", resp_numero = null, resp_data = "", resp_hora = "", resp_simnao = "", resp_escala = null, resp_nao_se_aplica = null, subcodigo_resposta = null, texto_adicional = "", descr_comentarios = "", resp_nao_se_aplica = "", status_resposta = "PREENCHIDA", sincronizado = "N" '
                 'where codigo_empresa = "' + _hcodigoEmpresa + '" and codigo_programacao = ' + _hcodigoProgramacao.toString() +
                  ' and codigo_pergunta_dependente is not null '
                  ' and resposta_pergunta_dependente not in (select max(x.resp_simnao) from checklist_item x where x.codigo_empresa = checklist_item.codigo_empresa and x.codigo_programacao = checklist_item.codigo_programacao and x.codigo_pergunta = checklist_item.codigo_pergunta_dependente) ';
    //print("query => update_resposta_pergunta_dependente=> " + _query.toString());
    db.rawUpdate(_query);

    var _query2 = 'update checklist_item set status_resposta = "PENDENTE", sincronizado = "N" '
        'where checklist_item.codigo_empresa = "' + _hcodigoEmpresa + '" and checklist_item.codigo_programacao = ' + _hcodigoProgramacao.toString() +
        ' and checklist_item.codigo_pergunta_dependente <> "" '
            ' and checklist_item.resposta_pergunta_dependente in (select max(x.resp_simnao) from checklist_item x where x.codigo_empresa = checklist_item.codigo_empresa and x.codigo_programacao = checklist_item.codigo_programacao and x.codigo_pergunta = checklist_item.codigo_pergunta_dependente) '
            ' and (checklist_item.resp_texto = "" or checklist_item.resp_texto is null) '
            ' and checklist_item.resp_numero is null and checklist_item.resp_data = "" and checklist_item.resp_hora = "" '
            ' and (checklist_item.resp_simnao = "" or checklist_item.resp_simnao is null) '
            ' and checklist_item.resp_escala is null '
            ' and (checklist_item.resp_nao_se_aplica = "" or checklist_item.resp_nao_se_aplica is null) '
            ' and (select max(y.subcodigo_resposta) from checklist_item y where y.codigo_empresa = checklist_item.codigo_empresa and y.codigo_programacao = checklist_item.codigo_programacao and y.registro_colaborador = checklist_item.registro_colaborador and y.identificacao_utilizador = checklist_item.identificacao_utilizador and y.item_checklist = checklist_item.item_checklist and y.subcodigo_resposta = y.subcodigo_tpresposta) is null ';
    //print("query2 => update_resposta_pergunta_dependente=> " + _query2.toString());
    db.rawUpdate(_query2);

    return 1;
  }

  Future<int> update_resposta_nao_se_aplica(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hnaoSeAplica,
      _hsincronizado) async {
    final Database db = await getDatabase();

    //_hregistroColaborador = "";
    //_hidentificacaoUtilizador = "";

    var _query = 'update checklist_item set resp_texto = null,'
            'resp_numero = null, resp_data = null, resp_hora = null, resp_simnao = null,'
            'resp_escala = null, resp_nao_se_aplica = "' +
        _hnaoSeAplica +
        '", descr_comentarios = null, subcodigo_resposta = null, texto_adicional = null,'
            'sincronizado = "N" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        //' and registro_colaborador = "' +
        //_hregistroColaborador +
        //'" and identificacao_utilizador = "' +
        //_hidentificacaoUtilizador +
        ' and item_checklist = ' +
        _hitemChecklist.toString();
    //print("adriano query2=>" + _query.toString());
    db.rawUpdate(_query);

    //Limpar arquivos anexados
    var _query2 = 'update sps_checklist_tb_resp_anexo set sincronizado = "D"'
            ' where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        //' and registro_colaborador = "' +
        //_hregistroColaborador +
        //'" and identificacao_utilizador = "' +
        //_hidentificacaoUtilizador +
        ' and item_checklist = ' +
        _hitemChecklist.toString();
    //debugPrint("query => " + _query);
    db.rawUpdate(_query2);
    return 1;
  }

  Future<int> update_resposta_nao_se_aplica_2(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hnaoSeAplica,
      _hsincronizado) async {
    final Database db = await getDatabase();

    //_hregistroColaborador = "";
    //_hidentificacaoUtilizador = "";

    var _query = 'update checklist_item set resp_nao_se_aplica = "' +
        _hnaoSeAplica +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
      //  ' and registro_colaborador = "' +
      //  _hregistroColaborador +
      //  '" and identificacao_utilizador = "' +
      //  _hidentificacaoUtilizador +
        ' and item_checklist = ' +
        _hitemChecklist.toString();
    //print("adriano query3=>" + _query.toString());
    db.rawUpdate(_query);

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

    //_hregistroColaborador = "";
    //_hidentificacaoUtilizador = "";

    var _query = 'update checklist_item set status_resposta = "' +
        _hstatusResposta.toString() +
        '", sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
      //  ' and registro_colaborador = "' +
      //  _hregistroColaborador +
      //  '" and identificacao_utilizador = "' +
      //  _hidentificacaoUtilizador +
        ' and item_checklist = ' +
        _hitemChecklist.toString();
    //print("query update status resposta item => " + _query.toString());
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
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    //debugPrint("SQLITE - Alterado comentario (checklist_item)");
    return 1;
  }

  //Usado somente na sincronização por demanda
  Future<List<Map<String, dynamic>>> select_sincronizacao(
      _hcodigoEmpresa,
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

  Future<List<Map<String, dynamic>>> select_chave_parcial_1(
      _hcodigoEmpresa,
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

  Future<List<Map<String, dynamic>>> select_chave_parcial_2(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist) async {
    final Database db = await getDatabase();
    var _query =
        'SELECT obrigatorio_texto_adicional, subcodigo_resposta, texto_adicional FROM checklist_item a where codigo_empresa = "' +
            _hcodigoEmpresa +
            '" and a.codigo_programacao = ' +
            _hcodigoProgramacao.toString() +
            ' and a.registro_colaborador = "' +
            _hregistroColaborador.toString() +
            '" and a.identificacao_utilizador = "' +
            _hidentificacaoUtilizador.toString() +
            '" and a.item_checklist = ' +
            _hitemChecklist.toString() + ' and subcodigo_resposta is not null';
    print("query ===> " + _query);
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
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) in ("mp4","MP4","mov","MOV")) as videos, '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) not in ("mp4","MP4","jpg","JPG", "png", "PNG", "gif", "GIF","mov","MOV")) as outros, '
        'case when item.codigo_pergunta_dependente <> "" then (select x.resp_simnao from checklist_item x where x.codigo_empresa = item.codigo_empresa and x.codigo_programacao = item.codigo_programacao and x.codigo_pergunta = item.codigo_pergunta_dependente) else "" end as resposta_pergunta_original, '
        'case when item.codigo_pergunta_dependente <> "" '
        '      and (item.resp_texto = "" or item.resp_texto is null) '
        '      and item.resp_numero is null and item.resp_data = "" and item.resp_hora = "" '
        '      and (item.resp_simnao = "" or item.resp_simnao is null) '
        '      and item.resp_escala is null '
        '      and (item.resp_nao_se_aplica = "" or item.resp_nao_se_aplica is null) '
        '      and (select max(y.subcodigo_resposta) from checklist_item y where y.codigo_empresa = item.codigo_empresa and y.codigo_programacao = item.codigo_programacao and y.registro_colaborador = item.registro_colaborador and y.identificacao_utilizador = item.identificacao_utilizador and y.item_checklist = item.item_checklist and item.subcodigo_resposta = item.subcodigo_tpresposta) = "" then "PENDENTE" else "" end as pendente_com_resposta_dependente '
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
    print ("query => listarQuestionarioItemLocal=> " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioItemLocal_item(
      _hcodigoEmpresa, _hcodigoProgramacao, _hacao, _hsessaoChecklist, _hitem_checklist) async {
    final Database db = await getDatabase();
    var _query = 'SELECT *, '
        '(select count(*) from checklist_item item2 where item2.codigo_empresa = item.codigo_empresa and item2.codigo_programacao = item.codigo_programacao and item2.sessao_checklist > item.sessao_checklist) as sessao_posterior, '
        '(select count(*) from checklist_item item2 where item2.codigo_empresa = item.codigo_empresa and item2.codigo_programacao = item.codigo_programacao and item2.sessao_checklist < item.sessao_checklist) as sessao_anterior,  '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D")) as anexos,  '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) in ("jpg","JPG", "png", "PNG", "gif", "GIF")) as imagens,  '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) in ("mp4","MP4","mov","MOV")) as videos, '
        '(select count(codigo_empresa) from sps_checklist_tb_resp_anexo where codigo_empresa = item.codigo_empresa and codigo_programacao = item.codigo_programacao and item_checklist = item.item_checklist and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) not in ("mp4","MP4","jpg","JPG", "png", "PNG", "gif", "GIF","mov","MOV")) as outros '
        'FROM checklist_item item where item.codigo_empresa = "' + _hcodigoEmpresa + '" '
        ' and item.codigo_programacao = ' + _hcodigoProgramacao.toString() +
        ' and item.sessao_checklist = "' + _hsessaoChecklist.toString() + '" '
        ' and item.item_checklist = ' + _hitem_checklist.toString() +
        ' order by item.seq_pergunta, item.subcodigo_tpresposta';

    //print("query item especifico => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> updateQuestionarioItemSincronizacao(
      _codigoEmpresa,
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
