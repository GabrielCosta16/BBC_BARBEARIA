import 'package:bbc/infra/exts_json.dart';

class Servico {
  int id;
  String titulo;
  Map<String, String> listaAtendimentos;
  double valorAtendimento;
  double valorComissao;

  Servico(
      {required this.id,
      required this.titulo,
      required this.listaAtendimentos,
      required this.valorComissao,
      required this.valorAtendimento});

  @override
  String toString() {
    return "$titulo: ";
  }

  Servico.fromJsonObject(Map<String, dynamic> map)
      : id = map.asInt("id"),
        titulo = map.asString("titulo"),
        listaAtendimentos = (map['listaAtendimentos'] as Map<String, dynamic>?)
            ?.map((key, value) => MapEntry(key, value.toString())) ??
            {},
        valorComissao = map.asDouble("valorComissao"),
        valorAtendimento = map.asDouble("valorAtendimento");

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "valorComissao": valorComissao,
      "listaAtendimentos": listaAtendimentos,
      "valorAtendimento": valorAtendimento
    };
  }
}
