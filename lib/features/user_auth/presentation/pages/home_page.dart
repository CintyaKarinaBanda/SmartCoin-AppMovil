// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable

import 'package:app/features/user_auth/presentation/widgets/fondo_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/logo_widget.dart';
import 'package:app/features/user_auth/presentation/widgets/menu_widget.dart';
import 'package:app/features/user_auth/services/mongo_service.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetX;
  final double offsetY;

  const CustomFloatingActionButtonLocation(this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double x = scaffoldGeometry.scaffoldSize.width - 85.0 + offsetX;
    final double y = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height - 90.0 + offsetY;
    return Offset(x, y);
  }

  @override
  String toString() => 'CustomFloatingActionButtonLocation';
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late final MongoService _mongoService = MongoService();
  late List<Map<String, dynamic>> _dataFromDB = [];
  double _totalMonto = 0;
  @override
  void initState() {
    super.initState();
    _connectToDB();
  }
  void _connectToDB() async {
    await _mongoService.connectToDB();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final result = await _mongoService.fetchDataFromDB();
    result.sort((a, b) => b['Fecha'].compareTo(a['Fecha']));
    _totalMonto = result.fold(0, (sum, item) => sum + (item['Valor'] ?? 0));
    setState(() {
      _dataFromDB = result;
    });
  }

  Future<void> _handleDeleteAll() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar todos los registros'),
          content: const Text('¿Estás seguro de que deseas eliminar todos los registros?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _mongoService.connectToDB();
                  await _mongoService.deleteAllData();
                } catch (e) {
                  print('Error al eliminar todos los elementos de la base de datos: $e');
                }
                setState(() {
                  _dataFromDB.clear();
                  _totalMonto = 0;
                });
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Fondo(),
          const Logo(),
          Contenido(dataFromDB: _dataFromDB, totalMonto: _totalMonto),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Menu(),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          onPressed: _handleDeleteAll,
          tooltip: 'Eliminar todos los registros',
          backgroundColor: const Color.fromARGB(255, 186, 100, 100),
          child: const Icon(Icons.delete_forever,color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: const CustomFloatingActionButtonLocation(0, -10),
    );
  }
}

class Contenido extends StatefulWidget {
  final List<Map<String, dynamic>> dataFromDB;
  double totalMonto;

  Contenido({super.key, required this.dataFromDB, required this.totalMonto});

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  late final MongoService _mongoService = MongoService();

  Future<void> _handleDelete(Map<String, dynamic> dataToDelete) async {
    try {
      await _mongoService.connectToDB();
      await _mongoService.deleteData(dataToDelete);
    } catch (e) {
      print('Error al eliminar el elemento de la base de datos: $e');
    }
    setState(() {
      widget.dataFromDB.remove(dataToDelete);
      widget.totalMonto -= (dataToDelete['Valor'] ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 85,),
          const SizedBox(height: 10),
          Datos(monto: widget.totalMonto),
          const SizedBox(height: 30,),
          const Text(
            'INGRESOS',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Amiri",
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: _buildDatos2Widgets(),
            ),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildDatos2Widgets() {
  if (widget.dataFromDB.isEmpty) {
    return const Center(
      child: Text(
        'Empieza a ahorrar ya',
        style: TextStyle(fontSize: 18),
      ),
    );
  } else {
    return Column(
      children: widget.dataFromDB.map((data) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Datos2(data: data, onDelete: () => _handleDelete(data)),
      )).toList(),
    );
  }
}

}

class Datos extends StatefulWidget {
  final double monto;

  const Datos({super.key, required this.monto});

  @override
  _DatosState createState() => _DatosState();
}

class _DatosState extends State<Datos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(255, 250, 158, 158),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MONTO',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Amiri",
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '\$ ${widget.monto}',
              style: const TextStyle(fontSize: 35,),
            ),
          ),
        ],
      ),
    );
  }
}

class Datos2 extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;

  const Datos2({super.key, required this.data,required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '\$ ${data["Valor"]}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              '${data["Fecha"]}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
