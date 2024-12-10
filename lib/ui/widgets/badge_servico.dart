import 'package:bbc/infra/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BadgeServico extends StatefulWidget {
  String descricao;
  RxInt qtde;

  BadgeServico({required this.descricao, required this.qtde, super.key});

  @override
  State<BadgeServico> createState() => _BadgeServicoState();
}

class _BadgeServicoState extends State<BadgeServico> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: azul.withOpacity(0.2)),
        child: Obx(() {
          return Text(
            '${widget.descricao}: ${widget.qtde.toString()}',
            style: context.textTheme.titleLarge!
                .copyWith(color: azul, fontWeight: FontWeight.w500),
          );
        }),
      ),
    );
  }
}
