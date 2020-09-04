import 'package:worker/providers/auth.dart';
import 'package:worker/providers/certifications.dart';
import 'package:worker/providers/offer_job.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/users.dart';
import './providers/auth.dart';
import './widgets/lang/aplication.dart';
import './widgets/lang/app_translations_delegate.dart';
import './widgets/widgets.dart';
import './model/user.dart';

void main() {
  //AppTranslationsDelegate _newLocaleDelegate;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    /*  supportedLocales: [
            const Locale("en", ""),
            const Locale("hi", ""),
          ],
          localizationsDelegates: [
            _newLocaleDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],*/
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  AppTranslationsDelegate _newLocaleDelegate;
  var jsonData;
  User userModel;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
    /*  final pushProviderNotific = new PushNotification();
    pushProviderNotific.initNotificactions();
    pushProviderNotific.message.listen((msg) {
      navigatorKey.currentState.pushNamed('notifications', arguments: msg);
      /* Navigator.push(context,
          MaterialPageRoute(builder: (context) => ListNotifications(arg: msg,)));*/
    });*/
  }

  @override
  Widget build(BuildContext context) {
    // var myProvider = Provider.of<Auth>(context, listen: false).logout();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Users(),
        ),
        ChangeNotifierProvider.value(
          value: Certifications(),
        ),
        ChangeNotifierProvider.value(
          value: OfferJob(),
        ),
      ],
      child: MaterialApp(
          localizationsDelegates: [
            _newLocaleDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale("en", ""),
            const Locale("hi", ""),
          ],
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepOrange,
            fontFamily: 'OpenSans-Regular',
          ),
          home: SelectLang(),
          routes: {
            RegisterUser.routeName: (ctx) => RegisterUser(),
            Login.routeName: (ctx) => Login(),
            ProfilePartOblig.routeName: (ctx) => ProfilePartOblig(),
            DashboardHome.routeName: (ctx) => DashboardHome(),
            // ignore: missing_required_param
            MyProfile.routeName: (ctx) => MyProfile(),
            ProfilePartOblig2.routeName: (ctx) => ProfilePartOblig2(),
            ProfilePartPicture.routeName: (ctx) => ProfilePartPicture(),
            PreviewComplete.routeName: (ctx) => PreviewComplete(),
            // ListNotifications.routeName: (ctx) => ListNotifications(),
            //'notifications': (context) => ListNotifications(),

            // ProfilePartAdic.routeName: (ctx) => ProfilePartAdic()
          }),
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
