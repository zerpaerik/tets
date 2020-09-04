import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/offer.dart';

class OfferJob with ChangeNotifier {
  getToken() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    //Return String
    String stringValue = token.getString('stringValue');
    return stringValue;
  }

  Future<dynamic> applyOffer(Offer offer, id, o) async {
    print(o);
    String token = await getToken();
    var postUri = Uri.parse(
        'http://emplooy.turpialdev.webfactional.com/api/v-1/contract/joboffer/apply/$id');

    Map<String, String> headers = {
      "Authorization": "Token" + " " + "$token"
    }; // FORMAT DATE
    var request = new http.MultipartRequest("PATCH", postUri);
    request.headers.addAll(headers);
    request.fields['is_accepted'] = offer.is_accepted.toString();
    request.fields['accepted_contracting_conditions'] =
        offer.accepted_contracting_conditions.toString();
    request.fields['arrives_on_his_own'] = offer.arrives_on_his_own.toString();
    request.fields['departure_location'] = '1';
    request.fields['country'] =
        offer.country.toString() != null ? offer.country.toString() : null;
    request.fields['state'] =
        offer.state.toString() != null ? offer.state.toString() : null;
    request.fields['city'] =
        offer.city.toString() != null ? offer.city.toString() : null;
    request.fields['address'] = offer.address;
    request.fields['wants_to_be_driver'] = offer.wants_to_be_driver.toString();
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print('finoooo');
      return json.decode(response.body);
    } else {
      print('error');
      print(request.fields);
      print(response.statusCode);
      print(response.body);
    }
  }
}
