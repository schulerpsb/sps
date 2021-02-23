import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionarioMidia {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS sps_checklist_tb_resp_anexo('
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
        debugPrint('DB Criado com sucesso!');
      },
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<int> create_table() async {
    final Database db = await getDatabase();
    db.execute(SpsDaoQuestionarioMidia.tableSql);
    debugPrint('Tabela (sps_checklist_tb_resp_anexo) criada com sucesso ou já existente!');
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

  Future<int> emptyTable() async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from checklist_lista');
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioMidia({String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0}) async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM sps_checklist_tb_resp_anexo where codigo_empresa = "'+codigo_empresa+'" and codigo_programacao = '+codigo_programacao.toString()+' and item_checklist = '+item_checklist.toString()+' order by item_anexo desc';
    debugPrint("query sss=> "+_query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> InserirQuestionarioMidia({Map<String, dynamic> dadosArquivo}) async {
    final Database db = await getDatabase();
    var _queryinsert = "INSERT INTO sps_checklist_tb_resp_anexo (codigo_empresa, codigo_programacao, registro_colaborador, identificacao_utilizador, item_checklist, item_anexo, nome_arquivo, titulo_arquivo, usuresponsavel, dthratualizacao, dthranexo,sincronizado) VALUES ("+dadosArquivo['codigo_empresa']+", '"+dadosArquivo['codigo_programacao'].toString()+"', '"+dadosArquivo['registro_colaborador'].toString()+"' , '"+dadosArquivo['identificacao_utilizador'].toString()+"', "+dadosArquivo['item_checklist'].toString()+", "+dadosArquivo['item_anexo'].toString()+", '"+dadosArquivo['nome_arquivo'].toString()+"' , '', '"+dadosArquivo['usuresponsavel'].toString()+"', '"+dadosArquivo['dthratualizacao'].toString()+"', '"+dadosArquivo['dthranexo'].toString()+"', 'N')";
    debugPrint("query inserir registro=> "+_queryinsert);
    final int result = await db.rawInsert(_queryinsert);
    return result;
  }


  Future<int> deletarQuestionarioMidia({String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0, int item_anexo = 0}) async {
    final Database db = await getDatabase();
    var _query = 'Delete FROM sps_checklist_tb_resp_anexo where codigo_empresa = "'+codigo_empresa+'" and codigo_programacao = '+codigo_programacao.toString()+' and item_checklist = '+item_checklist.toString()+' and item_anexo = '+item_anexo.toString();
    debugPrint("query deletar registro=> "+_query);
    final int result = await db.rawDelete(_query);
    return result;

  }

  Future<int> updateTituloQuestionarioMidia({String titulo_arquivo = "", String codigo_empresa = "", int codigo_programacao = 0, int item_checklist = 0, int item_anexo = 0}) async {
    final Database db = await getDatabase();
    var _query = 'update sps_checklist_tb_resp_anexo set titulo_arquivo = "'+titulo_arquivo+'", sincronizado = "N" where codigo_empresa = "'+codigo_empresa+'" and codigo_programacao = '+codigo_programacao.toString()+' and item_checklist = '+item_checklist.toString()+' and item_anexo = '+item_anexo.toString();
    debugPrint("query atualizar titulo do arquivo=> "+_query);
    final int result = await db.rawUpdate(_query);
    return result;

  }

}
