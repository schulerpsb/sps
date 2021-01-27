import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SpsDaoQuestionarioItem {
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS checklist_item('
      'codigo_empresa TEXT, '
      'codigo_programacao INTEGER, '
      'registro_colaborador TEXT, '
      'identificacao_utilizador TEXT, '
      'item_checklist INTEGER, '
      'codigo_grupo TEXT, '
      'codigo_checklist TEXT, '
      'seq_pergunta INTEGER, '
      'descr_pergunta TEXT, '
      'resp_cq TEXT, '
      'descr_comentarios TEXT, '
      'status_resposta TEXT, '
      'status_aprovacao TEXT, '
      'sincronizado TEXT, '
      'PRIMARY KEY (codigo_empresa, codigo_programacao, '
      '             registro_colaborador, identificacao_utilizador, item_checklist))';

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'sps.db');
    //debugPrint('path: $path');
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

  Future<int> update_opcao(_hcodigoEmpresa, _hcodigoProgramacao, _hregistroColaborador, _hidentificacaoUtilizador, _hitemChecklist, _hrespCq) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set resp_cq = "'+_hrespCq+'", sincronizado = "N" where codigo_empresa = "'+_hcodigoEmpresa+'" and codigo_programacao = '+_hcodigoProgramacao.toString()+' and registro_colaborador = "'+_hregistroColaborador +'" and identificacao_utilizador = "'+_hidentificacaoUtilizador+'" and item_checklist = '+_hitemChecklist.toString();
    debugPrint("query => "+_query);
    db.rawUpdate(_query);
    debugPrint("Alterado referencia (checklist_item) => "+_hrespCq);
    return null;
  }

  Future<int> update_comentarios(_hcodigoEmpresa, _hcodigoProgramacao, _hitemChecklist, _hdescrComentarios) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_item set descr_comentarios = "'+_hdescrComentarios+'", sincronizado = "N" where codigo_empresa = "'+_hcodigoEmpresa+'" and codigo_programacao = '+_hcodigoProgramacao.toString()+' and item_checklist = '+_hitemChecklist.toString();
    debugPrint("query => "+_query);
    db.rawUpdate(_query);
    debugPrint("Alterado comentários (checklist_item) => "+_hdescrComentarios);
    return null;
  }

  Future<int> emptyTable(_hcodigoEmpresa, _hcodigoProgramacao) async {
    final Database db = await getDatabase();
    return db.rawDelete('delete from checklist_item where codigo_empresa = '+_hcodigoEmpresa+' and codigo_programacao = '+_hcodigoProgramacao.toString());
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioItemLocal() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('checklist_item');
    debugPrint('==>' + result.toString());
    return result;
  }
}
