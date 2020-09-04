import 'package:flutter/foundation.dart';

class Workday with ChangeNotifier {
  final int id;
  // ignore: non_constant_identifier_names
  final DateTime created;
  final DateTime clock_in_start;
  final DateTime clock_in_end;
  final DateTime clock_out_end;

  Workday({
    @required this.id,
    // ignore: non_constant_identifier_names
    @required this.created,
    @required this.clock_in_start,
    @required this.clock_in_end,
    @required this.clock_out_end,
  });

  factory Workday.fromJson(Map<String, dynamic> json) {
    return Workday(
        id: json['id'],
        created: json['created'] != null
            ? DateTime.parse(json['created'].toString())
            : null,
        clock_in_start: json['clock_in_start'] != null
            ? DateTime.parse(json['clock_in_start'].toString())
            : null,
        clock_in_end: json['clock_in_end'] != null
            ? DateTime.parse(json['clock_in_end'].toString())
            : null,
        clock_out_end: json['clock_out_end'] != null
            ? DateTime.parse(json['clock_out_end'].toString())
            : null);
  }
}
