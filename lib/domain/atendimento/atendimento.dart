import 'dart:convert';

import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/infra/exts_json.dart';
import 'package:intl/intl.dart';

class Atendimento {
  int id;
  int idColaborador;
  int idTipoAtendimento;
  String dataHoraAtendimento;

  Atendimento(
      {required this.idColaborador,
      required this.dataHoraAtendimento,
      required this.idTipoAtendimento,
      required this.id});

  String obterAtendimentoRelatorio(String nomeBarbeiro, String servico) {
    DateTime horaAtendimento = DateTime.parse(dataHoraAtendimento);
    String horaFormatada = DateFormat("dd/MM - HH:mm ").format(horaAtendimento);
    return "$nomeBarbeiro - $servico - $horaFormatada";
  }


  static List<Atendimento> fromJson(String jsonBody) {
    List<Atendimento> lista = [];

    var jsonPronto = jsonDecode(jsonBody);

    for (var jsonAtendimento in jsonPronto) {
      try {
        lista.add(Atendimento.fromJsonObject(jsonAtendimento));
      } catch (e) {
        throw e.toString() + jsonEncode(jsonAtendimento);
      }
    }

    return lista;
  }

  Atendimento.fromJsonObject(Map<String, dynamic> map)
      : id = map.asInt("id"),
        idColaborador = map.asInt("idColaborador"),
        idTipoAtendimento = map.asInt("idTipoAtendimento"),
        dataHoraAtendimento = map.asString("dataHoraAtendimento");

  Map<String, dynamic> toMap() {
    return {
      "idColaborador": idColaborador,
      "dataHoraAtendimento": dataHoraAtendimento,
      "id": id,
      "idTipoAtendimento": idTipoAtendimento
    };
  }
}
