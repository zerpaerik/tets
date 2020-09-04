import 'package:flutter/foundation.dart';

class Rh with ChangeNotifier {
  final int id;
  final String name;

  Rh(this.id, this.name);

 static List<Rh> getRh() {
    return <Rh>[
      Rh(0,'Seleccione Factor'),
      Rh(1,'Positivo(+)'),
      Rh(2,'Nrgativo(-)'),
      Rh(3,'No lo se'),
    ];
  }
}