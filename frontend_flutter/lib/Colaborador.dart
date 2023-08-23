
class Colaborador {
  final int id;
  final String nome;
  final String senha;
  final Colaborador? chefe;


  const Colaborador({required this.id, required this.nome, required this.senha, this.chefe});

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    return Colaborador(
      id : json['id'],
      nome: json['nome'],
      senha: json['senha'],
      chefe: json['chefe']
    );
  }
}