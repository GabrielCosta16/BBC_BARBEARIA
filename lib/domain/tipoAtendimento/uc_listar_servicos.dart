import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/tipoAtendimento/tipo_atendimento.dart';
import 'package:bbc/domain/uc_listar_objetos.dart';
import 'package:bbc/infra/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UcListarServicos extends UcListarObjetos<Servico> {
  UcListarServicos() : super(tabela: tabelaTipoAtendimento);

  @override
  Servico fromJson(Map<String, dynamic> json) {
    return Servico.fromJsonObject(json);
  }
}
