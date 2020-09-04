import 'package:flutter/foundation.dart';

class WorkdayRegister with ChangeNotifier {
  final int id;
  final String btn_id;
  final String first_name;
  final String last_name;
  final DateTime clock_in;
  final DateTime workday_entry_time;
  final DateTime clock_out;
  final DateTime workday_departure_time;
  final DateTime lunch_start_time;
  final DateTime lunch_end_time;
  final String lunch_duration;
  final DateTime standby_start_time;
  final DateTime standby_end_time;
  final String standby_duration;
  final DateTime travel_start_time;
  final DateTime travel_end_time;
  final String travel_duration;
  final bool was_driver;
  final bool was_lead;
  final String comments;
  // ignore: non_constant_identifier_names

  WorkdayRegister(
      {this.id,
      this.btn_id,
      this.first_name,
      this.last_name,
      this.clock_in,
      this.workday_entry_time,
      this.clock_out,
      this.workday_departure_time,
      this.lunch_start_time,
      this.lunch_end_time,
      this.lunch_duration,
      this.standby_start_time,
      this.standby_end_time,
      this.standby_duration,
      this.travel_start_time,
      this.travel_end_time,
      this.travel_duration,
      this.was_driver,
      this.was_lead,
      this.comments});

  factory WorkdayRegister.fromJson(Map<String, dynamic> json) {
    return WorkdayRegister(
      id: json['id'],
      btn_id: json['btn_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      clock_in: json['clock_in'] != null
          ? DateTime.parse(json['clock_in'].toString())
          : null,
      workday_entry_time: json['workday_entry_time'] != null
          ? DateTime.parse(json['workday_entry_time'].toString())
          : null,
      clock_out: json['clock_out'] != null
          ? DateTime.parse(json['clock_out'].toString())
          : null,
      workday_departure_time: json['workday_departure_time'] != null
          ? DateTime.parse(json['workday_departure_time'].toString())
          : null,
      lunch_start_time: json['lunch_start_time'] != null
          ? DateTime.parse(json['lunch_start_time'].toString())
          : null,
      lunch_end_time: json['lunch_end_time'] != null
          ? DateTime.parse(json['lunch_end_time'].toString())
          : null,
      lunch_duration: json['lunch_duration'],
      standby_start_time: json['standby_start_time'] != null
          ? DateTime.parse(json['standby_start_time'].toString())
          : null,
      standby_end_time: json['standby_end_time'] != null
          ? DateTime.parse(json['standby_end_time'].toString())
          : null,
      standby_duration: json['standby_duration'],
      travel_start_time: json['travel_start_time'] != null
          ? DateTime.parse(json['travel_start_time'].toString())
          : null,
      travel_end_time: json['travel_end_time'] != null
          ? DateTime.parse(json['travel_end_time'].toString())
          : null,
      travel_duration: json['travel_duration'],
      was_driver: json['was_driver'],
      was_lead: json['was_lead'],
      comments: json['comments'],
    );
  }
}
