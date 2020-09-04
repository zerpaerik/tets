import 'package:flutter/foundation.dart';

class Country with ChangeNotifier {
  final int id;
  final String name;

  Country(this.id, this.name);

  static List<Country> getCountrys() {
    return <Country>[
      Country(1, 'EEUU'),
      Country(2, 'México'),
      Country(2, 'Venezuela'),
    ];
  }
}
