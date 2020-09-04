import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class PushNotification {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<Map>.broadcast();
  Stream<Map> get message => _mensajesStreamController.stream;

  initNotificactions() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      // print(token);
      //fWFhVgm9U9k:APA91bFFP5VNyiung_5Z9jFBO88aBvEqqLqNpANmxF0t18Ony3enkLDUkgJ7y_o31caE1v6VTz_dDa2scUOG4FW4ptnlxx2oLnZ9qnb9jkthThv7keX0SanNnqaJ9a48yHmv_yZr3-UQ
    });

    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (info) {
        print('======= OnMessageEEEEEE ======');
        print(info);
        Map argument = {
          "id": "1",
          "name": info['data']['click_action'],
          "title": info['data']['title'],
          "body": info['data']['body'],
          "detail": json.decode(info['data']['message'])
        };

        //  argument = info['data']['message'] ?? {};
        print(argument);
        _mensajesStreamController.sink.add(argument);
      },
      // ignore: missing_return
      onResume: (info) {
        print('======= OnResume ======');
        print(info);
        Map argument = {
          "id": "1",
          "name": info['data']['click_action'],
          "title": info['data']['title'],
          "body": info['data']['body'],
          "detail": json.decode(info['data']['message'])
        };
        print(argument);
        _mensajesStreamController.sink.add(info['data']['comida']);
      },
      // ignore: missing_return
      onLaunch: (info) {
        print('======= OnLaunch ======');
        /*
        if(Platform.isAndroid){
          argument = info['data']['comida'] ?? 'no-data';
        }
        _mensajesStreamController.sink.add(argument);*/
      },
    );
  }

  dispose() {
    _mensajesStreamController?.close();
  }
}
