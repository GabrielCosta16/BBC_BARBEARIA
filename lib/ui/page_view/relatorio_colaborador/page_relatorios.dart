import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/infra/consts.dart';
import 'package:bbc/infra/extension.dart';
import 'package:bbc/ui/page_view/ctrl_global.dart';
import 'package:bbc/ui/page_view/home/widgets/wdtg_lista_atendimentos_total.dart';
import 'package:bbc/ui/page_view/relatorio_colaborador/ctrl_relatorios.dart';
import 'package:bbc/ui/widgets/botao_checkbox.dart';
import 'package:bbc/ui/widgets/select_box.dart';
import 'package:bbc/ui/widgets/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../infra/exception.dart';

class PageRelatorios extends StatefulWidget {
  CtrlGlobal controller;
  Colaborador? colaborador;

  PageRelatorios({required this.controller, this.colaborador, super.key});

  @override
  State<PageRelatorios> createState() => _PageRelatoriosState();
}

class _PageRelatoriosState extends State<PageRelatorios> {
  late CtrlRelatorio controllerPage;

  @override
  void initState() {
    super.initState();

    controllerPage = CtrlRelatorio();
    controllerPage.listaColaboradoresRelatorio = widget
        .controller.listaColaboradores
        .map((colaborador) => colaborador.nome)
        .toList();
    controllerPage.periodoInicial.value =
        DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: -7)));
    controllerPage.periodoFinal.value =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    controllerPage.selecionarUltimosSeteDias();
    if (widget.colaborador != null) {
      controllerPage.colaboradorSelecionado.value = widget.colaborador!.nome;
      controllerPage.isPeriodoUm.value = true;
      showMyLoading(context, (loading) async {
        loading.mensagem("Buscando atendimentos no periodo...");
        await controllerPage.selecionarUltimosSeteDias();
        setState(() {});
        loading.fechar();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controllerPage.colaboradorSelecionado.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  children: [
                    addSecaoConfiguracao(),
                    addListaPeriodo(),
                  ],
                ),
              ),
              addLinhaComissao(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addSecaoConfiguracao() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Barbeiro",
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                addCampoColaborador(),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Periodo",
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                addBotoesPeriodo(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget addListaPeriodo() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Atendimentos",
            style: context.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          controllerPage.listaAtendimentoPeriodo.isNotEmpty
              ? ListaAtendimentos(
                  isHomePage: false,
                  listaServico: controllerPage.listaServicos,
                  listaColaborador: controllerPage.listaColaboradorSelecionado,
                  lista: controllerPage.listaAtendimentoPeriodo.obs)
              : Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Center(child: Text("Selecione um colaborador")),
                ),
        ],
      ),
    );
  }

  Widget addBotoesPeriodo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Container(
              width: 220,
              child: BotaoCheckbox(
                  titulo: "Hoje",
                  onClick: () async {
                    showMyLoading(context, (loading) async {
                      loading.mensagem("Buscando atendimentos no periodo...");
                      await controllerPage.selecionarHoje();
                      controllerPage.isPeriodoPersonalizadoSelecionado.value =
                          false;
                      setState(() {});
                      loading.fechar();
                    });
                  },
                  selecionado: controllerPage.isPeriodoQuatro.value),
            ),
            Container(
              width: 220,
              child: BotaoCheckbox(
                  titulo: "Ontem",
                  onClick: () async {
                    showMyLoading(context, (loading) async {
                      loading.mensagem("Buscando atendimentos no periodo...");
                      await controllerPage.selecionarOntem();

                      controllerPage.isPeriodoPersonalizadoSelecionado.value =
                          false;
                      setState(() {});
                      loading.fechar();
                    });
                  },
                  selecionado: controllerPage.isPeriodoCinco.value),
            ),
            Container(
              width: 220,
              child: BotaoCheckbox(
                  titulo: "Últimos 7 dias",
                  onClick: () async {
                    showMyLoading(context, (loading) async {
                      loading.mensagem("Buscando atendimentos no periodo...");
                      await controllerPage.selecionarUltimosSeteDias();
                      controllerPage.isPeriodoPersonalizadoSelecionado.value =
                          false;
                      setState(() {});
                      loading.fechar();
                    });
                  },
                  selecionado: controllerPage.isPeriodoUm.value),
            ),
            Container(
              width: 220,
              child: BotaoCheckbox(
                  titulo: "Últimos 14 dias",
                  onClick: () async {
                    showMyLoading(context, (loading) async {
                      loading.mensagem("Buscando atendimentos no periodo...");
                      await controllerPage.selecionarUltimosQuatorzeDias();
                      controllerPage.isPeriodoPersonalizadoSelecionado.value =
                          false;
                      setState(() {});
                      loading.fechar();
                    });
                  },
                  selecionado: controllerPage.isPeriodoDois.value),
            ),
            Container(
              width: 220,
              child: BotaoCheckbox(
                  titulo: "Últimos 30 dias",
                  onClick: () async {
                    showMyLoading(context, (loading) async {
                      loading.mensagem("Buscando atendimentos no periodo...");
                      await controllerPage.selecionarUltimosTrintaDias(context);
                      controllerPage.isPeriodoPersonalizadoSelecionado.value =
                          false;
                      setState(() {});
                      loading.fechar();
                    });
                  },
                  selecionado: controllerPage.isPeriodoTres.value),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Periodo personalizado"),
        ),
        addCampoPeriodo(),
      ],
    );
  }

  Widget addLinhaComissao() {
    return Obx(
      () => controllerPage.colaboradorSelecionado.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    await controllerPage.gerarPdfECompartilhar();
                  },
                  child: Text(
                    "Compartilhar",
                    style: context.textTheme.bodyLarge!.copyWith(color: azul),
                  ),
                ),
                Text(
                  controllerPage.totalComissao.value.toMoedaBR(),
                  style: context.textTheme.headlineLarge!
                      .copyWith(color: azul, fontWeight: FontWeight.bold),
                ),
                Text("Total: ${controllerPage.listaAtendimentoPeriodo.length}"),
              ],
            )
          : SizedBox(),
    );
  }

  Widget addCampoColaborador() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectBox(
          listItens: controllerPage.listaColaboradoresRelatorio,
          hint: "Selecione o colaborador",
          selectedValue: controllerPage.colaboradorSelecionado,
          onChanged: (colaborador) async {
            try {
              widget.controller.temConexaoInternet =
                  await InternetConnectionChecker().hasConnection;

              if (widget.controller.temConexaoInternet == false) {
                throw ESemConexaoComInternet();
              }
              showMyLoading(context, (loading) async {
                loading.mensagem("Buscando atendimentos no periodo...");

                controllerPage.atualizarListas();

                controllerPage.listaAtendimentoPeriodo =
                    await controllerPage.obterAtendimentoPeriodo(
                        controllerPage.dataInicial,
                        controllerPage.dataFinal,
                        colaborador);
                Colaborador? colaboradorSelect =
                    await controllerPage.obterColaboradorByNome(colaborador);
                controllerPage.listaColaboradorSelecionado.clear();
                controllerPage.listaColaboradorSelecionado
                    .add(colaboradorSelect!);

                loading.mensagem("Calculando comissão...");
                controllerPage.calcularComissao();
                loading.fechar();
                setState(() {});
              });
            } catch (e) {
              Fluttertoast.showToast(
                  msg: e.toString(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: vermelho,
                  textColor: branco,
                  fontSize: 18.0);
            }
          },
        ),
      ],
    );
  }

  Widget addCampoPeriodo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            await controllerPage.selecionarPeriodoPersonalizadoInicial(context);
            setState(() {});
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: controllerPage.isPeriodoPersonalizadoSelecionado.value
                      ? azul
                      : cinzacEscuro),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
                  controllerPage.periodoInicial.value,
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('-'),
        ),
        GestureDetector(
          onTap: () async {
            await controllerPage.selecionarPeriodoPersonalizadoFinal(context);
            setState(() {});
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: controllerPage.isPeriodoPersonalizadoSelecionado.value
                      ? azul
                      : cinzacEscuro),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
                  controllerPage.periodoFinal.value,
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
