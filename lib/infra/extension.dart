import 'package:intl/intl.dart';

extension MoedaBR on double {
  String toMoedaBR() {
    final formatador = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    return formatador.format(this);
  }
}
