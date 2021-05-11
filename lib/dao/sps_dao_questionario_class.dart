import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sps/models/sps_usuario_class.dart';
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
      'dtvalidade_checklist DATE, '
      'dtfim_aplicacao DATE, '
      'percentual_evolucao_fornecedor FLOAT, '
      'percentual_evolucao FLOAT, '
      'status TEXT, '
      'referencia_parceiro TEXT, '
      'codigo_pedido TEXT, '
      'item_pedido TEXT, '
      'nome_fornecedor TEXT, '
      'qtde_pedido INTEGER, '
      'codigo_projeto TEXT, '
      'descr_projeto TEXT, '
      'codigo_material TEXT, '
      'descr_comentarios TEXT, '
      'doc_action TEXT, '
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
    //debugPrint('Tabela (checklist_lista) criada com sucesso ou já existente!');
  }

  Future<int> save(
      List<Map<String, dynamic>> dadosQuestionario, doc_action) async {
    final Database db = await getDatabase();
    await Future.forEach(dadosQuestionario, (questionario) async {
      //questionario['registro_colaborador'] = "";
      //questionario['identificacao_utilizador']  = "";

      if (questionario['registro_colaborador'] == null ||
          questionario['registro_colaborador'] == "") {
        questionario['registro_colaborador'] = "";
      }
      if (questionario['identificacao_utilizador'] == null ||
          questionario['identificacao_utilizador'] == "") {
        questionario['identificacao_utilizador'] = "";
      }
      if (questionario['descr_projeto'] == null ||
          questionario['descr_projeto'] == "") {
        questionario['descr_projeto'] = "";
      }
      if (questionario['descr_comentarios'] == null ||
          questionario['descr_comentarios'] == "") {
        questionario['descr_comentarios'] = "";
      }
      if (questionario['codigo_grupo'] == null ||
          questionario['codigo_grupo'] == "") {
        questionario['codigo_grupo'] = "";
      }
      if (questionario['descr_programacao'] == null ||
          questionario['descr_programacao'] == "") {
        questionario['descr_programacao'] = "";
      }
      if (questionario['percentual_evolucao_fornecedor'] == null ||
          questionario['percentual_evolucao_fornecedor'] == "") {
        questionario['percentual_evolucao_fornecedor'] = 0;
      }
      if (questionario['percentual_evolucao'] == null ||
          questionario['percentual_evolucao'] == "") {
        questionario['percentual_evolucao'] = 0;
      }
      if (questionario['descr_comentarios'] == null ||
          questionario['descr_comentarios'] == "") {
        questionario['descr_comentarios'] = "";
      }
      if (questionario['qtde_pedido'] == null ||
          questionario['qtde_pedido'] == "") {
        questionario['qtde_pedido'] = 0;
      }
      var _query2 = 'SELECT * FROM checklist_lista where codigo_empresa = "' +
          questionario['codigo_empresa'] +
          '" and codigo_programacao = ' +
          questionario['codigo_programacao'].toString() +
          ' and registro_colaborador = "' +
          questionario['registro_colaborador'] +
          '" and identificacao_utilizador = "' +
          questionario['identificacao_utilizador'] +
          '"';
//      print('Fernando==>'+_query2.toString());
      List<Map<String, dynamic>> result2 = await db.rawQuery(_query2);
      if (result2.length <= 0) {
        var _query = 'insert into checklist_lista values ("' +
            questionario['codigo_empresa'] +
            '",' +
            questionario['codigo_programacao'].toString() +
            ',"' +
            questionario['registro_colaborador'] +
            '","' +
            questionario['identificacao_utilizador'] +
            '","' +
            questionario['codigo_grupo'] +
            '",' +
            questionario['codigo_checklist'].toString() +
            ',"' +
            questionario['descr_programacao'] +
            '","' +
            questionario['dtvalidade_checklist'] +
            '","' +
            questionario['dtfim_aplicacao'] +
            '",' +
            questionario['percentual_evolucao_fornecedor'].toString() +
            ',' +
            questionario['percentual_evolucao'].toString() +
            ',"' +
            questionario['status'] +
            '","' +
            questionario['referencia_parceiro'] +
            '","' +
            questionario['codigo_pedido'] +
            '","' +
            questionario['item_pedido'] +
            '","' +
            questionario['nome_fornecedor'] +
            '",' +
            questionario['qtde_pedido'].toString() +
            ',"' +
            questionario['codigo_projeto'] +
            '","' +
            questionario['descr_projeto'] +
            '","' +
            questionario['codigo_material'] +
            '","' +
            questionario['descr_comentarios'] +
            '","' +
            doc_action +
            '",null)';
//        debugPrint("Query => " + _query);
        await db.rawInsert(_query);
      }
    });
    return 1;
  }

  Future<int> update_referencia(_hcodigoEmpresa, _hcodigoProgramacao,
      _hreferencia, _hsincronizado) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_lista set referencia_parceiro = "' +
        _hreferencia +
        '", sincronizado = "' +
        _hsincronizado +
        '" where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString();
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    //debugPrint("Alterado referencia (checklist_lista) => " + _hreferencia);
    return 1;
  }

  Future<int> update_lista_status_aprovacao(
      _hcodigoEmpresa, _hcodigoProgramacao) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_lista '
            'set status = case when (SELECT count(*) '
            '                         FROM checklist_item '
            '                         where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" '
            '                           AND CODIGO_PROGRAMACAO = ' +
        _hcodigoProgramacao.toString() +
        '                           AND status_aprovacao <> "APROVADO") = 0 then '
            '                 "OK" '
            '             else '
            '                 case when (SELECT count(*) '
            '                           FROM checklist_item '
            '                           where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" '
            '                           AND CODIGO_PROGRAMACAO = ' +
        _hcodigoProgramacao.toString() +
        '                           AND status_aprovacao <> "PENDENTE") <> 0 then '
            '                     "PARCIAL" '
            '                 else '
            '                     "PENDENTE" '
            '                 end	'
            '            end,	'
            ' sincronizado = "N" '
            ' where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString();
    //debugPrint("query => " + _query);
    db.rawUpdate(_query);
    return 1;
  }

  Future<int> update_lista_status_resposta(_hcodigoEmpresa, _hcodigoProgramacao,
      _hregistroColaborador, _hidentificacaoUtilizador) async {
    final Database db = await getDatabase();

    //_hregistroColaborador = "";
    //_hidentificacaoUtilizador = "";

    var _query = 'update checklist_lista '
            'set status = case when (SELECT count(*) '
            '                         FROM checklist_item '
            '                         where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" '
            '                           AND codigo_programacao = ' +
        _hcodigoProgramacao.toString() +
        //  '                           AND registro_colaborador = "' + _hregistroColaborador + '" '
        //  '                           AND identificacao_utilizador = "' + _hidentificacaoUtilizador + '" '
        '                           AND status_resposta <> "PREENCHIDA") = 0 then '
            '                 "OK" '
            '             else '
            '                 case when (SELECT count(*) '
            '                           FROM checklist_item '
            '                           where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" '
            '                           AND CODIGO_PROGRAMACAO = ' +
        _hcodigoProgramacao.toString() +
        //  '                           AND registro_colaborador = "' + _hregistroColaborador + '" '
        //  '                           AND identificacao_utilizador = "' + _hidentificacaoUtilizador + '" '
        '                           AND status_resposta <> "PENDENTE") <> 0 then '
            '                     "PARCIAL" '
            '                 else '
            '                     "PENDENTE" '
            '                 end	'
            '            end,	'
            ' sincronizado = "N" '
            ' where codigo_empresa = "' +
        _hcodigoEmpresa +
        '" and codigo_programacao = ' +
        _hcodigoProgramacao.toString();
    //+ ' and registro_colaborador = "' +
    //_hregistroColaborador +
    //'" and identificacao_utilizador = "' +
    //_hidentificacaoUtilizador + '"';
    //debugPrint("query update status resposta lista => " + _query);
    db.rawUpdate(_query);
    return 1;
  }

  Future<List<Map<String, dynamic>>> select_sincronizacao() async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_lista where sincronizado = "N"';
    //debugPrint("query => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> emptyTable(doc_action) async {
    final Database db = await getDatabase();
    return db.rawDelete(
        'delete from checklist_lista where (sincronizado is null or sincronizado = "null" or sincronizado = "") and doc_action = "' +
            doc_action +
            '"');
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioGeral(
      _filtro,
      _filtroProjeto,
      _filtroReferencia,
      _filtroPedido,
      _filtroDescrProgramacao,
      _origemUsuario,
      String doc_action,
      _filtroNomeFornecedor) async {
    final Database db = await getDatabase();
    var _query = 'SELECT * FROM checklist_lista a where 1 = 1 ';
    if (_filtro.toString() != "" && _filtro.toString() != "null") {
      if (_filtro == "OK S/FUP") {
        _query = _query +
            " and a.status = 'OK' and (select count(*) from checklist_item x where x.codigo_empresa = a.codigo_empresa and x.codigo_programacao = a.codigo_programacao and x.status_aprovacao <> 'APROVADO') <> 0 ";
      } else {
        if (_filtro == "OK C/FUP") {
          _query = _query +
              " and a.status = 'OK' and (select count(*) from checklist_item x where x.codigo_empresa = a.codigo_empresa and x.codigo_programacao = a.codigo_programacao and x.status_aprovacao <> 'APROVADO') = 0 ";
        } else {
          _query = _query + " and a.status = '" + _filtro.toString() + "'";
        }
      }
    }
    if (_filtroNomeFornecedor.toString() != "" &&
        _filtroNomeFornecedor.toString() != "null" &&
        _filtroNomeFornecedor != null) {
      _query = _query +
          " and a.nome_fornecedor = '" +
          _filtroNomeFornecedor.toString() +
          "' ";
    }
    if (_filtroProjeto.toString() != "" &&
        _filtroProjeto.toString() != "null") {
      _query = _query +
          " and a.codigo_projeto like '%" +
          _filtroProjeto.toString() +
          "%'";
    }
    if (_filtroReferencia.toString() != "" &&
        _filtroReferencia.toString() != "null") {
      _query = _query +
          " and a.referencia_parceiro like '%" +
          _filtroReferencia.toString() +
          "%'";
    }
    if (_filtroPedido.toString() != "" && _filtroPedido.toString() != "null") {
      _query = _query +
          " and a.codigo_pedido like '%" +
          _filtroPedido.toString() +
          "%'";
    }
    if (_filtroDescrProgramacao.toString() != "" &&
        _filtroDescrProgramacao.toString() != "null") {
      _query = _query +
          " and a.descr_programacao like '%" +
          _filtroDescrProgramacao.toString() +
          "%'";
    }
    _query = _query +
        ' and a.doc_action = "' +
        doc_action +
        '" ' +
        'order by a.dtfim_aplicacao';

    debugPrint("query listar item geral=> " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> listarQuestionarioFornecedor() async {
    final Database db = await getDatabase();
    var _query = 'SELECT 1, "TODOS OS FORNECEDORES" as nome_fornecedor, '
        '  (select count(*) from checklist_lista x1 where status = "PENDENTE" and x1.nome_fornecedor <> "") as qtde_pendente, '
        '  (select count(*) from checklist_lista x1 where status = "PARCIAL" and x1.nome_fornecedor <> "") as qtde_parcial, '
        '  (select count(*) from checklist_lista x1 where status = "OK" and x1.nome_fornecedor <> "") as qtde_ok '
        'UNION ALL '
        'SELECT distinct 2, a.nome_fornecedor, '
        '  (select count(*) from checklist_lista x1 where x1.nome_fornecedor = a.nome_fornecedor and status = "PENDENTE") as qtde_pendente, '
        '  (select count(*) from checklist_lista x1 where x1.nome_fornecedor = a.nome_fornecedor and status = "PARCIAL") as qtde_parcial, '
        '  (select count(*) from checklist_lista x1 where x1.nome_fornecedor = a.nome_fornecedor and status = "OK") as qtde_ok '
        'FROM checklist_lista a where a.nome_fornecedor <> "" '
        'order by 1, 2';

    debugPrint("query listar fornecedor => " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<List<Map<String, dynamic>>> contarQuestionarioGeral(
      String doc_action, String _filtroNomeFornecedor) async {
    final Database db = await getDatabase();
    //print ("adriano ======>"+_filtroNomeFornecedor.toString());
    var _query;
    if (doc_action == "PREENCHER_CQ" && usuarioAtual.tipo != "INTERNO") {
      _query =
          'SELECT case when a.status = "OK" then case when (select count(*) from checklist_item x where x.codigo_empresa = a.codigo_empresa and x.codigo_programacao = a.codigo_programacao and x.status_aprovacao <> "APROVADO") = 0 then "OK C/FUP" else "OK S/FUP" end else a.status end as status, count(*) as contador '
          'FROM checklist_lista a '
          'where a.doc_action = "PREENCHER_CQ" ';
      if (_filtroNomeFornecedor != "" && _filtroNomeFornecedor != null) {
        _query =
            _query + ' and nome_fornecedor = "' + _filtroNomeFornecedor + '" ';
      }
      _query = _query +
          ' group by case when a.status = "OK" then case when (select count(*) from checklist_item x where x.codigo_empresa = a.codigo_empresa and x.codigo_programacao = a.codigo_programacao and x.status_aprovacao <> "APROVADO") = 0 then "OK C/FUP" else "OK S/FUP" end else a.status end ';
    } else {
      _query =
          'SELECT status, count(*) as contador FROM checklist_lista where doc_action = "' +
              doc_action +
              '" ';
      if (_filtroNomeFornecedor != "" && _filtroNomeFornecedor != null) {
        _query =
            _query + ' and nome_fornecedor = "' + _filtroNomeFornecedor + '" ';
      }
      _query = _query + ' group by status';
    }

    print("query => contarQuestionarioGeral=> " + _query);
    final List<Map<String, dynamic>> result = await db.rawQuery(_query);
    return result;
  }

  Future<int> updateQuestionarioSincronizacao(
      _codigoEmpresa, _codigoProgramacao) async {
    final Database db = await getDatabase();
    var _query = 'update checklist_lista set sincronizado = "'
            '" where codigo_empresa = "' +
        _codigoEmpresa +
        '" and codigo_programacao = ' +
        _codigoProgramacao.toString();
    //print(_query.toString());
    db.rawUpdate(_query);
    return 1;
  }
}
