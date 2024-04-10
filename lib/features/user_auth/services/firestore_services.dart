import 'package:cloud_firestore/cloud_firestore.dart';

//TRAER DATOS DE FIREBASE
FirebaseFirestore db = FirebaseFirestore.instance;
Future<List> getObjetivo() async {
  List objetivo = [];
  CollectionReference collectionReferenceObjetivo = db.collection('objetivo');

  QuerySnapshot queryObjetivo = await collectionReferenceObjetivo.get();

  // ignore: avoid_function_literals_in_foreach_calls
  queryObjetivo.docs.forEach((documento) {

    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final meta = {
      "concepto": data['concepto'],
      "monto": data['monto'],
      "fecha": data['fecha'],
      "uid": documento.id,
    };
    objetivo.add(meta);
  });

  return objetivo;
}

//ACTUALIZAR LA BD

Future<void> updateObjetivo(String uid, String newConcepto, double newMonto, DateTime newFecha) async{
  Timestamp fechaTimestamp = Timestamp.fromDate(newFecha);
  await db.collection('objetivo').doc(uid).set({
    'concepto': newConcepto,
    'monto': newMonto,
    'fecha': fechaTimestamp,
  });
}