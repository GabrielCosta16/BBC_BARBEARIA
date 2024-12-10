import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/core/policies/policy_gerar_pdf_relatorio.dart';
import 'package:bbc/domain/tipoAtendimento/tipo_atendimento.dart';
import 'package:bbc/infra/consts.dart';
import 'package:bbc/ui/page_view/ctrl_global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CtrlRelatorio extends CtrlGlobal {
  List<Atendimento> listaAtendimentoPeriodo = [];
  List<String> listaColaboradoresRelatorio = [];
  List<Colaborador> listaColaboradorSelecionado = [];
  RxString colaboradorSelecionado = ''.obs;
  RxString periodoInicial = ''.obs;
  DateTime dataInicial = DateTime.now().add(Duration(days: -6));
  DateTime dataFinal = DateTime.now();
  RxBool isPeriodoUm = false.obs;
  RxBool isPeriodoDois = false.obs;
  RxBool isPeriodoTres = false.obs;
  RxBool isPeriodoQuatro = false.obs;
  RxBool isPeriodoCinco = false.obs;
  RxDouble totalComissao = 0.0.obs;
  RxBool isPeriodoPersonalizadoSelecionado = false.obs;
  DateTime ultimosSeteDias = DateTime.now().add(
    Duration(days: -6),
  );
  DateTime ultimosQuatorzeDias = DateTime.now().add(
    Duration(days: -13),
  );
  DateTime ultimosTrintaDias = DateTime.now().add(
    Duration(days: -30),
  );
  DateTime ontem = DateTime.now().add(
    Duration(days: -1),
  );
  DateTime hoje = DateTime.now().add(Duration(seconds: 1));

  RxString periodoFinal = ''.obs;

  Future<void> selecionarHoje() async {
    try {
      listaAtendimentoPeriodo.clear();
      isPeriodoUm.value = false;
      isPeriodoDois.value = false;
      isPeriodoTres.value = false;
      isPeriodoQuatro.value = true;
      isPeriodoCinco.value = false;
      final hojeInicial =
          DateTime(hoje.year, hoje.month, hoje.day, 00, 00, 00, 00, 00);
      final hojeFinal =
          DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59, 00, 00);
      dataInicial = hojeInicial;
      dataFinal = hojeFinal;
      periodoFinal.value = DateFormat('dd/MM/yyyy').format(dataFinal);
      periodoInicial.value = DateFormat('dd/MM/yyyy').format(dataInicial);
      if (colaboradorSelecionado.isNotEmpty) {
        listaAtendimentoPeriodo = await obterAtendimentoPeriodo(
            dataInicial, dataFinal, colaboradorSelecionado.value);
        await calcularComissao();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  Future<void> selecionarOntem() async {
    try {
      listaAtendimentoPeriodo.clear();
      isPeriodoUm.value = false;
      isPeriodoDois.value = false;
      isPeriodoTres.value = false;
      isPeriodoQuatro.value = false;
      isPeriodoCinco.value = true;

      final ontemInicial =
          DateTime(ontem.year, ontem.month, ontem.day, 00, 00, 00, 00, 00);
      final ontemFinal =
          DateTime(ontem.year, ontem.month, ontem.day, 23, 59, 59, 00, 00);
      dataFinal = ontemFinal;
      dataInicial = ontemInicial;
      periodoFinal.value = DateFormat('dd/MM/yyyy').format(ontemFinal);

      periodoInicial.value = DateFormat('dd/MM/yyyy').format(ontemInicial);
      if (colaboradorSelecionado.isNotEmpty) {
        listaAtendimentoPeriodo = await obterAtendimentoPeriodo(
            dataInicial, dataFinal, colaboradorSelecionado.value);
        await calcularComissao();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  Future<void> selecionarUltimosSeteDias() async {
    try {
      listaAtendimentoPeriodo.clear();
      isPeriodoUm.value = true;
      isPeriodoDois.value = false;
      isPeriodoTres.value = false;
      isPeriodoQuatro.value = false;
      isPeriodoCinco.value = false;
      final ultimosSeteDiasInicial = DateTime(ultimosSeteDias.year,
          ultimosSeteDias.month, ultimosSeteDias.day, 00, 00, 00, 00, 00);
      final ultimosSeteDiasFinal =
          DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59, 00, 00);
      dataInicial = ultimosSeteDiasInicial;
      dataFinal = ultimosSeteDiasFinal;
      periodoFinal.value = DateFormat('dd/MM/yyyy').format(dataFinal);
      periodoInicial.value = DateFormat('dd/MM/yyyy').format(dataInicial);
      if (colaboradorSelecionado.isNotEmpty) {
        listaAtendimentoPeriodo = await obterAtendimentoPeriodo(
            dataInicial, dataFinal, colaboradorSelecionado.value);
        await calcularComissao();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  Future<void> selecionarUltimosQuatorzeDias() async {
    try {
      listaAtendimentoPeriodo.clear();
      isPeriodoUm.value = false;
      isPeriodoDois.value = true;
      isPeriodoTres.value = false;
      isPeriodoQuatro.value = false;
      isPeriodoCinco.value = false;
      final ultimosQuartorzeDiasInicial = DateTime(
          ultimosQuatorzeDias.year,
          ultimosQuatorzeDias.month,
          ultimosQuatorzeDias.day,
          00,
          00,
          00,
          00,
          00);
      final ultimosQuatorzeDiasFinal =
          DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59, 00, 00);
      dataInicial = ultimosQuartorzeDiasInicial;
      dataFinal = ultimosQuatorzeDiasFinal;
      periodoFinal.value = DateFormat('dd/MM/yyyy').format(dataFinal);
      periodoInicial.value = DateFormat('dd/MM/yyyy').format(dataInicial);
      if (colaboradorSelecionado.isNotEmpty) {
        listaAtendimentoPeriodo = await obterAtendimentoPeriodo(
            dataInicial, dataFinal, colaboradorSelecionado.value);
        await calcularComissao();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  Future<void> selecionarUltimosTrintaDias(BuildContext context) async {
    try {
      listaAtendimentoPeriodo.clear();
      isPeriodoUm.value = false;
      isPeriodoDois.value = false;
      isPeriodoTres.value = true;
      isPeriodoQuatro.value = false;
      isPeriodoCinco.value = false;
      final ultimosTrintaDiasInicial = DateTime(ultimosTrintaDias.year,
          ultimosTrintaDias.month, ultimosTrintaDias.day, 00, 00, 00, 00, 00);
      final ultimosTrintaDiasFinal =
          DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59, 00, 00);
      dataInicial = ultimosTrintaDiasInicial;
      dataFinal = ultimosTrintaDiasFinal;
      periodoFinal.value = DateFormat('dd/MM/yyyy').format(dataFinal);
      periodoInicial.value = DateFormat('dd/MM/yyyy').format(dataInicial);
      if (colaboradorSelecionado.isNotEmpty) {
        listaAtendimentoPeriodo = await obterAtendimentoPeriodo(
            dataInicial, dataFinal, colaboradorSelecionado.value);
        await calcularComissao();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  Future<void> calcularComissao() async {
    try {
      totalComissao.value = 0.0;
      double valorComissao = 0.0;
      for (int i = 0; listaAtendimentoPeriodo.length > i; i++) {
        Servico? tipoAtendimento = listaServicos.firstWhereOrNull((servico) =>
            servico.id == listaAtendimentoPeriodo[i].idTipoAtendimento);

        if (tipoAtendimento != null) {
          valorComissao += tipoAtendimento.valorComissao;
        }
      }
      totalComissao.value = valorComissao;
    } catch (e) {
      rethrow;
    }
  }

  Future<Colaborador?> obterColaboradorByNome(String nome) async {
    try {
      listaColaboradores.value = await listarColaboradores();
      Colaborador? colaboradoresFiltrados = listaColaboradores
          .firstWhereOrNull((colaborador) => colaborador.nome == nome);

      return colaboradoresFiltrados;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Atendimento>> obterAtendimentoPeriodo(DateTime periodoInicial,
      DateTime periodoFinal, String nomeColaborador) async {
    try {
      listaAtendimentos.value = await listarAtendimentos();
      listaServicos.value = await listarServicos();
      listaAtendimentoPeriodo.clear();

      Colaborador? colaboradoresFiltrados =
          await obterColaboradorByNome(nomeColaborador);

      if (colaboradoresFiltrados == null) {
        throw Exception(
            'Nenhum colaborador encontrado com o nome $nomeColaborador');
      }

      Colaborador colaborador = colaboradoresFiltrados;

      List<Atendimento> listaColaboradorSelecionado = [];

      for (int i = 0; listaAtendimentos.length > i; i++) {
        if (listaAtendimentos[i].idColaborador == colaborador.id) {
          listaColaboradorSelecionado.add(listaAtendimentos[i]);
        }
      }

      for (int i = 0; listaColaboradorSelecionado.length > i; i++) {
        DateTime dataAtendimento =
            DateTime.parse(listaColaboradorSelecionado[i].dataHoraAtendimento);
        if (periodoInicial.isBefore(dataAtendimento) &&
            periodoFinal.isAfter(dataAtendimento)) {
          listaAtendimentoPeriodo.add(listaColaboradorSelecionado[i]);
        }
      }

      return listaAtendimentoPeriodo;
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
      return [];
    }
  }

  Future<void> gerarPdfECompartilhar() async {
    try {
      Colaborador? colaborador =
          await obterColaboradorByNome(colaboradorSelecionado.value);

      if (colaborador != null) {
        PolicyGerarPdfRelatorio(
                listaAtendimentos: listaAtendimentoPeriodo,
                valorComissao: totalComissao.value,
                colaborador: colaborador)
            .gerarPDF();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  Future selecionarPeriodoPersonalizadoInicial(BuildContext context) async {
    try {
      dataInicial = (await showDatePicker(
            context: context,
            locale: Locale('pt', 'BR'),
            initialDate: dataInicial,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          ))
              ?.copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0) ??
          DateTime.now().add(Duration(days: -7)).copyWith(
              hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

      periodoInicial.value = DateFormat('dd/MM/yyyy').format(dataInicial);

      if (colaboradorSelecionado.isNotEmpty) {
        listaAtendimentoPeriodo = await obterAtendimentoPeriodo(
            dataInicial, dataFinal, colaboradorSelecionado.value);
        await calcularComissao();
      }

      desmarcarTodosPeriodos();
      isPeriodoPersonalizadoSelecionado.value = true;
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  Future selecionarPeriodoPersonalizadoFinal(BuildContext context) async {
    try {
      dataFinal = (await showDatePicker(
            context: context,
            initialDate: dataFinal,
            locale: Locale('pt', 'BR'),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          ))
              ?.copyWith(
                  hour: 23,
                  minute: 59,
                  second: 59,
                  millisecond: 0,
                  microsecond: 0) ??
          DateTime.now().copyWith(
              hour: 23, minute: 59, second: 59, millisecond: 0, microsecond: 0);
      periodoFinal.value = DateFormat('dd/MM/yyyy').format(dataFinal);
      if (colaboradorSelecionado.isNotEmpty) {
        listaAtendimentoPeriodo = await obterAtendimentoPeriodo(
            dataInicial, dataFinal, colaboradorSelecionado.value);
        await calcularComissao();
      }
      desmarcarTodosPeriodos();
      isPeriodoPersonalizadoSelecionado.value = true;
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Ocorreu um erro ao selecionar o periodo. Contate o suporte - ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: vermelho,
          textColor: branco,
          fontSize: 16.0);
    }
  }

  void desmarcarTodosPeriodos() {
    isPeriodoUm.value = false;
    isPeriodoDois.value = false;
    isPeriodoTres.value = false;
    isPeriodoQuatro.value = false;
    isPeriodoCinco.value = false;
  }
}
