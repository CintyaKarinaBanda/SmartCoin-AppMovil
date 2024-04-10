import 'package:app/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:app/features/user_auth/presentation/pages/login_page.dart';
import 'package:app/features/user_auth/presentation/widgets/fondo_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/logo_widget.dart';
import 'package:app/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InicioR extends StatefulWidget {
  const InicioR({super.key});
  @override
  State<InicioR> createState() => _InicioRState();
}
class _InicioRState extends State<InicioR> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Fondo(),
          Logo(),
          Contenido(),
        ],
      ),
    );
  }
}



class Contenido extends StatefulWidget {
  const Contenido({super.key});
  @override
  State<Contenido> createState() => _ContenidoState();
}
class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SizedBox(height: 45),
            Text(
              'REGISTRATE',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Amiri",
              ),
            ),
          SizedBox(height: 10),
          Datos(),
          SizedBox(height: 30),
          Eslogan(),
        ],
      ),
    );
  }
}



class Datos extends StatefulWidget {
  const Datos({super.key});
  @override
  State<Datos> createState() => _DatosState();
}
class _DatosState extends State<Datos> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15,),
          SizedBox(
            height: 80,
            width: 80,
            child: Image.asset('assets/images/logo1.png'),
          ),
          
          const SizedBox(height: 10,),
          FormContainerWidget(
            controller: _usernameController,
            hintText: "Usuario",
            isPasswordField: false,
          ),
          const Text(
            '__________________________________________________',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10,),
          const SizedBox(height: 5,),
          FormContainerWidget(
            controller: _emailController,
            hintText: "Gmail",
            isPasswordField: false,
          ),
          const Text(
            '__________________________________________________',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10,),
          const SizedBox(height: 5,),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Passsword",
            isPasswordField: true,
          ),
          const Text(
            '__________________________________________________',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30,),
          GestureDetector(
            onTap:  (){
              _signUp();
            },
            child: Container(
              width: 200,
              height: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 153, 132),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: isSigningUp ? const CircularProgressIndicator(
                  color: Colors.white,):
                  const Text(
                    "REGISTRARSE",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiri"
                    ),
                  ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text(
              '¿Ya tienes una cuenta?',
              style: TextStyle(
                fontSize: 12,
              ),
      
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
  void _signUp() async {
    setState(() {
    isSigningUp = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "Usuario Registrado");
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Ah sucedido un error");
    }
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
            fontFamily: 'Amiri-Italic'
          ),
        ),
      ],
    );
  }
}

