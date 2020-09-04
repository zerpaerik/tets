import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:worker/model/certification_type.dart';

class Certification with ChangeNotifier {
  final int id;
  // ignore: non_constant_identifier_names
  final DateTime issuance_date;
  // ignore: non_constant_identifier_names
  final DateTime expiration_date;
  // ignore: non_constant_identifier_names
  final File file_upload;
  // ignore: non_constant_identifier_names
  final File frontal_img;
  // ignore: non_constant_identifier_names
  final File rear_img;
  // ignore: non_constant_identifier_names
  final String verification_url;
  // ignore: non_constant_identifier_names
  final String certification_level;
  // ignore: non_constant_identifier_names
  final CertificationType certification_type;

  Certification(
      {this.id,
      // ignore: non_constant_identifier_names
      this.issuance_date,
      // ignore: non_constant_identifier_names
      this.expiration_date,
      // ignore: non_constant_identifier_names
      this.file_upload,
      // ignore: non_constant_identifier_names
      this.frontal_img,
      // ignore: non_constant_identifier_names
      this.rear_img,
      // ignore: non_constant_identifier_names
      this.verification_url,
      // ignore: non_constant_identifier_names
      this.certification_level,
      // ignore: non_constant_identifier_names
      this.certification_type});

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'],
      issuance_date: json['issuance_date'] != null
          ? DateTime.parse(json['issuance_date'].toString())
          : null,
      expiration_date: json['expiration_date'] != null
          ? DateTime.parse(json['expiration_date'].toString())
          : null,
      verification_url: json['verification_url'],
      frontal_img:
          json['frontal_img'] != null ? new File(json['frontal_img']) : null,
      rear_img: json['rear_img'] != null ? new File(json['rear_img']) : null,
      certification_type:
          CertificationType.fromJson(json['certification_type']),
    );
  }
}
