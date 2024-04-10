// ignore_for_file: avoid_print

import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  late final mongo.Db _db;

  Future<void> connectToDB() async {
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://KariBanda:Kari270204@inserccion.5mirapb.mongodb.net/Monedas');
      await _db.open();
      print('Connected to MongoDB Atlas');
    } catch (e) {
      print('Error connecting to MongoDB Atlas: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataFromDB() async {
    try {
      final collection = _db.collection('Historial');
      final List<Map<String, dynamic>> result = await collection.find().toList();
      return result;
    } catch (e, stackTrace) {
      print('Error fetching data from MongoDB: $e');
      print(stackTrace);
      return [];
    }
  }

  Future<void> closeConnection() async {
    await _db.close();
    print('Connection to MongoDB closed');
  }

  Future<void> deleteData(Map<String, dynamic> data) async {
    try {
      final collection = _db.collection('Historial');
      await collection.remove(data);
      print('Elemento eliminado de la base de datos: $data');
    } catch (e) {
      print('Error al eliminar el elemento de la base de datos: $e');
    }
  }

  Future<void> deleteAllData() async {
    try {
      final collection = _db.collection('Historial');
      await collection.remove({});
      print('Todos los elementos eliminados de la base de datos');
    } catch (e) {
      print('Error al eliminar todos los elementos de la base de datos: $e');
    }
  }
}
