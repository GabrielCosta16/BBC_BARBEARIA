import 'dart:async';

import 'package:bbc/infra/consts.dart';
import 'package:bbc/ui/page_view/colaborador/page_colaborador.dart';
import 'package:bbc/ui/page_view/ctrl_global.dart';
import 'package:bbc/ui/page_view/home/home_page.dart';
import 'package:bbc/ui/page_view/relatorio_colaborador/page_relatorios.dart';
import 'package:bbc/ui/page_view/servicos/page_servicos.dart';
import 'package:bbc/ui/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  PageController _pageController = PageController();
  late CtrlGlobal controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = CtrlGlobal();
    controller.atualizarListas();

    _pageController.addListener(() {
      int currentIndex = _pageController.page?.round() ?? 0;
      if (_selectedIndex != currentIndex) {
        setState(() {
          _selectedIndex = currentIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.atualizarListas();
        },
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: [
            PageHome(
              controller: controller,
              pageViewController: _pageController,
            ),
            PageRelatorios(controller: controller),
            PageServicos(controller: controller),
            PageColaborador(controller: controller),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Color(0xff000428),
            boxShadow: [BoxShadow(color: preto, blurRadius: 16)],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        height: 88,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabItem(
                Image.asset(
                  pathLogo,
                  height: 72,
                ),
                0),
            _buildTabItem(
                Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.calendarCheck,
                      color: branco,
                    ),
                    Text("Relatórios", style: context.textTheme.bodyLarge!.copyWith(color: branco),)
                  ],
                ),
                1),
            _buildTabItem(
                Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.scissors,
                      color: branco,
                    ),
                    Text("Serviços", style: context.textTheme.bodyLarge!.copyWith(color: branco),)
                  ],
                ),
                2),
            _buildTabItem(
                Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.userGear,
                      color: branco,
                    ),
                    Text("Colaborador", style: context.textTheme.bodyLarge!.copyWith(color: branco),)
                  ],
                ),
                3),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(Widget widget, int index) {
    final isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow:
                isSelected ? [BoxShadow(color: preto, blurRadius: 16)] : [],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16)),
            color: isSelected ? azul : azulEscuro,
          ),
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libera os recursos do PageController
    _pageController.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(
      home: MyPageView(),
    ));
