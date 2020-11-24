import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionarioItem {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS checklist_item('
      'acao TEXT, '
      'sessao_checklist TEXT, '
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'codigo_grupo TEXT, '
      'codigo_checklist TEXT, '
      'seq_pergunta INTEGER, '
      'descr_pergunta TEXT, '
      'resp_cq TEXT, '
      'PRIMARY KEY (acao, sessao_checklist, codigo_empresa, codigo_programacao, '
      '             registro_colaborador, identificacao_utilizador, codigo_grupo, '
      '             codigo_checklist))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    debugPrint('path: $path');
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
      db.insert('checklist_item', dadosQuestionarioItem[windex]);
      debugPrint("Gravando checklist_item => " +
          dadosQuestionarioItem[windex].toString());
      windex = windex + 1;
    }
    return null;
  }

  Future<int> emptyTable() async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from checklist_item');
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioItemLocal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('checklist_item');
    debugPrint('==>' + result.toString());
    return result;
  }
}
