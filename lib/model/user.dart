import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final int id;
  // ignore: non_constant_identifier_names
  final String first_name;
  final String email;
  // ignore: non_constant_identifier_names
  final DateTime birth_date;
  // ignore: non_constant_identifier_names
  final String last_name;
  final String password1;
  final String password2;
  final String gender;
  final int country;
  final int state;
  final int city;
  final String address_1;
  final String address_2;
  // ignore: non_constant_identifier_names
  final bool is_us_citizen; // IS AMERICAN
  // ignore: non_constant_identifier_names
  final String id_type; //SSN - ITIN
  // ignore: non_constant_identifier_names
  final String id_number;
  // ignore: non_constant_identifier_names
  final String doc_type; // PAS -LIC - STATE ID
  // ignore: non_constant_identifier_names
  final String doc_number; // NUM PAS-LIC-STATEID
  // ignore: non_constant_identifier_names
  final File doc_image;
  // ignore: non_constant_identifier_names
  final DateTime doc_expire_date;
  // ignore: non_constant_identifier_names
  final String dependents_number;
  // ignore: non_constant_identifier_names
  final int marital_status;
  final File signature;
  // ignore: non_constant_identifier_names
  final String contact_first_name;
  // ignore: non_constant_identifier_names
  final String contact_last_name;
  // ignore: non_constant_identifier_names
  final String contact_phone;
  // ignore: non_constant_identifier_names
  final String contact_email;
  // ignore: non_constant_identifier_names
  final int blood_type;
  // ignore: non_constant_identifier_names
  final int rh_factor;
  // ignore: non_constant_identifier_names
  final String phone_number;
  // ignore: non_constant_identifier_names
  final String zip_code;
  // ignore: non_constant_identifier_names
  final File profile_image;
  // ignore: non_constant_identifier_names
  final String degree_levels;
  // ignore: non_constant_identifier_names
  final String speciality_or_degree;
  // ignore: non_constant_identifier_names
  final String english_mastery;
  // ignore: non_constant_identifier_names
  final String english_learning_method;
  // ignore: non_constant_identifier_names
  final String english_learning_level;
  // ignore: non_constant_identifier_names
  final String spanish_mastery;
  // ignore: non_constant_identifier_names
  final String spanish_learning_method;
  // ignore: non_constant_identifier_names
  final String spanish_learning_level;
  // ignore: non_constant_identifier_names
  final String expertise_area;
  // ignore: non_constant_identifier_names
  final File cv_file;
  // ignore: non_constant_identifier_names
  final String btn_id;
  // ignore: non_constant_identifier_names
  final String referral_code;

  // ignore: non_constant_identifier_names
  final String doc_type_no;
  // ignore: non_constant_identifier_names
  final DateTime expiration_date_no;
  // ignore: non_constant_identifier_names
  final File front_image_no;
  // ignore: non_constant_identifier_names
  final File rear_image_no;
  // ignore: non_constant_identifier_names
  final File i94_form_image;
  // ignore: non_constant_identifier_names
  final String uscis_number;
  final String birthplace;

  User(
      {this.id,
      // ignore: non_constant_identifier_names
      this.first_name,
      this.email,
      // ignore: non_constant_identifier_names
      this.birth_date,
      // ignore: non_constant_identifier_names
      this.last_name,
      this.password1,
      this.password2,
      this.gender,
      this.country,
      this.state,
      this.city,
      this.address_1,
      this.address_2,
      // ignore: non_constant_identifier_names
      this.is_us_citizen,
      // ignore: non_constant_identifier_names
      this.id_type,
      // ignore: non_constant_identifier_names
      this.id_number,
      // ignore: non_constant_identifier_names
      this.doc_type,
      // ignore: non_constant_identifier_names
      this.doc_expire_date,
      // ignore: non_constant_identifier_names
      this.doc_image,
      // ignore: non_constant_identifier_names
      this.doc_number,
      // ignore: non_constant_identifier_names
      this.dependents_number,
      // ignore: non_constant_identifier_names
      this.contact_first_name,
      // ignore: non_constant_identifier_names
      this.contact_last_name,
      // ignore: non_constant_identifier_names
      this.contact_phone,
      // ignore: non_constant_identifier_names
      this.contact_email,
      this.signature,
      // ignore: non_constant_identifier_names
      this.marital_status,
      // ignore: non_constant_identifier_names
      this.blood_type,
      // ignore: non_constant_identifier_names
      this.rh_factor,
      // ignore: non_constant_identifier_names
      this.phone_number,
      // ignore: non_constant_identifier_names
      this.zip_code,
      // ignore: non_constant_identifier_names
      this.profile_image,
      // ignore: non_constant_identifier_names
      this.degree_levels,
      // ignore: non_constant_identifier_names
      this.speciality_or_degree,
      // ignore: non_constant_identifier_names
      this.english_learning_method,
      // ignore: non_constant_identifier_names
      this.english_learning_level,
      // ignore: non_constant_identifier_names
      this.english_mastery,
      // ignore: non_constant_identifier_names
      this.spanish_mastery,
      // ignore: non_constant_identifier_names
      this.spanish_learning_method,
      // ignore: non_constant_identifier_names
      this.spanish_learning_level,
      // ignore: non_constant_identifier_names
      this.expertise_area,
      // ignore: non_constant_identifier_names
      this.cv_file,
      // ignore: non_constant_identifier_names
      this.btn_id,
      // ignore: non_constant_identifier_names
      this.referral_code,
      // ignore: non_constant_identifier_names
      this.doc_type_no,
      // ignore: non_constant_identifier_names
      this.expiration_date_no,
      // ignore: non_constant_identifier_names
      this.front_image_no,
      // ignore: non_constant_identifier_names
      this.rear_image_no,
      // ignore: non_constant_identifier_names
      this.i94_form_image,
      // ignore: non_constant_identifier_names
      this.uscis_number,
      this.birthplace});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      profile_image: new File(json['profile_image']),
      country: json['country'],
      state: json['state'],
      city: json['city'],
      // birth_date: new DateTime(json['birth_date']),
      gender: json['gender'],
      zip_code: json['zip_code'],
      address_1: json['address_1'],
      address_2: json['address_2'],
      id_type: json['id_type'],
      id_number: json['id_number'],
      doc_type: json['doc_type'],
      doc_number: json['doc_number'],
      doc_image: new File(json['doc_image']),
      contact_first_name: json['contact_first_name'],
      contact_last_name: json['contact_last_name'],
      contact_phone: json['contact_phone'],
      contact_email: json['contact_email'],
      btn_id: json['btn_id'],
      degree_levels: json['degree_levels'],
      speciality_or_degree: json['speciality_or_degree'],
      referral_code: json['referral_code'],
    );
  }

  factory User.fromJson1(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      btn_id: json['btn_id'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, first_name: $first_name, email: $email, birth_date: $birth_date, last_name: $last_name, password1: $password1, password2: $password2, gender: $gender, country: $country, state: $state, city: $city, address_1: $address_1, address_2: $address_2, is_us_citizen: $is_us_citizen, id_type: $id_type, id_number: $id_number, doc_type: $doc_type, doc_number: $doc_number, doc_image: $doc_image, doc_expire_date: $doc_expire_date, dependents_number: $dependents_number, marital_status: $marital_status, signature: $signature, contact_first_name: $contact_first_name, contact_last_name: $contact_last_name, contact_phone: $contact_phone, contact_email: $contact_email, blood_type: $blood_type, rh_factor: $rh_factor, phone_number: $phone_number, zip_code: $zip_code)';
  }
}
