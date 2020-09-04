import 'package:flutter/foundation.dart';

class StatusM with ChangeNotifier {
  final int id;
  final String name;

  StatusM(this.id, this.name);

  static List<StatusM> getStatus() {
    return <StatusM>[
      StatusM(1, 'Soltero(a)'),
      StatusM(2, 'Casado(a)'),
      StatusM(3, 'Divorciado(a)'),
      StatusM(4, 'Viudo(a)')
    ];
  }
}
