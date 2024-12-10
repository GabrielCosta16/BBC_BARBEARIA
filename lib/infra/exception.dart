class ESemConexaoComInternet extends FormatException {
  @override
  String toString() {
    return "Verifique sua conexão com a internet e tente novamente";
  }
}

class EPreenchaTodosOsCampos extends FormatException {
  @override
  String toString() {
    return "Preencha todos os campos";
  }
}
