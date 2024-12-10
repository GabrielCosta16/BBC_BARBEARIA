import 'package:bbc/domain/colaborador/uc_listar_colaboradores.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bbc/domain/colaborador/colaborador.dart';
import 'package:bbc/infra/consts.dart';

class UcObterColaborador {
  final DatabaseReference databaseReference;
  final int id;

  UcObterColaborador({required this.databaseReference, required this.id});

  /// Obtém um colaborador com base no ID.
  Future<Colaborador?> obterPorId() async {
    try {
      DatabaseEvent snapshot =
          await databaseReference.child(tabelaColaborador).once();

      String key = '';
      Colaborador? colaborador;

      if (snapshot.snapshot.value != "") {
        Map<Object?, Object?> itensMap =
            snapshot.snapshot.value as Map<Object?, Object?>;

        itensMap.forEach((key, value) {
          Map<Object?, Object?> itemData = value as Map<Object?, Object?>;
          if (itemData['id'] == id) {
            key = key;
            Map<String, dynamic> convertedMap = itemData.map(
                  (key, value) => MapEntry(key.toString(), value),
            );
            colaborador = Colaborador.fromJsonObject(convertedMap);
          }
        });
        return colaborador;
      }
    } catch (e) {
      Exception("Colaborador não encontrado");
    }
  }
}
