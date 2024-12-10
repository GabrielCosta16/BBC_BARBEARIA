import 'package:bbc/infra/consts.dart';
import 'package:bbc/ui/page_view/ctrl_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BotaoAdicionar extends StatefulWidget {
  const BotaoAdicionar({super.key});

  @override
  State<BotaoAdicionar> createState() => _BotaoAdicionarState();
}

class _BotaoAdicionarState extends State<BotaoAdicionar> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        fixedSize: Size(120, 42),
        backgroundColor: verde, // Cor de fundo
        elevation: 6, // Sombra do botão
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16), // Raio de 16 para bordas arredondadas
        ),
      ),
      child: Text(
        "Adicionar",
        style: context.textTheme.titleMedium!.copyWith(color: branco),
      ),
    );
  }
}
