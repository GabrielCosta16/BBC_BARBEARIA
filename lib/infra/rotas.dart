import 'package:bbc/ui/page_view/home/home_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

/// REFATORAR CÓDIGO COPIADO

class Rotas {
  static const splashPage = '/PageSplash';
  static const pageHome = '/PageHome';
  static const pageCadastroColaborador = '/PageCadastroColaborador';

  static String inicial() {
    return splashPage;
  }

  static List<GetPage> obterPages() {
    return [];
  }

  static Future ir(BuildContext context, var page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

class MyBindings extends Bindings {
  @override
  void dependencies() {}
}
