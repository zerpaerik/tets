import 'package:flutter/foundation.dart';

class Blodd with ChangeNotifier {
  final int id;
  final String name;

  Blodd(this.id, this.name);

  static List<Blodd> getBlodds() {
    return <Blodd>[Blodd(1, 'A'), Blodd(2, 'B'), Blodd(3, 'AB'), Blodd(4, 'O')];
  }
}
