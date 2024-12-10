import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/infra/consts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ListaColaboradores extends StatelessWidget {
  final RxList<Colaborador> lista;
  final Function(Colaborador) onClick;
  bool isEdicao;

  ListaColaboradores({
    required this.lista,
    required this.onClick,
    required this.isEdicao,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => lista.isNotEmpty
          ? Expanded(
              flex: context.width > 500 ? 1 : 2,
              child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  var colaborador = lista[index];
                  return listTileColaborador(context, colaborador);
                },
              ),
            )
          : Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/imagens/nada_encontrado.png",
                    height: 180,
                  ),
                  Text(
                    "Nenhum colaborador encontrado",
                  ),
                ],
              ),
            ),
    );
  }

  Widget listTileColaborador(BuildContext context, Colaborador colaborador) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      title: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            elevation: WidgetStatePropertyAll(0),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            overlayColor: WidgetStatePropertyAll(azul.withOpacity(0.1))),
        onPressed: () {
          onClick(colaborador);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: azul, width: 4))),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                Text(
                  colaborador.nome,
                  style: context.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8,),
                Divider(
                  height: 1,
                  color: cinzaMedio,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
