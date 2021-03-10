import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionarioMidia {
  static final String tableSql =
      'CREATE TABLE IF NOT EXISTS sps_checklist_tb_resp_anexo('
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'item_checklist INTEGER, '
      'item_anexo INTEGER, '
      'nome_arquivo TEXT, '
      'titulo_arquivo DATE, '
      'usuresponsavel TEXT, '
      'dthratualizacao TEXT, '
      'dthranexo TEXT, '
      'sincronizado TEXT, '
      'PRIMARY KEY (codigo_empresa, codigo_programacao, item_checklist,item_anexo))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    //debugPrint('path: $path');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(SpsDaoQuestionarioMidia.tableSql);
        //debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoQuestionarioMidia.tableSql);
    //debugPrint('Tabela (sps_checklist_tb_resp_anexo) criada com sucesso ou já existente!');
  }

  Future<int> save(List<Map<String, dynamic>> dadosQuestionario) async {
    final Database db = await getDatabase();
    await Future.forEach(dadosQuestionario, (anexo) async {
      //teste
      var _query2 =
          'SELECT * FROM sps_checklist_tb_resp_anexo where codigo_empresa = "' +
              anexo['codigo_empresa'].toString() +
              '" and codigo_programacao = ' +
              anexo['codigo_programacao'].toString() +
              ' and registro_colaborador = "' +
              anexo['registro_colaborador'].toString() +
              '" and identificacao_utilizador = "' +
              anexo['identificacao_utilizador'].toString() +
              '" and item_checklist = ' +
              anexo['item_checklist'].toString() +
              " and item_anexo = " +
              anexo['item_anexo'].toString();
      List<Map<String, dynamic>> result2 = await db.rawQuery(_query2);
      if (result2.length <= 0) {
        db.insert('sps_checklist_tb_resp_anexo', anexo);
      }
    });
    return 1;
  }

  Future<int> emptyTable(String codigo_programacao) async {
    final Database db = await getDatabase();
    return db.rawDelete(
        'delete from sps_checklist_tb_resp_anexo where (sincronizado is null or sincronizado == "") and codigo_programacao = ' +
            codigo_programacao.toString());
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioMidia(
      {String codigo_empresa = "",
      int codigo_programacao = 0,
      int item_checklist = 0}) async {
    final Database db = await getDatabase();
    var _query =
        'SELECT * FROM sps_checklist_tb_resp_anexo where codigo_empresa = "' +
            codigo_empresa +
            '" and codigo_programacao = ' +
            codigo_programacao.toString() +
            ' and item_checklist = ' +
            item_checklist.toString() +
            ' order by item_anexo desc';
    //debugPrint("query sss=> "+_query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> InserirQuestionarioMidia(
      {Map<String, dynamic> dadosArquivo}) async {
    final Database db = await getDatabase();
    String _queryinsert;
    if (dadosArquivo['item_anexo'] != null) {
      _queryinsert =
          "INSERT INTO sps_checklist_tb_resp_anexo (codigo_empresa, codigo_programacao, registro_colaborador, identificacao_utilizador, item_checklist, item_anexo, nome_arquivo, titulo_arquivo, usuresponsavel, dthratualizacao, dthranexo,sincronizado) VALUES (" +
              dadosArquivo['codigo_empresa'] +
              ", '" +
              dadosArquivo['codigo_programacao'].toString() +
              "', '" +
              dadosArquivo['registro_colaborador'].toString() +
              "' , '" +
              dadosArquivo['identificacao_utilizador'].toString() +
              "', " +
              dadosArquivo['item_checklist'].toString() +
              ", case when (SELECT item_anexo FROM sps_checklist_tb_resp_anexo where codigo_empresa = " +
              dadosArquivo['codigo_empresa'] +
              " and codigo_programacao = '" +
              dadosArquivo['codigo_programacao'].toString() +
              "' and item_checklist = " +
              dadosArquivo['item_checklist'].toString() +
              " and item_anexo = " +
              dadosArquivo['item_anexo'].toString() +
              ") is not null then (SELECT max(item_anexo) + 1 FROM sps_checklist_tb_resp_anexo where codigo_empresa = " +
              dadosArquivo['codigo_empresa'] +
              " and codigo_programacao = '" +
              dadosArquivo['codigo_programacao'].toString() +
              "' and item_checklist = " +
              dadosArquivo['item_checklist'].toString() +
              ") else " +
              dadosArquivo['item_anexo'].toString() +
              " end, '" +
              dadosArquivo['nome_arquivo'].toString() +
              "' , '', '" +
              dadosArquivo['usuresponsavel'].toString() +
              "', '" +
              dadosArquivo['dthratualizacao'].toString() +
              "', '" +
              dadosArquivo['dthranexo'].toString() +
              "','" +
              dadosArquivo['sincronizado'].toString() +
              "')";
    } else {
      _queryinsert =
          "INSERT INTO sps_checklist_tb_resp_anexo (codigo_empresa, codigo_programacao, registro_colaborador, identificacao_utilizador, item_checklist, item_anexo, nome_arquivo, titulo_arquivo, usuresponsavel, dthratualizacao, dthranexo,sincronizado) VALUES (" +
              dadosArquivo['codigo_empresa'] +
              ", '" +
              dadosArquivo['codigo_programacao'].toString() +
              "', '" +
              dadosArquivo['registro_colaborador'].toString() +
              "' , '" +
              dadosArquivo['identificacao_utilizador'].toString() +
              "', " +
              dadosArquivo['item_checklist'].toString() +
              ", case when (SELECT max(item_anexo) + 1 FROM sps_checklist_tb_resp_anexo where codigo_empresa = " +
              dadosArquivo['codigo_empresa'] +
              " and codigo_programacao = '" +
              dadosArquivo['codigo_programacao'].toString() +
              "' and item_checklist = " +
              dadosArquivo['item_checklist'].toString() +
              ") is null then 1 else (SELECT max(item_anexo) + 1 FROM sps_checklist_tb_resp_anexo where codigo_empresa = " +
              dadosArquivo['codigo_empresa'] +
              " and codigo_programacao = '" +
              dadosArquivo['codigo_programacao'].toString() +
              "' and item_checklist = " +
              dadosArquivo['item_checklist'].toString() +
              ") end , '" +
              dadosArquivo['nome_arquivo'].toString() +
              "' , '', '" +
              dadosArquivo['usuresponsavel'].toString() +
              "', '" +
              dadosArquivo['dthratualizacao'].toString() +
              "', '" +
              dadosArquivo['dthranexo'].toString() +
              "', '" +
              dadosArquivo['sincronizado'].toString() +
              "')";
    }
    //debugPrint("query inserir registro anexo local=> "+_queryinsert);
    final int result = await db.rawInsert(_queryinsert);
    return result;
  }

  Future<int> deletarQuestionarioMidia(
      {String codigo_empresa = "",
      int codigo_programacao = 0,
      int item_checklist = 0,
      int item_anexo = 0}) async {
    final Database db = await getDatabase();
    var _query =
        'update sps_checklist_tb_resp_anexo set sincronizado = "D" where codigo_empresa = "' +
            codigo_empresa +
            '" and codigo_programacao = ' +
            codigo_programacao.toString() +
            ' and item_checklist = ' +
            item_checklist.toString() +
            ' and item_anexo = ' +
            item_anexo.toString();
    //debugPrint("query deletar registro=> "+_query);
    final int result = await db.rawUpdate(_query);
    return result;
  }

  Future<int> updateTituloQuestionarioMidia(
      {String titulo_arquivo = "",
      String codigo_empresa = "",
      int codigo_programacao = 0,
      int item_checklist = 0,
      int item_anexo = 0}) async {
    final Database db = await getDatabase();
    var _query = 'update sps_checklist_tb_resp_anexo set titulo_arquivo = "' +
        titulo_arquivo +
        '", sincronizado = "M" where codigo_empresa = "' +
        codigo_empresa +
        '" and codigo_programacao = ' +
        codigo_programacao.toString() +
        ' and item_checklist = ' +
        item_checklist.toString() +
        ' and item_anexo = ' +
        item_anexo.toString();
    //debugPrint("query atualizar titulo do arquivo=> "+_query);
    final int result = await db.rawUpdate(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> select_sincronizacao() async {
    final Database db = await getDatabase();
    var _query =
        'SELECT * FROM sps_checklist_tb_resp_anexo where sincronizado = "N" OR sincronizado = "D" OR sincronizado = "M" OR sincronizado = "T"';
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> updateQuestionarioMidiaSincronizacao(
      _codigoEmpresa,
      _codigoProgramacao,
      _registroColaborador,
      _identificacaoUtilizador,
      _itemChecklist,
      _itemAnexo) async {
    final Database db = await getDatabase();
    var _query = 'update sps_checklist_tb_resp_anexo set sincronizado = "'
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
        ' and item_anexo = ' +
        _itemAnexo;
    //print(_query.toString());
    db.rawUpdate(_query);
    return 1;
  }

  Future<int> deleteQuestionarioMidiaSincronizacao(
      _codigoEmpresa,
      _codigoProgramacao,
      _registroColaborador,
      _identificacaoUtilizador,
      _itemChecklist,
      _itemAnexo) async {
    final Database db = await getDatabase();
    var _query =
        'delete from sps_checklist_tb_resp_anexo where codigo_empresa = "' +
            _codigoEmpresa +
            '" and codigo_programacao = ' +
            _codigoProgramacao.toString() +
            ' and registro_colaborador = "' +
            _registroColaborador +
            '" and identificacao_utilizador = "' +
            _identificacaoUtilizador +
            '" and item_checklist = ' +
            _itemChecklist.toString() +
            ' and item_anexo = ' +
            _itemAnexo;
    //print(_query.toString());
    db.rawUpdate(_query);
    return 1;
  }

  Future<List<Map<String, dynamic>>> listarArquivosOutros(
      codigo_empresa, codigo_programacao, item_checklist) async {
    final Database db = await getDatabase();
    var _query;
    final SpsDaoQuestionarioMidia objQuestionarioCqMidiaDao =
        SpsDaoQuestionarioMidia();
    _query = 'select * from sps_checklist_tb_resp_anexo where codigo_empresa = "' +
        codigo_empresa +
        '" and codigo_programacao = ' +
        codigo_programacao.toString() +
        ' and item_checklist = ' +
        item_checklist.toString() +
        ' and (sincronizado is null or sincronizado <> "D" or sincronizado = "null") and substr(nome_arquivo, -3,3) not in ("mp4","MP4","jpg","JPG", "png", "PNG", "gif", "GIF")';
    final List<Map<String, dynamic>> resultAnexos = await db.rawQuery(_query);
    return resultAnexos;
  }
}
