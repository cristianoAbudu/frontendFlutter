
class Colaborador {
  final int id;
  final String nome;
  final String senha;
  final Colaborador? chefe;


  const Colaborador({required this.id, required this.nome, required this.senha, this.chefe});

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    Colaborador? chefe;
    if(json['chefe']!=null){
      chefe = Colaborador.fromJson(json['chefe']);
    }
  
    return Colaborador(
      id : json['id'],
      nome: json['nome'],
      senha: json['senha'],
      chefe: chefe
    );
  }
}