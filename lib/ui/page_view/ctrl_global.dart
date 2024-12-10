import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/atendimento/uc_listar_atendimentos.dart';
import 'package:bbc/domain/atendimento/uc_registrar_atendimento.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/colaborador/uc_listar_colaboradores.dart';
import 'package:bbc/domain/tipoAtendimento/tipo_atendimento.dart';
import 'package:bbc/domain/colaborador/uc_criar_colaborador.dart';
import 'package:bbc/domain/tipoAtendimento/uc_criar_tipo_atendimento.dart';
import 'package:bbc/domain/tipoAtendimento/uc_listar_servicos.dart';
import 'package:bbc/domain/uc_registrar.dart';
import 'package:bbc/infra/consts.dart';
import 'package:bbc/infra/exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CtrlGlobal {
  RxList<Colaborador> listaColaboradores = <Colaborador>[].obs;
  RxList<Servico> listaServicos = <Servico>[].obs;
  RxList<Atendimento> listaAtendimentos = <Atendimento>[].obs;
  TextEditingController tecNomeColaborador = TextEditingController();
  TextEditingController tecNomeTipoAtendimento = TextEditingController();
  TextEditingController tecComissaoAtendimento = TextEditingController();
  TextEditingController tecValorAtendimento = TextEditingController();
  FocusNode focoNomeColaborador = FocusNode();
  FocusNode focoNomeTipoAtendimento = FocusNode();
  bool temConexaoInternet = true;

  void inicializar() async {
    try {
      listaColaboradores.value = await listarColaboradores();
      listaServicos.value = await listarServicos();
      listaAtendimentos.value = await obterListaAtualizadaDoDia();
      if (listaAtendimentos.length > 1) {
        listaAtendimentos.sort((a, b) => -a.id.compareTo(b.id));
      }
    } catch (e) {
      Exception(e);
    }
  }

  bool todosCamposServicosPreenchidos() {
    if (tecNomeTipoAtendimento.text.isEmpty) {
      return false;
    }
    if (tecValorAtendimento.text.isEmpty) {
      return false;
    }
    if (tecComissaoAtendimento.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> atualizarListas() async {
    try {
      listaColaboradores.value = await listarColaboradores();
      listaServicos.value = await listarServicos();
      listaAtendimentos.value = await obterListaAtualizadaDoDia();
      if (listaAtendimentos.length > 1) {
        listaAtendimentos.sort((a, b) => -a.id.compareTo(b.id));
      }
    } catch (e) {
      Exception(e);
    }
  }

  Future<void> addAtendimento(int idColaborador, int idTipoAtendimento) async {
    try {
      String idAtendimento = await obterUltimoId(tabelaAtendimento, agrupador);

      final atendimento = Atendimento(
        idColaborador: idColaborador,
        dataHoraAtendimento: DateTime.now().toString(),
        idTipoAtendimento: idTipoAtendimento,
        id: int.parse(idAtendimento) + 1,
      );

      await UcCriarAtendimento(
        novoAtendimento: atendimento.toMap(),
      ).registrar();

      FirebaseFirestore banco = FirebaseFirestore.instance;

      await ajustaServicoNovoAtendimento(banco, atendimento);
      await ajustarColaboradorNovoAtendimento(banco, atendimento);

      await atualizarListas();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> ajustarColaboradorNovoAtendimento(
      FirebaseFirestore banco, Atendimento atendimento) async {
    Colaborador? colaborador =
        await obterColaboradorById(atendimento.idColaborador.toString());

    DocumentReference colaboradorBanco = banco
        .collection(tabelaColaborador)
        .doc(atendimento.idColaborador.toString());

    if (colaborador != null) {
      colaborador.listaAtendimentos[atendimento.id.toString()] =
          atendimento.dataHoraAtendimento;

      try {
        await colaboradorBanco.update({
          'listaAtendimentos': colaborador.listaAtendimentos,
        });
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable') {
          print('Operação offline salva no cache.');
          Fluttertoast.showToast(
              msg:
                  "Sua conexão está instável, o atendimento será anotado assim que sua conexão se reestabelecer- ${e.toString()}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: vermelho,
              textColor: branco,
              fontSize: 16.0);
        } else {
          rethrow;
        }
      }
    }
  }

  Future<void> ajustaServicoNovoAtendimento(
      FirebaseFirestore banco, Atendimento atendimento) async {
    DocumentReference tipoAtendimentoOriginal = banco
        .collection(tabelaTipoAtendimento)
        .doc(atendimento.idTipoAtendimento.toString());

    try {
      DocumentSnapshot servicoBanco = await tipoAtendimentoOriginal.get();
      if (servicoBanco.exists) {
        final tipoAtendimento =
            Servico.fromJsonObject(servicoBanco.data() as Map<String, dynamic>);
        tipoAtendimento.listaAtendimentos[atendimento.id.toString()] =
            atendimento.dataHoraAtendimento;

        await tipoAtendimentoOriginal.update({
          'listaAtendimentos': tipoAtendimento.listaAtendimentos,
        });
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        Fluttertoast.showToast(
            msg:
                "Sua conexão está instável, o atendimento será anotado assim que sua conexão se reestabelecer- ${e.toString()}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: vermelho,
            textColor: branco,
            fontSize: 16.0);
      } else {
        rethrow;
      }
    }
  }

  Future<String> obterUltimoId(String tabela, String agrupador) async {
    String ultimoIdString = '';
    FirebaseFirestore banco = FirebaseFirestore.instance;
    DocumentReference ultimoIdBanco = banco.collection(agrupador).doc(tabela);

    DocumentSnapshot ultimoId = await ultimoIdBanco.get();

    if (ultimoId.exists) {
      final map = ultimoId.data() as Map<String, dynamic>;
      ultimoIdString = map["ultimoId"].toString();
    }
    return ultimoIdString;
  }

  Future<Colaborador?> obterColaboradorById(String id) async {
    FirebaseFirestore banco = FirebaseFirestore.instance;

    DocumentReference colaborador = banco.collection(tabelaColaborador).doc(id);

    DocumentSnapshot colaboradorBanco = await colaborador.get();
    Colaborador? colaboradorAtualizado;
    if (colaboradorBanco.exists) {
      colaboradorAtualizado = Colaborador.fromJsonObject(
          colaboradorBanco.data() as Map<String, dynamic>);
    }
    return colaboradorAtualizado;
  }

  Future<List<Atendimento>> listarAtendimentos() async {
    try {
      return UcListarAtendimentos().listar();
    } catch (e) {
      Exception(e);
      return [];
    }
  }

  Future<List<Atendimento>> obterListaAtualizadaDoDia() async {
    List<Atendimento> lista = await listarAtendimentos();
    DateTime agora = DateTime.now();
    DateTime inicioDoDia = DateTime(agora.year, agora.month, agora.day);

    List<Atendimento> listaAtualizada = lista.where((atendimento) {
      DateTime dataAtendimento =
          DateTime.parse(atendimento.dataHoraAtendimento);

      return dataAtendimento.isAfter(inicioDoDia) ||
          dataAtendimento.isAtSameMomentAs(inicioDoDia);
    }).toList();

    return listaAtualizada;
  }

  Future<List<Colaborador>> listarColaboradores() async {
    try {
      return UcListarColaboradores().listar();
    } catch (e) {
      Exception(e);
      return [];
    }
  }

  Future<List<Servico>> listarServicos() async {
    try {
      return UcListarServicos().listar();
    } catch (e) {
      Exception(e);
      return [];
    }
  }

  Future<void> addColaborador() async {
    try {
      final colaborador = Colaborador(
        id: 99,
        nome: tecNomeColaborador.text,
        listaAtendimentos: {},
      );
      await UcCriarColaborador(novoColaborador: colaborador.toMap())
          .registrar();
    } catch (e) {
      Exception(e);
    }
    tecNomeColaborador.clear();
    await atualizarListas();
  }

  Future<void> addTipoAtendimento() async {
    final tipoAtendiento = Servico(
        id: 99,
        titulo: tecNomeTipoAtendimento.text,
        valorComissao:
            double.parse(tecComissaoAtendimento.text.replaceAll(",", ".")),
        listaAtendimentos: {},
        valorAtendimento:
            double.parse(tecValorAtendimento.text.replaceAll(",", ".")));
    await UcCriarTipoAtendimento(novoTipoAtendimento: tipoAtendiento.toMap())
        .registrar();
    tecNomeTipoAtendimento.clear();
    tecComissaoAtendimento.clear();
    tecValorAtendimento.clear();
    await atualizarListas();
  }


  Future<void> atualizarTela() async {
    await atualizarListas();
  }
}
