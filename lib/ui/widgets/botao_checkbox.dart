import 'package:bbc/infra/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BotaoCheckbox extends StatefulWidget {
  bool selecionado;
  String titulo;
  Function() onClick;

  BotaoCheckbox(
      {required this.titulo,
      required this.onClick,
      required this.selecionado,
      super.key});

  State<BotaoCheckbox> createState() => BotaoCheckboxState();
}

class BotaoCheckboxState extends State<BotaoCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                widget.onClick();
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.selecionado ? azul : Colors.grey,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.titulo,
                          style: context.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Checkbox(
                      side: BorderSide(color: context.theme.dividerColor),
                      shape: CircleBorder(),
                      checkColor: Colors.white,
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return widget.selecionado
                            ? azul
                            : context.theme.colorScheme.background;
                      }),
                      value: widget.selecionado,
                      onChanged: (novoValor) {
                        widget.onClick();
                      },
                      activeColor: azul,
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
