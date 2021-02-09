
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoLogin {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS sps_tb_usuario('
      'codigo_usuario TEXT PRIMARY KEY, '
      'nome_usuario TEXT, '
      'telefone_usuario TEXT, '
      'email_usuario TEXT, '
      'cargo_usuario TEXT, '
      'pais_usuario TEXT, '
      'lingua_usuario TEXT, '
      'senha_usuario TEXT, '
      'status_usuario TEXT, '
      'dt_validade_senha TEXT, '
      'qtd_tentativas_senha INTEGER, '
      'codigo_planta INTEGER, '
      'dthratualizacao TEXT, '
      'chave TEXT, '
      'status_token TEXT, '
      'dt_validade_usuario TEXT, '
      'dt_reset_senha TEXT, '
      'tipo TEXT, '
      'registro_usuario TEXT)';

  //String para inserção de registro de teste
  static final String SqlInsertTest = "INSERT INTO sps_tb_usuario (codigo_usuario,nome_usuario,telefone_usuario,email_usuario,cargo_usuario,pais_usuario,lingua_usuario,senha_usuario,status_usuario,dt_validade_senha,qtd_tentativas_senha,codigo_planta,dthratualizacao,chave,status_token,dt_validade_usuario,dt_reset_senha,tipo,registro_usuario) VALUES ('fernandof','FERNANDO BELA FERRACINI','+11 95 24637-08','Fernandoferracini@gmail.com','SUPERVISOR DE MANUTENÇÃO','Brasil','PT','\$2y\$10\$ZuFKLkwri8.g6sn4bSOmL.XF36kGkAv4g0l40mYyOCcnYDetxMIEm','ATIVO','1900-01-01',1,7000,'2021-02-08 11:38:30.998589','M4ZSNSZWLI2NY5GR','ATIVO','1900-01-01','2021-02-08 08:28:32','FORNECEDOR','')";

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    debugPrint('CAMINHO DO SQLITE DB: $path');
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

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoLogin.tableSql);
    debugPrint('Tabela (sps_tb_usuario) criada com sucesso ou já existente!');
    //criação de registro de teste
    //db.execute(SpsDaoLogin.SqlInsertTest);
    //debugPrint('Regsitro de teste criado com sucesso!');
  }

  Future<int> save(Map<String, dynamic> dadosUsuario) async {
    final Database db = await getDatabase();
    return db.insert('sps_tb_usuario', dadosUsuario);
  }

  Future<int> emptyTable(Map<String, dynamic> dadosUsuario) async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from sps_tb_usuario');
  }

  Future<int> deleteLocalUser() async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from sps_tb_usuario');
  }

  Future<List<Map<String, dynamic>>> listaUsuarioLocal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('sps_tb_usuario');
    return result;
  }


}