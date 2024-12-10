import 'package:bbc/domain/tipoAtendimento/tipo_atendimento.dart';
import 'package:bbc/infra/consts.dart';
import 'package:bbc/ui/widgets/badge_servico.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ListaServicos extends StatelessWidget {
  RxList<Servico> lista;

  ListaServicos({required this.lista, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cinza,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: lista.map((servico) {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return dialogOpcoesTipoServico(context, servico);
                      });
                },
                child: BadgeServico(
                  descricao: servico.titulo,
                  qtde: servico.listaAtendimentos.entries
                      .where((entry) {
                        final dataAtendimento = DateTime.parse(entry.value);
                        final agora = DateTime.now();
                        return dataAtendimento.year == agora.year &&
                            dataAtendimento.month == agora.month &&
                            dataAtendimento.day == agora.day;
                      })
                      .toList()
                      .length
                      .obs,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget dialogOpcoesTipoServico(
      BuildContext context, Servico servico) {
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
              "Opções - ${servico.titulo}",
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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.penToSquare,
                        color: cinzacEscuro,
                      ),
                      title: Text('Editar'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        // await controller.removerColaborador(babeiro.id);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        height: 2,
                        color: cinzac9,
                      ),
                    ),
                    ListTile(
                      leading:
                          Icon(FontAwesomeIcons.trash, color: cinzacEscuro),
                      title: Text('Excluir'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
