class sps_usuario {
  String _name;
  String _codigo_usuario;
  String nome_usuario;
  String telefone_usuario;
  String email_usuario;
  String cargo_usuario;
  String pais_usuario;
  String lingua_usuario;
  String senha_usuario;
  String status_usuario;
  String dt_validade_senha;
  String qtd_tentativas_senha;
  String codigo_planta;
  String dthratualizacao;
  String chave;
  String status_token;
  String dt_validade_usuario;
  String dt_reset_senha;
  String tipo;
  String registro_usuario;
  String mensagem;

  String get name => _name;

  set name(String name) {
    _name = name;
  }

}