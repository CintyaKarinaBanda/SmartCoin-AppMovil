// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, unnecessary_nullable_for_final_variable_declarations

import 'package:app/features/user_auth/presentation/widgets/fondo_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/logo_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/menu_widget.dart';
import 'package:app/features/user_auth/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class FormObjetivo extends StatefulWidget {
  const  FormObjetivo({super.key});
  @override
  State<FormObjetivo> createState() => _FormObjetivoState();
}

class _FormObjetivoState extends State<FormObjetivo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Fondo(),
          Logo(),
          Contenido(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Menu(),
          ),
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
            Text(
              'OBJETIVO',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Amiri",
              ),
            ),
          SizedBox(height: 40),
          Datos(),
          SizedBox(height: 40),
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
  TextEditingController conceptoController = TextEditingController(text: "");
  TextEditingController montoController = TextEditingController();
  TextEditingController fechaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map? arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (arguments != null) {
      conceptoController.text = arguments['concepto'];

      final int? montoInt = arguments['monto'] as int?;
      final double monto = montoInt != null ? montoInt.toDouble() : 0.0;
      if (monto != null) {
        montoController.text = monto.toString();
      }

      final Timestamp? fecha = arguments['fecha'] as Timestamp;
      if (fecha != null) {
        DateTime dateTime = fecha.toDate();
        String formatoDate = DateFormat('dd/MM/yy').format(dateTime);
        fechaController.text = formatoDate;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40,),
          FormContainerWidget(
            hintText: "CONCEPTO",
            controller: conceptoController,
          ),
          const Text(
            '__________________________________________________',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15,),
          FormContainerWidget(
            hintText: "MONTO",
            controller: montoController,
          ),
          const Text(
            '__________________________________________________',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15,),
          FormContainerWidget(
            hintText: "FECHA",
            controller: fechaController,
          ),
          const Text(
            '__________________________________________________',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 60,),
          GestureDetector(
            onTap: () async {
              String formatoDate = fechaController.text;
              try {
                DateTime selectDate =
                    DateFormat('dd/MM/yy').parse(formatoDate);
                await updateObjetivo(
                  arguments?["uid"],
                  conceptoController.text,
                  double.parse(montoController.text),
                  selectDate,
                ).then((_) {
                  Navigator.pushNamed(context, "/objetivo");
                });
              } catch (e) {
                // ignore: avoid_print
                print("Error: $e");
              }
            },
            child: Container(
              width: 200,
              height: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 153, 132),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "GUARDAR",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Amiri"
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
