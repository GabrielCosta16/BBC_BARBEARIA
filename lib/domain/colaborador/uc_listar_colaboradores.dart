import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/uc_listar_objetos.dart';
import 'package:bbc/infra/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UcListarColaboradores extends UcListarObjetos<Colaborador> {
  UcListarColaboradores()
      : super(tabela: tabelaColaborador);

  @override
  Colaborador fromJson(Map<String, dynamic> json) {
    return Colaborador.fromJsonObject(json);
  }
}
