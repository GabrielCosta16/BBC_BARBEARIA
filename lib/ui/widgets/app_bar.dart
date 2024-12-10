import 'package:bbc/infra/consts.dart';
import 'package:flutter/material.dart';

AppBar appBarPadrao(
    {List<Widget>? actions, Widget? botaoEsquerdo, Widget? drawer}) {
  return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: azul,
        ),
      ),
      title: Container(
        constraints: BoxConstraints(maxWidth: 75, maxHeight: 75),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(pathLogo),
        ),
      ),
      toolbarHeight: 80,
      actions: actions,
      leading: botaoEsquerdo);
}
