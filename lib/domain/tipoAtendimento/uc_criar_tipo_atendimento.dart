import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/tipoAtendimento/tipo_atendimento.dart';
import 'package:bbc/domain/uc_listar_objetos.dart';
import 'package:bbc/domain/uc_registrar.dart';
import 'package:bbc/infra/consts.dart';
import 'package:firebase_database/firebase_database.dart';

class UcCriarTipoAtendimento extends UcRegistrar<Servico> {
  Map<String, dynamic> novoTipoAtendimento;

  UcCriarTipoAtendimento({required this.novoTipoAtendimento})
      : super(tabela: tabelaTipoAtendimento, mapObjeto: novoTipoAtendimento);
}
