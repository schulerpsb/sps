class sps_erro_conexao {
  static final sps_erro_conexao _sps_erro_conexao = new sps_erro_conexao._internal();//  String codigo_usuario;

  String msg_erro_conexao;

  factory sps_erro_conexao() {
    return _sps_erro_conexao;
  }
  sps_erro_conexao._internal();
}
final erroConexao = sps_erro_conexao();