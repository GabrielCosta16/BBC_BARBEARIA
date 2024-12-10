import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectBox extends StatefulWidget {
  final String hint;
  final List<String> listItens;
  final RxString selectedValue;
  Function(String)? onChanged; // Agora aceitamos um RxString

  SelectBox(
      {required this.hint,
      required this.listItens,
      required this.selectedValue,
      this.onChanged});

  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              widget.hint,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: widget.listItens
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            value: widget.selectedValue.value.isEmpty
                ? null
                : widget.selectedValue.value,
            // Usando o valor do RxString
            onChanged: (String? value) async {
              if (value != null) {
                await widget.onChanged?.call(value);
                widget.selectedValue.value = value;
              }

              setState(() {});
            },
            buttonStyleData: const ButtonStyleData(
              height: 40,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
