import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/uc_listar_objetos.dart';
import 'package:bbc/infra/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UcListarAtendimentos extends UcListarObjetos<Atendimento> {
  UcListarAtendimentos()
      : super(tabela: tabelaAtendimento);

  @override
  Atendimento fromJson(Map<String, dynamic> json) {
    return Atendimento.fromJsonObject(json);
  }
}
