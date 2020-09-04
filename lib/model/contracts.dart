import 'package:flutter/foundation.dart';

class Contracts with ChangeNotifier {
  final int id;
  // ignore: non_constant_identifier_names
  final String contract_description;
  final String country;
  final String state;
  final String city;
  // ignore: non_constant_identifier_names
  final String worker_hour_payment;
  // ignore: non_constant_identifier_names
  final String worker_extra_payment;
  // final Benefits benefits;
  // ignore: non_constant_identifier_names
  final String hiring_mode;
  // ignore: non_constant_identifier_names
  final int weekly_duration;
  // ignore: non_constant_identifier_names
  final DateTime start_date;
  // ignore: non_constant_identifier_names
  final String contracting_conditions;
  // ignore: non_constant_identifier_names
  final bool offers_food;
  // ignore: non_constant_identifier_names
  final bool offers_accommodation;
  // ignore: non_constant_identifier_names
  final bool home_to_work_commute;
  // ignore: non_constant_identifier_names
  final bool commute_to_work_city;

  Contracts({
    this.id,
    // ignore: non_constant_identifier_names
    this.contract_description,
    this.country,
    this.state,
    this.city,
    // ignore: non_constant_identifier_names
    this.worker_hour_payment,
    // ignore: non_constant_identifier_names
    this.worker_extra_payment,
    // this.benefits,
    // ignore: non_constant_identifier_names
    this.hiring_mode,
    // ignore: non_constant_identifier_names
    this.weekly_duration,
    // ignore: non_constant_identifier_names
    this.start_date,
    // ignore: non_constant_identifier_names
    this.contracting_conditions,
    // ignore: non_constant_identifier_names
    this.offers_food,
    // ignore: non_constant_identifier_names
    this.offers_accommodation,
    // ignore: non_constant_identifier_names
    this.home_to_work_commute,
    // ignore: non_constant_identifier_names
    this.commute_to_work_city,
  });

  factory Contracts.fromJson(Map<String, dynamic> json) {
    return Contracts(
      id: json['id'],
      contract_description: json['contract_description'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      worker_hour_payment: json['worker_hour_payment'],
      worker_extra_payment: json['worker_extra_payment'],
      // benefits: Benefits.fromJson(json['benefits']),
      hiring_mode: json['hiring_mode'],
      weekly_duration: json['weekly_duration'],
      start_date: json['start_date'] != null
          ? DateTime.parse(json['start_date'].toString())
          : null,
      contracting_conditions: json['verification_url'],
      offers_food: json['offers_food'],
      offers_accommodation: json['offers_accommodation'],
      home_to_work_commute: json['home_to_work_commute'],
      commute_to_work_city: json['commute_to_work_city'],
    );
  }
}
