import 'package:bbc/infra/consts.dart';
import 'package:bbc/ui/page_view/ctrl_global.dart';
import 'package:bbc/ui/page_view/servicos/widgets/wdgt_lista_servicos_edicao.dart';
import 'package:bbc/ui/widgets/botao.dart';
import 'package:bbc/ui/widgets/campo_texto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../infra/exception.dart';

class PageServicos extends StatefulWidget {
  CtrlGlobal controller;

  PageServicos({required this.controller, super.key});

  @override
  State<PageServicos> createState() => _PageServicosState();
}

class _PageServicosState extends State<PageServicos> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: cinza,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Serviços",
                            style: context.textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ListaServicosEdicao(
                              lista: widget.controller.listaServicos,
                              onClick: (servico) {
                                // widget.controller.tecNomeTipoAtendimento.text =
                                //     servico.titulo;
                                // widget.controller.tecValorAtendimento.text =
                                //     servico.titulo;
                                // widget.controller.tecComissaoAtendimento.text =
                                //     servico.valorAtendimento.toString();
                              })
                        ],
                      )),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          "Novo serviço",
                          style: context.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome"),
                            CampoTexto("Preencha o nome do serviço",
                                widget.controller.tecNomeTipoAtendimento)
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Valor"),
                            CampoTexto("Preencha o valor do serviço",
                                widget.controller.tecValorAtendimento)
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Comissão"),
                            CampoTexto("Preencha o valor da comissão",
                                widget.controller.tecComissaoAtendimento)
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Botao(
                            titulo: "Salvar",
                            onClick: () async {
                              try {
                                if (widget.controller
                                        .todosCamposServicosPreenchidos() ==
                                    false) {
                                  throw EPreenchaTodosOsCampos();
                                }

                                widget.controller.temConexaoInternet =
                                    await InternetConnectionChecker()
                                        .hasConnection;

                                if (widget.controller.temConexaoInternet ==
                                    false) {
                                  throw ESemConexaoComInternet();
                                }
                                widget.controller.addTipoAtendimento();
                                FocusManager.instance.primaryFocus?.unfocus();
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
                            })
                      ],
                    ),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
