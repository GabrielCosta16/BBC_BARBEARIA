import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/uc_listar_objetos.dart';
import 'package:bbc/domain/uc_registrar.dart';
import 'package:bbc/infra/consts.dart';
import 'package:firebase_database/firebase_database.dart';

class UcCriarAtendimento extends UcRegistrar<Atendimento> {
  Map<String, dynamic> novoAtendimento;

  UcCriarAtendimento({required this.novoAtendimento})
      : super(tabela: tabelaAtendimento, mapObjeto: novoAtendimento);
}
