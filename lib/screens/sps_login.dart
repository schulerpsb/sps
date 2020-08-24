import 'package:flutter/material.dart';
import 'package:sps/screens/sps_home.dart';

class Sps_login extends StatefulWidget {

  @override
  _Sps_loginState createState() => _Sps_loginState();
}

class _Sps_loginState extends State<Sps_login> {

  final _controladorusuario = TextEditingController();
  final _controladorsenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'images/logo_sps.png',
            fit: BoxFit.contain,
            height: 32,
          ),
          Icon(Icons.person),
        ],
      )),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controladorusuario,
                style: TextStyle(
                  fontSize: 24.8,
                ),
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Usuário',
                  hintText: 'Digite o Usuário',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controladorsenha,
                style: TextStyle(
                  fontSize: 24.8,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: 'Senha',
                  hintText: 'Digite a senha',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Builder(builder: (context) {
              return RaisedButton(
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 24.8,
                  ),
                ),
                onPressed: () {
                  _efetuaLogin(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _efetuaLogin(BuildContext context) {

    final usuario = _controladorusuario.text;
    final senha = _controladorsenha.text;

    if (usuario != null && senha != null) {
      final SessaoAtual = DadosSessao(usuario, senha);
      debugPrint('$SessaoAtual');
      Navigator.push(context,MaterialPageRoute(
        builder: (context) {
          return homeSps();
        },
      ),
      );
      //Navigator.pop(context, trasferenciaCriada);
    } else {
      final snackBar = SnackBar(
        content: Text('Valores inválidos!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}

class DadosSessao {
  final String usuario;
  final String senha;

  DadosSessao(this.usuario, this.senha);

  @override
  String toString() {
    return 'Dados Sessão: {usuario: $usuario, senha: $senha}';
  }
}
