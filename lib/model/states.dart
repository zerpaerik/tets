import 'package:flutter/foundation.dart';

class States with ChangeNotifier {
  final int id;
  final String name;

  States(this.id, this.name);

 static List<States> getStates() {
    return <States>[
      States(1, 'Florida'),
    ];
  }
}