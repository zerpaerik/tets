import 'dart:io';
import 'package:flutter/foundation.dart';

class Offer with ChangeNotifier {
  // ignore: non_constant_identifier_names
  final bool is_accepted;
  // ignore: non_constant_identifier_names
  final bool accepted_contracting_conditions;
  // ignore: non_constant_identifier_names
  final bool arrives_on_his_own;
  // ignore: non_constant_identifier_names
  final String departure_location;
  final int country;
  final int state;
  final int city;
  final String address;
  // ignore: non_constant_identifier_names
  final bool wants_to_be_driver;
  final File signature;

  Offer({
    // ignore: non_constant_identifier_names
    this.is_accepted,
    // ignore: non_constant_identifier_names
    this.accepted_contracting_conditions,
    // ignore: non_constant_identifier_names
    this.arrives_on_his_own,
    // ignore: non_constant_identifier_names
    this.departure_location,
    this.country,
    this.state,
    this.city,
    this.address,
    // ignore: non_constant_identifier_names
    this.wants_to_be_driver,
    this.signature,
  });
}
