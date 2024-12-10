import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/tipoAtendimento/tipo_atendimento.dart';
import 'package:bbc/infra/consts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ListaServicosEdicao extends StatelessWidget {
  final RxList<Servico> lista;
  final Function(Servico) onClick;

  ListaServicosEdicao({
    required this.lista,
    required this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => lista.isNotEmpty
          ? Expanded(
              flex: context.width > 500 ? 1 : 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    var colaborador = lista[index];
                    return listTileServicos(context, colaborador);
                  },
                ),
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
                    "Nenhum serviço encontrado",
                  ),
                ],
              ),
            ),
    );
  }

  Widget listTileServicos(
      BuildContext context, Servico tipoAtendimento) {
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
          onClick(tipoAtendimento);
        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: azul.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      child: Text(
                        "${tipoAtendimento.id} - ${tipoAtendimento.titulo}",
                        style: context.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold, color: azul),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
