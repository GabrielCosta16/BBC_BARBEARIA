import 'package:bbc/infra/exts_json.dart';

class Colaborador {
  String nome;
  int id;
  Map<String, String> listaAtendimentos;

  Colaborador({
    required this.id,
    required this.nome,
    required this.listaAtendimentos,
  });

  Colaborador.fromJsonObject(Map<String, dynamic> map)
      : id = map.asInt("id"),
        nome = map.asString("nome"),
        listaAtendimentos = (map['listaAtendimentos'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toString()));

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "listaAtendimentos": listaAtendimentos,
    };
  }
}
