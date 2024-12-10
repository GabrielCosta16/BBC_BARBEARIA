import 'dart:io';

import 'package:bbc/domain/atendimento/atendimento.dart';
import 'package:bbc/domain/atendimento/uc_listar_atendimentos.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/domain/tipoAtendimento/uc_listar_servicos.dart';
import 'package:bbc/infra/consts.dart';
import 'package:bbc/infra/extension.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pdf/widgets.dart' as pw;

class PolicyGerarPdfRelatorio {
  List<Atendimento> listaAtendimentos;
  Colaborador colaborador;
  double valorComissao;

  PolicyGerarPdfRelatorio(
      {required this.listaAtendimentos,
      required this.colaborador,
      required this.valorComissao});

  Future<void> gerarPDF() async {
    final pdf = pw.Document();
    final pageSize = PdfPageFormat(400, 600);
    final logoBytes = await rootBundle.load('assets/imagens/logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final listaServicos = await UcListarServicos().listar();

    pdf.addPage(
      pw.Page(
        pageFormat: pageSize,
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  decoration:
                      pw.BoxDecoration(color: PdfColor.fromHex("000428")),
                  child: pw.Row(children: [
                    pw.SizedBox(width: 16),
                    pw.Image(logo, width: 50, height: 50),
                    pw.SizedBox(width: 16),
                    pw.Text(
                      'Relatório de Atendimentos',
                      style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex("ffffff")),
                    ),
                  ]),
                ),
                pw.Column(
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Text("Atendimentos"),
                    pw.SizedBox(height: 20),
                    pw.ListView(
                        children:
                            listaAtendimentos.asMap().entries.map((entry) {
                      int i = entry.key + 1;
                      var atendimento = entry.value;
                      var tipoServico = listaServicos.where((e)=> e.id == atendimento.idTipoAtendimento).first;
                      return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                                "$i - ${atendimento.obterAtendimentoRelatorio(colaborador.nome, tipoServico.titulo)}",
                                textAlign: pw.TextAlign.start,
                                ),
                            pw.Divider(
                                height: 1, color: PdfColor.fromHex("c9c9c9")),
                          ]);
                    }).toList()),
                    pw.Row(children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(height: 24),
                            pw.Text("Barbeiro: ${colaborador.nome}"),
                            pw.Text(
                                "Total: ${listaAtendimentos.length} atendimentos"),
                            pw.Text("Comissão: ${valorComissao.toMoedaBR()}"),
                          ])
                    ])
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/atendimentos.pdf');
    await file.writeAsBytes(await pdf.save());

    final xFile = XFile(file.path);

    await Share.shareXFiles([xFile], text: 'Confira a lista de atendimentos!');
  }
}
