import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UcListarObjetos<T> {
  final String tabela;

  UcListarObjetos({required this.tabela});

  /// Método que converte o JSON em um objeto do tipo `T`
  T fromJson(Map<String, dynamic> json);

  /// Método genérico para listar objetos do Firestore
  Future<List<T>> listar() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection(tabela).get();

      // Mapeia os documentos da coleção para o tipo `T` usando o `fromJson`
      final itens = querySnapshot.docs.map((doc) {
        return fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return itens;
    } catch (e) {
      print("Erro ao obter documentos: $e");
      return [];
    }
  }
}
