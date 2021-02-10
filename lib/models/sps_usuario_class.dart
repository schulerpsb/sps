class sps_usuario {
  static final sps_usuario _sps_usuario = new sps_usuario._internal();//  String codigo_usuario;

  String codigo_usuario;
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

  factory sps_usuario() {
    return _sps_usuario;
  }
  sps_usuario._internal();
}
final usuarioAtual = sps_usuario();

//class sps_usuario {
//
//  String codigo_usuario;
//  String nome_usuario;
//  String telefone_usuario;
//  String email_usuario;
//  String cargo_usuario;
//  String pais_usuario;
//  String lingua_usuario;
//  String senha_usuario;
//  String status_usuario;
//  String dt_validade_senha;
//  String qtd_tentativas_senha;
//  String codigo_planta;
//  String dthratualizacao;
//  String chave;
//  String status_token;
//  String dt_validade_usuario;
//  String dt_reset_senha;
//  String tipo;
//  String registro_usuario;
//  String mensagem;
//
//  sps_usuario({
//    this.codigo_usuario,
//    this.nome_usuario,
//    this.telefone_usuario,
//    this.email_usuario,
//    this.cargo_usuario,
//    this.pais_usuario,
//    this.lingua_usuario,
//    this.senha_usuario,
//    this.status_usuario,
//    this.dt_validade_senha,
//    this.qtd_tentativas_senha,
//    this.codigo_planta,
//    this.dthratualizacao,
//    this.chave,
//    this.status_token,
//    this.dt_validade_usuario,
//    this.dt_reset_senha,
//    this.tipo,
//    this.registro_usuario,
//    this.mensagem
//  });
//}