import 'package:bbc/ui/widgets/utils/circle_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showMyLoading(BuildContext context, Function(Loading) func) async {
  FocusManager.instance.primaryFocus?.unfocus();

  await Future.delayed(const Duration(milliseconds: 200));

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (bc) {
      Loading loadingProp = Loading(bc);

      Future.delayed(const Duration(milliseconds: 500), () {
        func.call(loadingProp);
      });

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => loadingProp._atualizarHeader.value &&
                          loadingProp.imagePath.isEmpty
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          child: loadingProp._header,
                        )
                      : loadingProp.imagePath.value.isNotEmpty
                          ? Image.asset(loadingProp.imagePath.value)
                          : SizedBox(),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => Text(
                    loadingProp._mensagem.value,
                    style: context.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class Loading {
  final BuildContext context;
  final RxString _mensagem = 'Aguarde'.obs;
  final RxString imagePath = ''.obs;
  final _atualizarHeader = true.obs;

  Widget _header = const CircleLoading();

  Loading(this.context);

  void mensagem(String msg) {
    _mensagem.value = msg;
  }

  void headerIcon(Widget head) {
    _header = head;

    _atualizarHeader.refresh();
  }

  void fechar() {
    Navigator.of(context).pop();
  }
}
