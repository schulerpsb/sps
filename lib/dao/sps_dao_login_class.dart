
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoLogin {
  static final String tableSql = 'CREATE TABLE causrl0('
      'id INTEGER PRIMARY KEY, '
      'nmusuario TEXT, '
      'cdnivel TEXT, '
      'nrregistro TEXT, '
      'cddepartam TEXT, '
      'nmfunciona TEXT, '
      'cdcentcust TEXT, '
      'datainclus TEXT, '
      'dataaltera TEXT, '
      'nmusuaralt TEXT, '
      'dtvalidade TEXT, '
      'nmmaquina TEXT, '
      'nmusuariorede TEXT, '
      'nmusuariosap TEXT, '
      'dthratualizacao TEXT)';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    debugPrint('path: $path');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(SpsDaoLogin.tableSql);
        debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> save(Map<String, dynamic> dadosUsuario) async {
    final Database db = await getDatabase();
    return db.insert('causrl0', dadosUsuario);
  }

  Future<int> emptyTable(Map<String, dynamic> dadosUsuario) async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from causrl0');
  }

  Future<List<Map<String, dynamic>>> listaUsuarioLocal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('causrl0');
    return result;
  }


}