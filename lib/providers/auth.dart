import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';
import '../model/user.dart';
import '../widgets/global.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class Auth with ChangeNotifier {
  String _token;
  String _docType;
  String _docTypeN;
  String _type;
  int _userId;
  String _typeE;
  String _hi;
  String _ei;
  // ignore: unused_field
  String _he;
  // ignore: unused_field
  String _ee;
  Status _status = Status.Uninitialized;

  Status get status {
    return _status;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  int get user {
    return _userId;
  }

  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    //Return String
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  Future<dynamic> uploadFile(User user, image, imagef, imager) async {
    print(user.expiration_date_no);
    print(user.uscis_number);
    print(user.doc_type_no);

    // print(_userId);
    // DATA CAST
    if (user.id_type == 'SSN') {
      _type = '1';
    } else {
      _type = '2';
    }
    if (user.doc_type == 'Licencia de Conducir') {
      _docType = '2';
    }
    if (user.doc_type == 'Pasaporte') {
      _docType = '1';
    }
    if (user.doc_type == 'State ID') {
      _docType = '3';
    }

    if (user.doc_type_no == 'Tarjeta de Residencia') {
      _docTypeN = '2';
    }
    if (user.doc_type_no == 'Permiso de Trabajo') {
      _docTypeN = '1';
    }
    if (user.doc_type_no == 'Comprobante de Solicitud de documento') {
      _docTypeN = '3';
    }
    //
    DateFormat format = DateFormat("yyyy-MM-dd"); // FORMAT DATE
    var postUri =
        Uri.parse(ApiWebServer.API_UPDATE_USER + '/' + '$_userId' + '/');
    var request = new http.MultipartRequest("PATCH", postUri);
    request.fields['country'] = user.country.toString();
    request.fields['state'] = user.state.toString();
    request.fields['city'] = user.city.toString();
    request.fields['zip_code'] = user.zip_code;
    request.fields['phone_number'] = user.phone_number;
    request.fields['address_1'] = user.address_1;
    request.fields['address_2'] =
        user.address_2 != null ? user.address_2 : 'NULL';
    request.fields['is_us_citizen'] = user.is_us_citizen.toString();
    request.fields['id_type'] = _type != null ? _type : '2';
    request.fields['id_number'] = user.id_number != null ? user.id_number : '0';
    request.fields['doc_type'] = _docType != null ? _docType : '3';
    request.fields['doc_number'] =
        user.doc_number != null ? user.doc_number : '0';
    request.fields['doc_expire_date'] = user.doc_expire_date != null
        ? format.format(user.doc_expire_date)
        : '2222-01-01';
    request.files.add(await http.MultipartFile.fromPath(
        'doc_image', image != null ? image.path : imagef.path));
    request.files.add(await http.MultipartFile.fromPath(
        'signature', image != null ? image.path : imagef.path));
    request.fields['doc_type_no'] = _docTypeN != null ? _docTypeN : '1';
    request.fields['expiration_date_no'] = user.expiration_date_no != null
        ? format.format(user.expiration_date_no)
        : '2222-01-01';
    request.fields['uscis_number'] =
        user.uscis_number != null ? user.uscis_number : '0';
    request.files.add(await http.MultipartFile.fromPath(
        'front_image_no', imagef != null ? imagef.path : image.path));
    request.files.add(await http.MultipartFile.fromPath(
        'rear_image_no', imager != null ? imager.path : image.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print('upload');
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
    }
  }

  Future<dynamic> updateAddress(adress) async {
    var postUri =
        Uri.parse(ApiWebServer.API_UPDATE_USER + '/' + '$_userId' + '/');
    var request = new http.MultipartRequest("PATCH", postUri);
    request.fields['address_1'] = adress;
    print(request.fields);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('upload address');
    } else {
      print(request.fields);
      print(response.toString());
    }
  }

  Future<dynamic> updatePart2(User user, image) async {
    // DATA CAST
    if (user.marital_status == 1) {
      _docType = '1';
    }
    if (user.marital_status == 2) {
      _docType = '2';
    }
    if (user.marital_status == 3) {
      _docType = '3';
    }
    if (user.marital_status == 4) {
      _docType = '4';
    }
    var postUri =
        Uri.parse(ApiWebServer.API_UPDATE_USER + '/' + '$_userId' + '/');
    var request = new http.MultipartRequest("PATCH", postUri);
    request.fields['dependents_number'] = user.dependents_number;
    request.fields['marital_status'] = _docType;
    request.fields['contact_first_name'] = user.contact_first_name;
    request.fields['contact_last_name'] = user.contact_last_name;
    request.fields['contact_phone'] = user.contact_phone;
    request.fields['contact_email'] = user.contact_email;
    request.fields['blood_type'] = user.blood_type.toString();
    request.fields['rh_factor'] = '1';
    // request.files.add(await http.MultipartFile.fromPath('signature', image.path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print('upload2');
      return json.decode(response.body);
    } else {
      print('error');
    }
  }

  Future<dynamic> updatePart3(image) async {
    var postUri =
        Uri.parse(ApiWebServer.API_UPDATE_USER + '/' + '$_userId' + '/');
    var request = new http.MultipartRequest("PATCH", postUri);
    request.files
        .add(await http.MultipartFile.fromPath('profile_image', image.path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print('uploadvimage');
      return json.decode(response.body);
    } else {
      print('error');
    }
  }

  Future<dynamic> _authenticate(String email, String password) async {
    _status = Status.Authenticating;
    notifyListeners();
    final url = ApiWebServer.API_AUTH_LOGIN;
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'username': email,
            'password': password,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );
      // print(json.decode(response.body));
      final responseData = json.decode(response.body);
      _token = responseData['token'];
      _userId = responseData['user_id'];

      SharedPreferences token = await SharedPreferences.getInstance();
      token.setString('stringValue', _token);

      print(responseData);
      if (responseData['non_field_errors'] != null) {
        throw HttpException(responseData['non_field_errors'][0]);
      }
      _status = Status.Authenticated;
      notifyListeners();
      return responseData;
    } catch (non_field_errors) {
      print(non_field_errors);
      _status = Status.Unauthenticated;
      notifyListeners();
      throw non_field_errors;
    }
  }

  Future<dynamic> login(String email, String password) async {
    return _authenticate(email, password);
  }

  void logout() {
    const url = ApiWebServer.API_AUTH_LOGOUT;
    // ignore: unused_local_variable
    final response = http.post(url,
        body: json.encode(
          {
            'id': _userId,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });
    _token = '';
    _userId = null;
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  // ignore: missing_return
  Future<Auth> verifyEmail(email) async {
    try {
      final response = await http
          .get(ApiWebServer.API_GET_VERIFY_EMAIL + '/' + '$email' + '/');
      if (response.statusCode == 200) {
        _userId = json.decode(response.body);
        throw HttpException('200');
      }
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

  // ignore: missing_return
  Future<Auth> verifyCode(code) async {
    try {
      final response = await http
          .get(ApiWebServer.API_GET_VERIFY_CODE + '/' + '$code' + '/');
      if (response.statusCode == 200) {
        throw HttpException('200');
      }
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

  Future<void> changePassword(passwd1, passwd2) async {
    notifyListeners();
    final url = await http
        .get(ApiWebServer.API_AUTH_CHANGE_PASSWORD + '/' + '$_userId' + '/');
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'password1': passwd1,
            'password2': passwd1,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        throw HttpException('200');
      }
      notifyListeners();
    } catch (error) {
      print(error);
      notifyListeners();
      throw error;
    }
  }

  Future<dynamic> verifiedN(id) async {
    String token = await getToken();
    DateTime now = DateTime.now();

    try {
      final response = await http.patch(
          ApiWebServer.API_PATCH_VERIFIED_NOTIF +
              '/' +
              '$id' +
              '/change_status/',
          body: json.encode(
            {'verification_date': now.toIso8601String()},
          ),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Token" + " " + "$token"
          });

      print(response.body);
      print(response.statusCode);

      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }

  Future<User> fetchUser() async {
    final response =
        await http.get(ApiWebServer.API_GET_USER + '/' + '$_userId' + '/');
    Map<String, dynamic> userData = json.decode(response.body);
    if (response.statusCode == 200 && userData.isNotEmpty) {
      return new User.fromJson(userData);
    } else {
      return null;
    }
  }

  Future<void> updatePartAdic(User user) async {
    // DATA CAST
    if (user.english_mastery == 'Nativo') {
      _type = '1';
    } else {
      _type = '2';
    }
    if (user.spanish_mastery == 'Nativo') {
      _typeE = '1';
    } else {
      _typeE = '2';
    }
    if (user.english_learning_level == 'Basico') {
      _hi = '1';
    }
    if (user.english_learning_level == 'Medio') {
      _hi = '2';
    }
    if (user.english_learning_level == 'Avanzado') {
      _hi = '3';
    }
    if (user.english_learning_method == 'Basico') {
      _ei = '1';
    }
    if (user.english_learning_method == 'Medio') {
      _ei = '2';
    }
    if (user.english_learning_method == 'Avanzado') {
      _ei = '3';
    }
    //esp
    if (user.spanish_learning_level == 'Basico') {
      _he = '1';
    }
    if (user.spanish_learning_level == 'Medio') {
      _he = '2';
    }
    if (user.spanish_learning_level == 'Avanzado') {
      _he = '3';
    }
    if (user.spanish_learning_method == 'Basico') {
      _ee = '1';
    }
    if (user.spanish_learning_method == 'Medio') {
      _ee = '2';
    }
    if (user.spanish_learning_method == 'Avanzado') {
      _ee = '3';
    }

    var postUri =
        Uri.parse(ApiWebServer.API_UPDATE_USER + '/' + '$_userId' + '/');
    var request = new http.MultipartRequest("PATCH", postUri);
    request.fields['degree_levels'] = user.degree_levels;
    request.fields['speciality_or_degree'] = user.speciality_or_degree;
    request.fields['english_mastery'] = _type;
    request.fields['english_learning_level'] = _hi;
    request.fields['english_learning_method'] = _ei;
    request.fields['spanish_mastery'] = _typeE;
    //request.fields['spanish_learning_level'] = _he;
    //request.fields['spanish_learning_method'] = _ee;
    //request.files.add(await http.MultipartFile.fromPath('cv_file', cv.path));

    request.send().then((response) {
      if (response.statusCode == 200)
        print('upload cv');
      else
        // print(user.doc_expire_date);
        print(request.fields);
      print(response.toString());
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    });
  }
}
