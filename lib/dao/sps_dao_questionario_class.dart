import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionario {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS checklist_lista('
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'codigo_grupo TEXT, '
      'codigo_checklist INTEGER, '
      'descr_programacao TEXT, '
      'dtfim_aplicacao DATE, '
      'percentual_evolucao FLOAT, '
      'status TEXT, '
      'referencia_parceiro TEXT, '
      'codigo_pedido TEXT, '
      'item_pedido INTEGER, '
      'codigo_projeto TEXT, '
      'descr_projeto TEXT, '
      'codigo_material TEXT, '
      'descr_comentarios TEXT, '
      'sincronizado TEXT, '
      'PRIMARY KEY (codigo_empresa, codigo_programacao, registro_colaborador, identificacao_utilizador))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    //debugPrint('path: $path');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(SpsDaoQuestionario.tableSql);
        debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoQuestionario.tableSql);
    debugPrint('Tabela (checklist_lista) criada com sucesso ou já existente!');
  }

  Future<int> save(List<Map<String, dynamic>> dadosQuestionario) async {
    final Database db = await getDatabase();
    var wregistros = dadosQuestionario.length;
    var windex = 0;
    while (windex < wregistros) {
      if (dadosQuestionario[windex]['registro_colaborador'] == null) {
        dadosQuestionario[windex]['registro_colaborador'] = "";
      }
      if (dadosQuestionario[windex]['identificacao_utilizador'] == null) {
        dadosQuestionario[windex]['identificacao_utilizador'] = "";
      }
      if (dadosQuestionario[windex]['item_pedido'] == null || dadosQuestionario[windex]['item_pedido'] == "") {
        dadosQuestionario[windex]['item_pedido'] = 0;
      }
      if (dadosQuestionario[windex]['descr_comentarios'] == null) {
        dadosQuestionario[windex]['descr_comentarios'] = "";
      }
      var _query = 'insert into checklist_lista values ("' +
          dadosQuestionario[windex]['codigo_empresa'].toString() +
          '",' +
          dadosQuestionario[windex]['codigo_programacao'].toString() +
          ',"' +
          dadosQuestionario[windex]['registro_colaborador'].toString() +
          '","' +
          dadosQuestionario[windex]['identificacao_utilizador'].toString() +
          '","' +
          dadosQuestionario[windex]['codigo_grupo'].toString() +
          '",' +
          dadosQuestionario[windex]['codigo_checklist'].toString() +
          ',"' +
          dadosQuestionario[windex]['descr_programacao'].toString() +
          '","' +
          dadosQuestionario[windex]['dtfim_aplicacao'].toString() +
          '","' +
          dadosQuestionario[windex]['percentual_evolucao'].toString() +
          '","' +
          dadosQuestionario[windex]['status'].toString() +
          '","' +
          dadosQuestionario[windex]['referencia_parceiro'].toString() +
          '","' +
          dadosQuestionario[windex]['codigo_pedido'].toString() +
          '",' +
          dadosQuestionario[windex]['item_pedido'].toString() +
          ',"' +
          dadosQuestionario[windex]['codigo_projeto'].toString() +
          '","' +
          dadosQuestionario[windex]['descr_projeto'].toString() +
          '","' +
          dadosQuestionario[windex]['codigo_material'].toString() +
          '","' +
          dadosQuestionario[windex]['descr_comentarios'].toString() +
          '",null)';
      db.rawInsert(_query);
      windex = windex + 1;
    }
    return null;
  }

  Future<int> update_referencia(_hcodigoEmpresa, _hcodigoProgramacao,
      _hreferencia, _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_lista set referencia_parceiro = "' +
        _hreferencia +
        '", sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString();
    debugPrint("query => " + _query);
    db.rawUpdate(_query);
    debugPrint("Alterado referencia (checklist_lista) => " + _hreferencia);
    return null;
  }

  Future<List<Map<String, dynamic>>> select_sincronizacao() async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_lista where sincronizado = "N"';
    debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> emptyTable() async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from checklist_lista');
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioGeral(
      _filtro, _filtroReferenciaProjeto, _origemUsuario) async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_lista ';
    if (_filtro.toString() != "" && _filtro.toString() != "null") {
      _query = _query + " where status = '" + _filtro.toString() + "'";
    }
    if (_filtroReferenciaProjeto.toString() != "" &&
        _filtroReferenciaProjeto.toString() != "null") {
      if (_origemUsuario == "EXTERNO") {
        _query = _query +
            " where referencia_parceiro like '%" +
            _filtroReferenciaProjeto.toString() +
            "%'";
      } else {
        _query = _query +
            " where codigo_projeto like '%" +
            _filtroReferenciaProjeto.toString() +
            "%'";
      }
    }
    debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> contarQuestionarioGeral() async {
    final Database db = await getDatabase();
    var _query =
        'SELECT status, count(*) as contador FROM checklist_lista group by status';
    debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }
}
