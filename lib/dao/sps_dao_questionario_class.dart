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
      db.insert('checklist_lista', dadosQuestionario[windex]);
      debugPrint("Gravando checklist_lista => " + dadosQuestionario[windex].toString());
      windex = windex + 1;
    }
    return null;
  }

  Future<int> update_referencia(_hcodigoEmpresa, _hcodigoProgramacao, _hreferencia, _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_lista set referencia_parceiro = "'+_hreferencia+'", sincronizado = "'+_hsincronizado+'" where codigo_empresa = "'+_hcodigoEmpresa+'" and codigo_programacao = '+_hcodigoProgramacao.toString();
    debugPrint("query => "+_query);
    db.rawUpdate(_query);
    debugPrint("Alterado referencia (checklist_lista) => "+_hreferencia);
    return null;
  }

  Future<List<Map<String, dynamic>>> select_sincronizacao() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM checklist_lista where sincronizado = "N"');
    return result;
  }

  Future<int> emptyTable() async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from checklist_lista');
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioLocal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('checklist_lista');
    return result;
  }
}
