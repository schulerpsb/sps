
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionario {
  static final String tableSql = 'CREATE TABLE lista_checklist('
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'descr_programacao TEXT, '
      'dtfim_aplicacao DATE, '
      'percentual_evolucao FLOAT, '
      'status TEXT, '
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

  Future<int> create_table(Map<String, dynamic> dadosQuestionario) async {
    final Database db = await getDatabase();
    db.execute(SpsDaoQuestionario.tableSql);
    debugPrint('Tabela criada com sucesso!');
  }

  Future<int> save(Map<String, dynamic> dadosQuestionario) async {
    final Database db = await getDatabase();
    return db.insert('lista_checklist', dadosQuestionario);
  }

  Future<int> emptyTable(Map<String, dynamic> dadosQuestionario) async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from lista_checklist');
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioLocal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('lista_checklist');
    return result;
  }


}