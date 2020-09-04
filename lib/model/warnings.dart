import 'package:flutter/foundation.dart';

class Warnings with ChangeNotifier {
  final String explanatory_text;
  // ignore: non_constant_identifier_names
  final String description;
  final DateTime occurrence_date;
  final String warning_type;
  final String contract;
  final String reason;

  Warnings({
    this.explanatory_text,
    // ignore: non_constant_identifier_names
    this.description,
    this.occurrence_date,
    this.warning_type,
    this.contract,
    this.reason,
  });

  factory Warnings.fromJson(Map<String, dynamic> json) {
    return Warnings(
      explanatory_text: json['explanatory_text'],
      description: json['description'],
      occurrence_date: json['occurrence_date'] != null
          ? DateTime.parse(json['occurrence_date'].toString())
          : null,
      warning_type: json['warning_type'],
      contract: json['contract'],
      reason: json['reason'],
    );
  }
}
