
extension Jsonutils on Map<String, dynamic> {
  bool contemTagNotNull(String chave) {
    return containsKey(chave) && this[chave] != null;
  }

  String? asStringNull(String chave) {
    if (containsKey(chave)) {
      if (this[chave] == null) {
        return null;
      }

      return this[chave].toString();
    }
    throw Exception(chave);
  }

  String? asStringOrDefault(String chave, String? def) {
    if (containsKey(chave)) {
      if (this[chave] == null) {
        return def;
      }

      return this[chave].toString();
    }

    return def;
  }

  String asString(String chave) {
    return asStringNull(chave) ?? '';
  }

  String? asStringNullIfContainsTag(String chave) {
    try {
      return asStringNull(chave);
    } catch (e) {
      return null;
    }
  }

  double? asDoubleNull(String chave) {
    if (containsKey(chave)) {
      if (this[chave] == null) {
        return null;
      }

      return double.tryParse(this[chave].toString());
    }
    throw Exception(chave);
  }

  double? asDoubleNullIfContainsTag(String chave) {
    if (containsKey(chave)) {
      if (this[chave] == null) {
        return null;
      }

      return double.tryParse(this[chave].toString());
    }

    return null;
  }

  double asDouble(String chave) {
    return asDoubleNull(chave) ?? 0.0;
  }

  bool asBoolIfContainsTag(String chave, bool padrao) {
    if (containsKey(chave)) {
      var str = this[chave].toString().toLowerCase();

      if (['true', '1'].contains(str)) {
        return true;
      }

      if (['false', '0'].contains(str)) {
        return false;
      }

      return false;
    }

    return padrao;
  }

  DateTime? asDateTimeNull(String chave) {
    if (containsKey(chave)) {
      if (this[chave] == null) {
        return null;
      }

      return DateTime.tryParse(this[chave].toString());
    }
    throw Exception(chave);
  }

  DateTime asDateTime(String chave) {
    return asDateTimeNull(chave) ?? DateTime.now();
  }

  DateTime? asDateTimeIfContainsTag(String chave) {
    try {
      return asDateTimeNull(chave) ?? DateTime.now();
    } catch (e) {
      return null;
    }
  }

  int? asIntNull(String chave) {
    if (containsKey(chave)) {
      if (this[chave] == null) {
        return null;
      }

      var vInt = int.tryParse(this[chave].toString());
      if (vInt != null) {
        return vInt;
      }

      var vDouble = double.tryParse(this[chave].toString());
      if (vDouble != null) {
        return vDouble.toInt();
      }

      if (this[chave].toString().toLowerCase() == 'true') {
        return 1;
      }

      if (this[chave].toString().toLowerCase() == 'false') {
        return 0;
      }

      return int.tryParse(this[chave].toString());
    }
    throw Exception(chave);
  }

  int asInt(String chave) {
    return asIntNull(chave) ?? 0;
  }

  int? asIntNullIfContainsTag(String chave) {
    try {
      return asIntNull(chave) ?? 0;
    } catch (e) {
      return null;
    }
  }

  int? asIntNullIfContainsTagOuDefaul(String chave, int? def) {
    try {
      return asIntNull(chave) ?? def;
    } catch (e) {
      return null;
    }
  }

  bool asBooleanIfContainsTag(String chave, bool padrao) {
    try {
      return asBooleanNull(chave) ?? padrao;
    } catch (e) {
      return padrao;
    }
  }

  bool? asBooleanNull(String chave) {
    if (containsKey(chave)) {
      var str = this[chave].toString().toLowerCase();

      if (['true', '1'].contains(str)) {
        return true;
      }

      if (['false', '0'].contains(str)) {
        return false;
      }

      return false;
    }
    throw Exception(chave);
  }

  bool? asBoolNullIfContainsTag(String chave) {
    if (containsKey(chave)) {
      if (this[chave] == null) {
        return null;
      }

      return asBooleanNull(chave);
    }

    return null;
  }

  bool asBoolean(String chave) {
    return asBooleanNull(chave) ?? false;
  }

  List<int> asListInt(String chave) {
    if (containsKey(chave) == false) {
      throw Exception(chave);
    }

    if (this[chave] == null) {
      return [];
    }

    if (this[chave] is List<dynamic>) {
      List<dynamic> lista = this[chave];

      lista.removeWhere((valor) => valor == '');

      List<int> listaInt = [];
      for (dynamic item in lista) {
        if (int.tryParse(item.toString()) != null) {
          listaInt.add(int.parse(item.toString()));
        }
      }

      return listaInt;
    }
    return this[chave];
  }

  List<String> asListString(String chave) {
    if (containsKey(chave)) {
      if (this[chave] != null) {
        if (this[chave] is List<dynamic>) {
          return List<String>.from(this[chave]);
        }
        return this[chave];
      }

      return [];
    }
    throw Exception(chave);
  }

  List<String> asListStringIfContainsTag(String chave) {
    if (containsKey(chave) == false) {
      return [];
    }

    return asListString(chave);
  }

  List<String> asListStringOrEmpty(String chave) {
    if (containsKey(chave)) {
      if (this[chave] != null) {
        if (this[chave] is List<dynamic>) {
          return List<String>.from(this[chave]);
        }
        return this[chave];
      }

      return [];
    }
    return [];
  }

  Map<String, dynamic>? asJsonNull(String chave) {
    if (containsKey(chave)) {
      return this[chave];
    }
    return null;
  }

  bool containsAndNotNull(String chave) {
    if (containsKey(chave)) {
      return this[chave] != null;
    }
    return false;
  }
}
