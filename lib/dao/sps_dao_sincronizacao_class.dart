
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoSincronizacao {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS sps_tb_sincronizacao('
      'id_isolate INTEGER, '
      'data_ultima_sincronizacao TEXT,'
      'status INTEGER)';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(SpsDaoSincronizacao.tableSql);
        debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoSincronizacao.tableSql);
    debugPrint('Tabela (sps_tb_sincronizacao) criada com sucesso ou já existente!');
  }

  Future<int> save(Map<String, dynamic> dadosUsuario) async {
    final Database db = await getDatabase();
    return db.insert('sps_tb_sincronizacao', dadosUsuario);
  }

  Future<int> emptyTable() async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from sps_tb_sincronizacao');
  }

  Future<List<Map<String, dynamic>>> listaDadosSincronizacao() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.rawQuery("SELECT id_isolate, strftime('%d/%m/%Y - %H:%M', data_ultima_sincronizacao) as data_ultima_sincronizacao, status FROM sps_tb_sincronizacao");
    return result;
  }

  Future<int> update(Map<String, dynamic> dadosUsuario) async {
    final Database db = await getDatabase();
    return db.rawUpdate("update sps_tb_sincronizacao set status = "+dadosUsuario['status'].toString()+" where id_isolate = "+dadosUsuario['id_isolate'].toString());
  }


}