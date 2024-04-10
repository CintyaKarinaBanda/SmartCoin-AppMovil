import 'package:flutter/material.dart';


class Fondo extends StatelessWidget {
  const Fondo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 220, 213, 1)),
      );
  }
}