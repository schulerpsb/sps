import 'package:flutter/material.dart';
import 'package:sps/dao/sps_dao_login_class.dart';
import 'package:sps/dao/sps_dao_sincronizacao_class.dart';
import 'package:sps/http/sps_http_login_class.dart';
import 'package:sps/http/sps_http_verificar_conexao_class.dart';
import 'package:sps/models/sps_usuario_class.dart';

class SpsLogin {

  @override
  Future<List<Map<String, dynamic>>> efetuaLogin(
      TextEditingController controladorusuario,
      TextEditingController controladorsenha) async {
    final usuario = controladorusuario.text;
    final senha = controladorsenha.text;

    final SpsHttpLogin objLoginHttp = SpsHttpLogin(usuario, senha);
    debugPrint("Usuario"+usuario.toString()+" Senha: "+senha.toString());
    final Map<String, dynamic> dadosUsuario = await objLoginHttp.efetuaLogin(
        usuario, senha);
    if (dadosUsuario['mensagem'] == "") {
      dadosUsuario.remove('mensagem');
      final SpsDaoLogin objLoginDao = SpsDaoLogin();
      final int resulcreate = await objLoginDao.create_table();
      final int resullimpar = await objLoginDao.emptyTable(dadosUsuario);
      final int resultsave = await objLoginDao.save(dadosUsuario);
      final List<Map<String, dynamic>> DadosSessao = await objLoginDao
          .listaUsuarioLocal();
      if (DadosSessao != null) {
        //debugPrint(DadosSessao.toString());
        return DadosSessao;
      } else {
        return DadosSessao;
      }
    }else{
      final List<Map<String, dynamic>> DadosSessao = [{'mensagem': dadosUsuario['mensagem'].trim()}];
      //debugPrint(DadosSessao.toString());
      return DadosSessao;
    };

  }

  Future<List<Map<String, dynamic>>> verificaUsuarioAutenticado() async {
      print("VERIFICAÇÃO DE USUÁRIO LOCAL INICIADA ========>");
      final SpsDaoLogin objLoginDao = SpsDaoLogin();
      final int resulcreate = await objLoginDao.create_table();
      final List<Map<String, dynamic>> DadosSessao = await objLoginDao
          .listaUsuarioLocal();
      print("Dados Sessao"+DadosSessao.length.toString());
      if (DadosSessao != null && DadosSessao.length > 0) {
        //verifica se esta conectado
        final SpsVerificarConexao ObjVerificarConexao = SpsVerificarConexao();
        final bool conectado = await ObjVerificarConexao.verificar_conexao();
        if (conectado == true) {
          print("O CELULAR ESTA CONECTADO AO SERVIDOR - ONLINE ========>");
          //Verifica status sincronizacao
          SpsDaoSincronizacao objSpsDaoSincronizacao = SpsDaoSincronizacao();
          objSpsDaoSincronizacao.listaDadosSincronizacao().then((dadosSincronizacao){
             usuarioAtual.id_isolate = dadosSincronizacao[0]['id_isolate'];
             usuarioAtual.data_ultima_sincronizacao = dadosSincronizacao[0]['data_ultima_sincronizacao'].toString();
             usuarioAtual.status_sincronizacao = dadosSincronizacao[0]['status'];
          });
          //Verifica os dados do usuaario no servior
          final SpsHttpLogin objLoginHttp = SpsHttpLogin(DadosSessao[0]['codigo_usuario'], DadosSessao[0]['senha_usuario']);
          final Map<String, dynamic> dadosUsuario = await objLoginHttp.listaUsuariofromserver(
              DadosSessao[0]['codigo_usuario']);
          //Se o usuario do servidor estiver ativo atualiza os dados do local (SQLITE) e segue
          if (dadosUsuario['mensagem'] == "") {
            print("ATUALIZANDO DADOS SQLITE ========>");
            dadosUsuario.remove('mensagem');
            final int resullimpar = await objLoginDao.emptyTable(dadosUsuario);
            final int resultsave = await objLoginDao.save(dadosUsuario);
            final List<Map<String, dynamic>> DadosSessao = await objLoginDao
                .listaUsuarioLocal();
            if (DadosSessao != null && DadosSessao.length > 0) {
              usuarioAtual.mensagem = 'permitir_trocar';
              return DadosSessao;
            } else {
              usuarioAtual.mensagem = 'permitir_trocar';
              return DadosSessao;
            }
          }else{
            print("USUARIO NAO MAIS ATIVO, LIMPA SQLITE E PEDE LOGON ========>");
            //Se o usuario do servidor não mAias existir ou não estiver mais ativo é negado o logon e pedido um novo usuário.
            final int resullimpar = await objLoginDao.emptyTable(dadosUsuario);
            DadosSessao[0] = dadosUsuario;
            return DadosSessao;
          }
        }else{
          print("O CELULAR NÃO ESTA CONECTADO AO SERVIDOR - OFFLINE SEGUINDO COM DADOS DE LOGON DO SQLITE ========>");
          usuarioAtual.mensagem = 'nao_permitir_trocar';
          return DadosSessao;
        }
      } else {
        print("O CELULAR NÃO TEM DADOS DE LOGON DO SQLITE - SEGUIR PARA O LOGON========>");
        return DadosSessao;
      }
  }

  Future<List<Map<String, dynamic>>> logoutUser() async {
      final SpsDaoLogin objLoginDao = SpsDaoLogin();
      final int resullimpar = await objLoginDao.deleteLocalUser();
  }

  Future<Map<String, dynamic>> esqueciMinhaSenha(
      String usuario,
) async {

    final SpsHttpLogin objLoginHttp = SpsHttpLogin(usuario,'');
    final Map<String, dynamic> dadosUsuario = await objLoginHttp.esqueciMinhaSenha(usuario);
    return dadosUsuario;
  }


}