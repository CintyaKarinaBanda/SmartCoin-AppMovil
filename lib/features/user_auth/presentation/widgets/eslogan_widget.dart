import 'package:flutter/material.dart';

class Eslogan extends StatefulWidget {
  const Eslogan({super.key});
  @override
  State<Eslogan> createState() => _EsloganState();
}
class _EsloganState extends State<Eslogan> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '"Ahorro inteligente para gastos presentes"',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Amiri-Italic'
          ),
        ),
      ],
    );
  }
}
