import 'package:app/features/user_auth/presentation/widgets/fondo_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/logo_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/menu_widget.dart';
import 'package:app/features/user_auth/services/firestore_services.dart';
import 'package:app/features/user_auth/services/mongo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';




class Objetivo extends StatefulWidget {
  const Objetivo({super.key});
  @override
  State<Objetivo> createState() => _ObjetivoState();
}
class _ObjetivoState extends State<Objetivo> {
  final MongoService _mongoService = MongoService();
  double _totalMonto = 0;
  @override
  void initState() {
    super.initState();
    _connectToDB();
  }
  Future<void> _connectToDB() async {
    await _mongoService.connectToDB();
    _fetchData();
  }
  Future<void> _fetchData() async {
    final result = await _mongoService.fetchDataFromDB();
    setState(() {
      // ignore: avoid_types_as_parameter_names
      _totalMonto = result.fold(0, (sum, item) => sum + (item['Valor'] ?? 0));
    });

    final objetivo = await getObjetivo();
    final fechaFinTimestamp = objetivo[0]['fecha'] as Timestamp?;
    if (fechaFinTimestamp != null && fechaFinTimestamp.toDate().isBefore(DateTime.now())) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fecha de meta excedida'),
            content: const Text('Por favor actualiza la fecha de tu objetivo'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
                child: const Text('Regresar'),
              ),
              TextButton(
                onPressed: () async {
                  var data = await getObjetivo();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, "/formObjetivo", arguments: {
                    "concepto": data[0]['concepto'],
                    "fecha": data[0]['fecha'],
                    "monto": data[0]['monto'],
                    "uid": data[0]["uid"]
                  });
                },
                child: const Text('Actualizar'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Fondo(),
          const Logo(),
          Contenido(totalMonto: _totalMonto),
          const Positioned(
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


class Contenido extends StatelessWidget {
  final double totalMonto;
  const Contenido({super.key, required this.totalMonto,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          //TITULO META
          const TituloMeta(),
          const SizedBox(height: 25),
          
          //DATOS FECHAS
          const Fechas(),
          const SizedBox(height: 40),
          
          //DATOS AHORRADO, META, FALTANTE
          Datos(totalMonto: totalMonto,),
          const SizedBox(height: 40),
          
          //BOTON EDITAR META
          const BotonEditar(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class TituloMeta extends StatelessWidget {
  const TituloMeta({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        const Text(
          'META',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "Amiri-Italic",
          ),
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: FutureBuilder(
            future: getObjetivo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Center(
                  child: Text(
                    snapshot.data?[0]['concepto'] ?? 'Sin datos',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiri-Italic",
                      color: Colors.black,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}



class Datos extends StatelessWidget {
  final double totalMonto;
  const Datos({super.key, required this.totalMonto});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 140,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Center(
                  child: Text(
                    'Ahorrado: $totalMonto',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 40,
              width: 140,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: FutureBuilder(
                  future: getObjetivo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      double meta = (snapshot.data?[0]['monto'] ?? 0).toDouble();

                      return Center(
                        child: Text(
                          'Meta: $meta',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 60,
          width: 260,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: FutureBuilder(
              future: getObjetivo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  double monto = (snapshot.data?[0]['monto'] ?? 0).toDouble();
                  double faltante = monto - totalMonto;
                  return Center(
                    child: Text(
                      'Faltante: $faltante',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}


class Fechas extends StatefulWidget {
  const Fechas({super.key});
  @override
  State<Fechas> createState() => _FechasState();
}

class _FechasState extends State<Fechas> {
  late String fechaActual;
  @override
  void initState() {
    super.initState();
    actualizarFechaActual();
  }
  void actualizarFechaActual() {
    setState(() {
      DateTime now = DateTime.now();
      fechaActual = DateFormat('dd/MM/yy').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 28,
          width: 28,
          child: Image(image: AssetImage('assets/images/fecha.png')),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            const Text(
              'HOY',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Amiri-Italic",
              ),
            ),
            Text(
              fechaActual,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontFamily: "Amiri-Italic",
              ),
            ),
          ],
        ),
        const SizedBox(width: 50),
        const SizedBox(
          height: 28,
          width: 28,
          child: Image(image: AssetImage('assets/images/fecha.png')),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            const Text(
              'FIN',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Amiri-Italic",
              ),
            ),
            SizedBox(
              height: 18,
              width: 60,
              child: FutureBuilder(
                future: getObjetivo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final fechaTimestamp = snapshot.data?[0]['fecha'] as Timestamp?;
                    final fecha = fechaTimestamp?.toDate();
                    final fechaFormateada = fecha != null? DateFormat('dd/MM/yy').format(fecha): 'Sin datos';
                    return Center(
                      child: Text(
                        fechaFormateada,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontFamily: "Amiri-Italic",
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}


class BotonEditar extends StatelessWidget {
  const BotonEditar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: getObjetivo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center();
            }
            else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            else {
              return GestureDetector(
                onTap: () async{
                  await Navigator.pushNamed(context, "/formObjetivo",
                    arguments: {
                      "concepto": snapshot.data?[0]['concepto'],
                      "fecha": snapshot.data?[0]['fecha'],
                      "monto": snapshot.data?[0]['monto'],
                      "uid": snapshot.data?[0]["uid"]
                    }
                  );
                },
                child: Container(
                  width: 180,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 153, 132),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "EDITAR META",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Amiri",
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        )
      ],
    );
  }
}