import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/colaborador/uc_listar_colaboradores.dart';
import 'package:bbc/domain/tipoAtendimento/tipo_atendimento.dart';
import 'package:bbc/infra/consts.dart';
import 'package:bbc/ui/widgets/botao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListaAtendimentos extends StatelessWidget {
  final RxList<Atendimento> lista;
  final List<Colaborador>? listaColaborador;
  final List<Servico> listaServico;
  bool isHomePage;

  ListaAtendimentos({
    required this.listaServico,
    this.listaColaborador,
    required this.lista,
    required this.isHomePage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    lista.sort((a, b) => -a.id.compareTo(b.id));
    return Obx(
      () => lista.isNotEmpty
          ? Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      var atendimento = lista[index];
                      int totalItens = lista.length;
                      int i = totalItens - index;

                      return Container(
                        color: i % 2 != 0 ? cinzac9 : cinza,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            isHomePage == false
                                ? "$i - ${atendimento.obterAtendimentoRelatorio(obterNomeColaboradorAtendimento(atendimento), obterNomeTipoAtendimentoByAtendimento(atendimento))}"
                                : obterNomeTipoAtendimentoByAtendimento(
                                    atendimento),
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      );
                    },
                  ),
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
                  const Text(
                    "Nenhum atendimento encontrado",
                  )
                ],
              ),
            ),
    );
  }

  String obterNomeColaboradorAtendimento(Atendimento atendimento) {
    if (listaColaborador!.isEmpty) {
      return "";
    }

    return listaColaborador!
        .where((e) => e.id == atendimento.idColaborador)
        .toList()
        .first
        .nome;
  }

  String obterNomeTipoAtendimentoByAtendimento(Atendimento atendimento) {
    if (listaServico.isEmpty) {
      return "";
    }
    DateTime horaAtendimento = DateTime.parse(atendimento.dataHoraAtendimento);
    String horaFormatada = DateFormat("HH:mm ").format(horaAtendimento);

    return " ${listaServico.where((e) => e.id == atendimento.idTipoAtendimento).toList().first.titulo} - $horaFormatada";
  }
}
