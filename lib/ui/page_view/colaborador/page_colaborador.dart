import 'package:bbc/infra/consts.dart';
import 'package:bbc/infra/exception.dart';
import 'package:bbc/ui/page_view/ctrl_global.dart';
import 'package:bbc/ui/page_view/home/widgets/wdgt_lista_colaboradores.dart';
import 'package:bbc/ui/widgets/botao.dart';
import 'package:bbc/ui/widgets/campo_texto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PageColaborador extends StatefulWidget {
  CtrlGlobal controller;

  PageColaborador({required this.controller, super.key});

  @override
  State<PageColaborador> createState() => _PageColaboradorState();
}

class _PageColaboradorState extends State<PageColaborador> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: cinza,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          "Barbeiro",
                          style: context.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ListaColaboradores(
                            isEdicao: true,
                            lista: widget.controller.listaColaboradores,
                            onClick: (colaborador) {}),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        "Novo Barbeiro",
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
                          CampoTexto("Preencha o nome do colaborador",
                              widget.controller.tecNomeColaborador)
                        ],
                      ),
                      Botao(
                          titulo: "Salvar",
                          onClick: () async {
                            try {
                              if (widget
                                  .controller.tecNomeColaborador.text.isEmpty) {
                                throw EPreenchaTodosOsCampos();
                              }
                              widget.controller.temConexaoInternet =
                                  await InternetConnectionChecker()
                                      .hasConnection;

                              if (widget.controller.temConexaoInternet ==
                                  false) {
                                throw ESemConexaoComInternet();
                              }
                              widget.controller.addColaborador();
                              FocusScope.of(context).unfocus();
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
                ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
