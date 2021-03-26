import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionarioRespMultipla {
  static final String tableSql =
      'CREATE TABLE IF NOT EXISTS checklist_resp_multipla('
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'item_checklist INTEGER, '
      'codigo_tpresposta INTEGER, '
      'subcodigo_tpresposta TEXT, '
      'descr_sub_tpresposta TEXT, '
      'tamanho_texto_adicional INTEGER, '
      'obrigatorio_texto_adicional TEXT, '
      'subcodigo_resposta TEXT, '
      'texto_adicional TEXT, '
      'sincronizado TEXT, '
      'PRIMARY KEY (codigo_empresa, codigo_programacao, '
      '             registro_colaborador, identificacao_utilizador, item_checklist, codigo_tpresposta, subcodigo_tpresposta))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    //debugPrint('path: $path');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(SpsDaoQuestionarioRespMultipla.tableSql);
        //debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoQuestionarioRespMultipla.tableSql);
    //debugPrint('Tabela (checklist_respo) criada com sucesso ou já existente!');
  }

  Future<int> save(
      List<Map<String, dynamic>> dadosQuestionarioRespMultipla) async {
    final Database db = await getDatabase();
    print ("adriano =>"+dadosQuestionarioRespMultipla.toString());
    await Future.forEach(dadosQuestionarioRespMultipla, (item) async {
      item['registro_colaborador'] = "";
      item['identificacao_utilizador'] = "";

      if (item['tamanho_texto_adicional'].toString() == "") {
        item['tamanho_texto_adicional'] = null;
      }

      var _query2 =
          'SELECT * FROM checklist_resp_multipla where codigo_empresa = "' +
              item['codigo_empresa'] +
              '" and codigo_programacao = ' +
              item['codigo_programacao'].toString() +
              ' and registro_colaborador = "' +
              item['registro_colaborador'] +
              '" and identificacao_utilizador = "' +
              item['identificacao_utilizador'] +
              '" and item_checklist = ' +
              item['item_checklist'].toString() +
              ' and codigo_tpresposta = ' +
              item['codigo_tpresposta'].toString() +
              ' and subcodigo_tpresposta = "' +
              item['subcodigo_tpresposta'] +
              '"';
      print ("adriano => query => "+ _query2.toString());
      List<Map<String, dynamic>> result2 = await db.rawQuery(_query2);
      if (result2.length <= 0) {
        var _query = 'insert into checklist_resp_multipla values ("' +
            item['codigo_empresa'] +
            '",' +
            item['codigo_programacao'].toString() +
            ',"' +
            item['registro_colaborador'] +
            '","' +
            item['identificacao_utilizador'] +
            '",' +
            item['item_checklist'].toString() +
            ',' +
            item['codigo_tpresposta'] +
            ',"' +
            item['subcodigo_tpresposta'] +
            '","' +
            item['descr_sub_tpresposta'].toString() +
            '",' +
            item['tamanho_texto_adicional'].toString() +
            ',"' +
            item['obrigatorio_texto_adicional'] +
            '","' +
            item['subcodigo_resposta'] +
            '","' +
            item['texto_adicional'] +
            '","")';
        print ("adriano => query => "+ _query.toString());
        await db.rawInsert(_query);
      }
    });
    return 1;
  }

  Future<int> update_resp_multipla(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hcodigoTpresposta,
      _hsubcodigoTpresposta,
      _hsubcodigoResposta,
      _htextoAdicional,
      _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set subcodigo_resposta = "' +
        _hsubcodigoResposta +
        '", texto_adicional = "' +
        _htextoAdicional +
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
        _hitemChecklist.toString() +
        ' and codigo_tpresposta = ' +
        _hcodigoTpresposta.toString() +
        ' and subcodigo_tpresposta = "' +
        _hsubcodigoTpresposta +
        '"';
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    //debugPrint("SQLITE - Alterado referencia (checklist_item)");
    return 1;
  }

  //Usado somente na sincronização por demanda
  Future<List<Map<String, dynamic>>> select_sincronizacao(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador) async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_resp_multipla where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _hregistroColaborador.toString() +
        '" and identificacao_utilizador = "' +
        _hidentificacaoUtilizador.toString() +
        '" and sincronizado in ("N","D")';
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  //Usado na sincronizaçõa em background
  Future<List<Map<String, dynamic>>> selectSincronizacaoRespMultipla() async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_resp_multipla where sincronizado in ("N","D")';
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> select_chave_primaria(
      _hcodigoEmpresa,
      _hcodigoProgramacao,
      _hregistroColaborador,
      _hidentificacaoUtilizador,
      _hitemChecklist,
      _hcodigoTpresposta,
      _hsubcodigoTpresposta) async {
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
            '" and item_checklist = ' +
            _hitemChecklist.toString() +
            ' and codigo_tpresposta = ' +
            _hcodigoTpresposta.toString() +
            ' and subcodigo_tpresposta = "' +
            _hsubcodigoTpresposta +
            '"';
    //print("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> emptyTable(_hcodigoEmpresa, _hcodigoProgramacao, _hregistroColaborador, _hidentificacaoUtilizador, _hcodigoGrupo, _hcodigoChecklist ) async {
    final Database db = await getDatabase();
    var _query = 'delete from checklist_resp_multipla where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and (sincronizado is null or sincronizado = "")';
    //debugPrint("query => " + _query);
    return db.rawDelete(_query);
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioRespMultiplaLocal(
      _hcodigoEmpresa, _hcodigoProgramacao, _hitemChecklist) async {
    final Database db = await getDatabase();
    final SpsDaoQuestionarioRespMultipla objQuestionarioRespMultiplaDao =
    SpsDaoQuestionarioRespMultipla();
    await objQuestionarioRespMultiplaDao.create_table();
    var _query = 'SELECT * FROM checklist_resp_multipla where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        ' and item_checklist = ' +
        _hitemChecklist.toString() +
        ' order by codigo_tpresposta, subcodigo_tpresposta';
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> updateQuestionarioRespMultiplaSincronizacao(
      _codigoEmpresa,
      _codigoProgramacao,
      _registroColaborador,
      _identificacaoUtilizador,
      _itemChecklist,
      _subcodigoResposta) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_resp_multipla set sincronizado = "'
            '" where codigo_empresa = "' +
        _codigoEmpresa +
        '" and codigo_programacao = ' +
        _codigoProgramacao.toString() +
        ' and registro_colaborador = "' +
        _registroColaborador +
        '" and identificacao_utilizador = "' +
        _identificacaoUtilizador +
        '" and item_checklist = ' +
        _itemChecklist.toString() +
        ' and subcodigo_resposta = "' +
        _subcodigoResposta + '"';
    //print(_query.toString());
    db.rawUpdate(_query);
    return 1;
  }
}
