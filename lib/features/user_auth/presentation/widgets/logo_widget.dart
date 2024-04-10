import 'package:flutter/material.dart';


class Logo extends StatefulWidget {
  const Logo({super.key});
  @override
  State<Logo> createState() => _LogoState();
}
class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 70,
            width: 70,
            child: Image.asset('assets/images/logo2.png'),
          ),
        ),
      ],
    );
  }
}