// Tela principal do aplicativo

import "package:flutter/material.dart";
import '../pages/onibus_page.dart';

class Navegador extends StatefulWidget {
  const Navegador({super.key});

  @override
  State<Navegador> createState() => _NavegadorState();
}

/// Controlador das páginas. Navega por índice.
PageController controladorPageView = PageController();

class _NavegadorState extends State<Navegador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controladorPageView,
        children: const [
          OnibusPage(),
          Text("Mapa"),
          Text("Pontos")
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
          animation: controladorPageView,
          builder: (context, snapshot) {
            return BottomNavigationBar(
              currentIndex: controladorPageView.page?.round() ?? 0,
              onTap: (index) => controladorPageView.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInQuad,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_bus_filled),
                  label: "Ônibus",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: "Mapa",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.share_location_rounded),
                  label: "Pontos",
                ),
              ],
            );
          }),
    );
  }
}
