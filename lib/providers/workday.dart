import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:worker/model/workday_register.dart';

import '../widgets/global.dart';
import '../model/workday.dart';
import '../model/clock.dart';

class WorkDay with ChangeNotifier {
  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    //Return String
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  getContract() async {
    SharedPreferences contract = await SharedPreferences.getInstance();
    //Return String
    int intValue = contract.getInt('intValue');
    return intValue;
  }

  getWorkDay() async {
    SharedPreferences workday = await SharedPreferences.getInstance();
    //Return String
    int intValue = workday.getInt('intValue');
    return intValue;
  }

  getUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    //Return String
    int intValue = user.getInt('intValue');
    return intValue;
  }

  Future<dynamic> addWorkday() async {
    print('llego pv wkd');
    int _contract;
    _contract = await getContract();
    String token = await getToken();
    final url = ApiWebServer.API_CREATE_WORKDAY;
    try {
      final response = await http.post(url,
          body: json.encode({
            'contract': '1',
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      //final responseData = json.decode(response.body);
      notifyListeners();
      final responseData = json.decode(response.body);
      print(responseData);
      int _wk = responseData['id'];
      String _hk = responseData['clock_in_start'];

      SharedPreferences workday = await SharedPreferences.getInstance();
      workday.setInt('intValue', _wk != null ? _wk : null);

      SharedPreferences hworkday = await SharedPreferences.getInstance();
      hworkday.setString('stringValue', _hk);

      return response.statusCode.toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> addClockIn(worker, time, geo, Workday wd) async {
    print('llego pv clockin');
    DateTime now = DateTime.now();
    int _workday = wd.id;
    String token = await getToken();

    print(time);
    final url =
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$_workday/workday-register/create';
    try {
      final response = await http.post(url,
          body: json.encode({
            'workday': _workday,
            'worker': worker,
            'clock_type': 'IN',
            'clock_datetime': time != null
                ? time.toIso8601String().toString()
                : wd.clock_in_start.toString(),
            'message': 'message',
            'geographical_coordinates': '0',
            'verified': true,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      //final responseData = json.decode(response.body);
      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);
      // print(responseData);
      notifyListeners();

      return response.statusCode.toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> addClockOut(worker, time, workday) async {
    print('llego pv clockout');
    DateTime now = DateTime.now();
    int _workday = workday;
    int _user = await getUser();
    String token = await getToken();
    print(_workday);
    print(now.toIso8601String());
    final url =
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$_workday/workday-register/create';
    try {
      final response = await http.post(url,
          body: json.encode({
            'workday': _workday,
            'worker': worker,
            'clock_type': 'OUT',
            'clock_datetime': now.toIso8601String(),
            'message': 'message',
            'geographical_coordinates': '0',
            'verified': true,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      //final responseData = json.decode(response.body);
      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);
      // print(responseData);
      notifyListeners();

      return Clocks.fromJson(responseData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> endClockIn(workday) async {
    print('llego pv en clock in');
    DateTime now = DateTime.now();
    int _user = await getUser();
    int _workday = workday;
    String token = await getToken();
    print(_user);
    final url =
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$_workday/update';
    try {
      final response = await http.patch(url,
          body: json.encode({
            'clock_in_finisher': '2',
            'clock_in_end': now.toIso8601String(),
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);
      // print(responseData);
      notifyListeners();

      return response.statusCode.toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> endClockOut(workday) async {
    print('llego pv end clockout');
    DateTime now = DateTime.now();
    int _workday = workday;
    String token = await getToken();
    int _user = await getUser();
    print(_workday);
    print(now.toIso8601String().toString());

    print(_user);
    final url =
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$_workday/update';
    try {
      final response = await http.patch(url,
          body: json.encode({
            'clock_out_finisher': '2',
            'clock_out_end': now.toIso8601String(),
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      //final responseData = json.decode(response.body);
      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);
      // print(responseData);
      notifyListeners();

      return response.statusCode.toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<Workday> fetchWorkDay() async {
    String token = await getToken();

    final response = await http.get(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/1/get-current',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
        });
    Map<String, dynamic> wdData = json.decode(response.body);
    if (response.statusCode == 200 && wdData.isNotEmpty) {
      return new Workday.fromJson(wdData);
    } else {
      return null;
    }
  }

  Future<dynamic> addWorkdayReport(
      workday,
      workday_entry_time,
      workday_departure_time,
      lunch_start_time,
      lunch_end_time,
      lunch_duration,
      // ignore: non_constant_identifier_names
      drivers_list,
      standby_start_time,
      standby_end_time,
      standby_duration,
      travel_start_time,
      travel_end_time,
      travel_duration,
      return_start_time,
      return_end_time,
      return_duration,
      comments,
      files) async {
    String lunch;
    String stand;
    String travel;
    String returnt;

    print('llego a pv create workday report');
    print(drivers_list);

    DateFormat format = DateFormat("hh:mm");
    if (lunch_duration != null) {
      lunch = '00:' + lunch_duration;
      print(lunch);
    }
    if (standby_duration != null) {
      stand = '00:' + standby_duration;
      print(stand);
    }
    if (travel_duration != null) {
      travel = '00:' + travel_duration;
      print(travel);
    }
    if (return_duration != null) {
      returnt = '00:' + return_duration;
      print(returnt);
    }
    print(workday_entry_time);

    try {
      final response = await http.post(
          'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/79/workday-report/create',
          body: json.encode({
            "workday": 79,
            "workday_entry_time": workday_entry_time != null
                ? workday_entry_time.toIso8601String()
                : '00:00',
            "workday_departure_time": workday_departure_time != null
                ? workday_departure_time.toIso8601String()
                : '00:00',
            "lunch_start_time": lunch_start_time != null
                ? lunch_start_time.toIso8601String()
                : '00:00',
            "lunch_end_time": lunch_end_time != null
                ? lunch_end_time.toIso8601String()
                : '00:00',
            "lunch_duration": lunch_duration != null ? lunch : '00:00',
            "standby_start_time": standby_start_time != null
                ? standby_start_time.toIso8601String()
                : '00:00',
            "standby_end_time": standby_end_time != null
                ? standby_end_time.toIso8601String()
                : '00:00',
            "standby_duration": standby_duration != null ? stand : '00:00',
            "travel_start_time": travel_start_time != null
                ? travel_start_time.toIso8601String()
                : '00:00',
            "travel_end_time": travel_end_time != null
                ? travel_end_time.toIso8601String()
                : '00:00',
            "travel_duration": travel_duration != null ? travel : '00:00',
            "return_start_time": return_start_time != null
                ? return_start_time.toIso8601String()
                : '00:00',
            "return_end_time": return_end_time != null
                ? return_end_time.toIso8601String()
                : '00:00',
            "return_duration": return_duration != null ? returnt : '00:00',
            "comments": comments != null ? comments : '0',
            "drivers_list": drivers_list != null ? drivers_list : []
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      //final responseData = json.decode(response.body);
      final responseData = json.decode(response.body);
      int w_report = responseData['workday'];
      print(responseData);
      print(response.statusCode);
      notifyListeners();

      return response.statusCode.toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> editWorkdayReport(
      workday,
      workday_entry_time,
      workday_departure_time,
      lunch_start_time,
      lunch_end_time,
      lunch_duration,
      // ignore: non_constant_identifier_names
      drivers_list,
      standby_start_time,
      standby_end_time,
      standby_duration,
      travel_start_time,
      travel_end_time,
      travel_duration,
      return_start_time,
      return_end_time,
      WorkdayRegister worday_register) async {
    String lunch;
    String stand;
    String travel;

    print('llego a pv edit workday report');
    print(workday);
    print(workday_departure_time);
    print(lunch_start_time);
    print(lunch_end_time);
    print(lunch_duration);
    print(standby_start_time);
    print(standby_end_time);
    print(standby_duration);
    print(travel_start_time);
    print(travel_end_time);
    print(travel_duration);

    DateFormat format = DateFormat("hh:mm");
    if (lunch_duration != null) {
      lunch = '00:' + lunch_duration;
      print(lunch);
    }
    if (standby_duration != null) {
      stand = '00:' + standby_duration;
      print(stand);
    }
    if (travel_duration != null) {
      travel = '00:' + travel_duration;
      print(travel);
    }

    print(worday_register);
    int report = worday_register.id;

    try {
      final response = await http.patch(
          'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$workday/workday-report/worker-report/update',
          body: json.encode([
            {
              "id": worday_register.id.toString(),
              "workday_entry_time": workday_entry_time != null
                  ? workday_entry_time.toIso8601String()
                  : worday_register.workday_entry_time.toIso8601String(),
              "workday_departure_time": workday_departure_time != null
                  ? workday_departure_time.toIso8601String()
                  : worday_register.workday_departure_time.toIso8601String(),
              "lunch_start_time": lunch_start_time != null
                  ? lunch_start_time.toIso8601String()
                  : worday_register.lunch_start_time.toIso8601String(),
              "lunch_end_time": lunch_end_time != null
                  ? lunch_end_time.toIso8601String()
                  : worday_register.lunch_end_time.toIso8601String(),
              "lunch_duration": lunch_duration != null
                  ? lunch
                  : worday_register.lunch_duration,
              "standby_start_time": standby_start_time != null
                  ? standby_start_time.toIso8601String()
                  : worday_register.standby_start_time.toIso8601String(),
              "standby_end_time": standby_end_time != null
                  ? standby_end_time.toIso8601String()
                  : worday_register.standby_end_time.toIso8601String(),
              "standby_duration": standby_duration != null
                  ? stand
                  : worday_register.standby_duration,
              "travel_start_time": travel_start_time != null
                  ? travel_start_time.toIso8601String()
                  : worday_register.travel_start_time.toIso8601String(),
              "travel_end_time": travel_end_time != null
                  ? travel_end_time.toIso8601String()
                  : worday_register.travel_end_time.toIso8601String(),
              "travel_duration": travel_duration != null
                  ? travel
                  : worday_register.travel_duration,
            }
          ]),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      //final responseData = json.decode(response.body);
      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);
      notifyListeners();

      return response.statusCode.toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> editWorkdayReportM(
      workday,
      workday_entry_time,
      workday_departure_time,
      lunch_start_time,
      lunch_end_time,
      lunch_duration,
      // ignore: non_constant_identifier_names
      drivers_list,
      standby_start_time,
      standby_end_time,
      standby_duration,
      travel_start_time,
      travel_end_time,
      travel_duration,
      return_start_time,
      return_end_time,
      workerT) async {
    print('llego a pv edit workday reportM');
    /*  print(workday_entry_time);
    print(workday_departure_time);
    print(lunch_start_time);
    print(lunch_end_time);
    print(lunch_duration);
    print(standby_start_time);
    print(standby_end_time);
    print(standby_duration);
    print(travel_start_time);
    print(travel_end_time);
    print(travel_duration);*/
    List<Map<String, dynamic>> dataS;
    dataS = [];

    workerT.asMap().forEach((i, value) {
      dataS.add({
        "id": value,
        "workday_entry_time": workday_entry_time != null
            ? workday_entry_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "workday_departure_time": workday_departure_time != null
            ? workday_departure_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "lunch_start_time": lunch_start_time != null
            ? lunch_start_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "lunch_end_time": lunch_end_time != null
            ? lunch_end_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "lunch_duration": "00:00",
        "standby_start_time": standby_start_time != null
            ? standby_start_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "standby_end_time": standby_end_time != null
            ? standby_end_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "standby_duration": "00:00",
        "travel_start_time": travel_start_time != null
            ? travel_start_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "travel_end_time": travel_end_time != null
            ? travel_end_time.toIso8601String()
            : "2020-09-03T21:01:36Z",
        "travel_duration": "00:00",
      });
    });

    print(dataS);

    try {
      final response = await http.patch(
          'http://emplooy.turpialdev.webfactional.com/api/v-1/workday/$workday/workday-report/worker-report/update',
          body: json.encode(dataS),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Token" + " " + "4ead92aa67e22337c35db38e019437eba1fe4ab5"
          });
      //final responseData = json.decode(response.body);
      final responseData = json.decode(response.body);
      print(responseData);
      print(response.statusCode);
      notifyListeners();

      return response.statusCode.toString();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
