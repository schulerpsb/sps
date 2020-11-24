import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionario {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS lista_checklist('
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'codigo_grupo TEXT, '
      'codigo_checklist INTEGER, '
      'item_checklist INTEGER, '
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
      'PRIMARY KEY (codigo_empresa, codigo_programacao, registro_colaborador, identificacao_utilizador))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    debugPrint('path: $path');
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
    debugPrint('Tabela (lista_checklist) criada com sucesso ou já existente!');
  }

  Future<int> save(List<Map<String, dynamic>> dadosQuestionario) async {
    final Database db = await getDatabase();
    var wregistros = dadosQuestionario.length;
    var windex = 0;
    while (windex < wregistros) {
      db.insert('lista_checklist', dadosQuestionario[windex]);
      debugPrint("Gravando lista_checklist => " + dadosQuestionario[windex].toString());
      windex = windex + 1;
    }
    return null;
  }

  Future<int> emptyTable() async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from lista_checklist');
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioLocal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('lista_checklist');
    return result;
  }
}
