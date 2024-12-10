import 'package:bbc/infra/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CampoTexto extends StatefulWidget {
  TextEditingController controller;
  String? titulo;
  String hint;
  Function(String)? onChanged;
  bool? isSenha;
  int? maxLines;
  Icon? icone;
  int? minCaracteres;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? textInputType;

  CampoTexto(this.hint, this.controller,
      {this.titulo,
      this.onChanged,
      this.isSenha = false,
      this.maxLines,
      this.icone,
      this.minCaracteres,
      this.textInputType,
      this.inputFormatters});

  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8),
          child: widget.titulo != null
              ? Text(widget.titulo!,
                  style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.black54, fontWeight: FontWeight.w600))
              : SizedBox(
                  height: 0,
                ),
        ),
        TextField(
          maxLength: widget.minCaracteres,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.textInputType,
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            icon: widget.icone,
            hintText: widget.hint,
            hintStyle:
                context.textTheme.bodySmall!.copyWith(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: cinzac9),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: verde),
            ),
            border: OutlineInputBorder(),
          ),
          maxLines: widget.maxLines ?? 1,
        ),
      ],
    );
  }
}
