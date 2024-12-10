import 'package:bbc/infra/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class UcRegistrar<T> {
  final String tabela;
  Map<String, dynamic> mapObjeto;

  UcRegistrar({required this.tabela, required this.mapObjeto});

  Future<void> registrar() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentReference controllerRef =
          firestore.collection(agrupador).doc(tabela);

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(controllerRef);

        int nextId = 1;

        if (snapshot.exists && snapshot.data() != null) {
          nextId = snapshot.get('ultimoId') + 1;
        }

        transaction.set(controllerRef, {'ultimoId': nextId});

        DocumentReference novoRegistro =
            firestore.collection(tabela).doc(nextId.toString());

        mapObjeto["id"] = nextId;

        transaction.set(novoRegistro, mapObjeto);
      });
    } catch (e) {
      Exception(e);
    }
  }
}
