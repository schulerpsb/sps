import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_login_class.dart';
import 'package:sps/http/sps_http_login_class.dart';

class SpsLogin {

  @override
  Future<List<Map<String, dynamic>>> efetuaLogin(
      TextEditingController controladorusuario,
      TextEditingController controladorsenha) async {
    final usuario = controladorusuario.text;
    final senha = controladorsenha.text;

    final SpsHttpLogin objLoginHttp = SpsHttpLogin(usuario, senha);
    final Map<String, dynamic> dadosUsuario = await objLoginHttp.efetuaLogin(
        usuario, senha);
    if (dadosUsuario != null) {
      final SpsDaoLogin objLoginDao = SpsDaoLogin();
      final int resulcreate = await objLoginDao.create_table();
      final int resullimpar = await objLoginDao.emptyTable(dadosUsuario);
      final int resultsave = await objLoginDao.save(dadosUsuario);
      final List<Map<String, dynamic>> DadosSessao = await objLoginDao
          .listaUsuarioLocal();
      if (DadosSessao != null) {
        return DadosSessao;
      } else {
        return DadosSessao;
      }
    };
  }
}