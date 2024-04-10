import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),(){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
          children: [
          Fondo(),
          Logo(),
        ],
      ),
    );
  }
}


class Fondo extends StatelessWidget {
  const   Fondo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 220, 213, 1)),
      );
  }
}

class Logo extends StatefulWidget {
  const Logo({super.key});
  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 150,),
        Align(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Image(image: AssetImage('assets/images/logo2.png')),
          ),
        ),
        SizedBox(height: 30,),
        Eslogan(),
        Align(
          child: SizedBox(
            height: 100,
            width: 200,
            child: Image(image: AssetImage('assets/images/barra.jpeg')),
          ),
        ),
      ],
      
    );
  }
}

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
            fontFamily: 'Amiri-Bold'
          ),
        ),
      ],
    );
  }
}