import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/infra/consts.dart';
import 'package:bbc/infra/exception.dart';
import 'package:bbc/ui/page_view/ctrl_global.dart';
import 'package:bbc/ui/page_view/home/widgets/wdgt_lista_colaboradores.dart';
import 'package:bbc/ui/page_view/home/widgets/wdtg_lista_atendimentos_total.dart';
import 'package:bbc/ui/page_view/home/widgets/wdtg_lista_servicos.dart';
import 'package:bbc/ui/widgets/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PageHome extends StatefulWidget {
  CtrlGlobal controller;
  PageController pageViewController;

  PageHome(
      {required this.pageViewController, required this.controller, super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.atualizarListas();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: cinza,
            body: RefreshIndicator(
              color: azul,
              onRefresh: () async {
                await widget.controller.atualizarTela();
                setState(() {});
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cinza,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Barbeiros",
                                          style: context.textTheme.bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        ListaColaboradores(
                                            isEdicao: false,
                                            lista: widget
                                                .controller.listaColaboradores,
                                            onClick: (colaborador) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return dialogNovoAtendimento(
                                                        colaborador);
                                                  });
                                            }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Text(
                                        "Atendimentos",
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      ListaAtendimentos(
                                        isHomePage: true,
                                          listaServico:
                                              widget.controller.listaServicos,
                                          listaColaborador: widget
                                              .controller.listaColaboradores,
                                          lista: widget
                                              .controller.listaAtendimentos)
                                    ],
                                  ))
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget dialogNovoAtendimento(Colaborador barbeiro) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: cinza,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${barbeiro.nome} - Novo atendimento",
              style: context.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              height: 2,
              color: cinzac9,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: widget.controller.listaServicos.map((servico) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text(servico.titulo),
                        onTap: () async {
                          Navigator.of(context).pop();
                          try {
                            widget.controller.temConexaoInternet =
                                await InternetConnectionChecker().hasConnection;

                            if (widget.controller.temConexaoInternet == false) {
                              throw ESemConexaoComInternet();
                            }
                            showMyLoading(context, (loading) async {
                              loading.mensagem("Anotando atendimento...");

                              await widget.controller
                                  .addAtendimento(barbeiro.id, servico.id);
                              setState(() {});
                              loading.imagePath(pathSucesso);
                              loading.mensagem("Sucesso!");
                              await Future.delayed(const Duration(seconds: 1));
                              loading.fechar();
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
                      Divider(
                        height: 2,
                        color: cinzac9,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
