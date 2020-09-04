import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../lang/app_translations.dart';
import '../lang/aplication.dart';
import '../widgets.dart';

class SelectLang extends StatefulWidget {
  @override
  _SelectLangState createState() => new _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String label = languagesList[0];
  double maxtop;

  @override
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    onLocaleChange(Locale(languagesMap["Español"]));
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  Future<void> select(String language) async {
    print("dd " + language);
    onLocaleChange(Locale(languagesMap[language]));
    setState(() {
      if (language == "Español") {
        label = "Español";
      } else {
        label = language;
      }
    });

    SharedPreferences lang = await SharedPreferences.getInstance();
    lang.setString('stringValue', label);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String _titleH = AppTranslations.of(context).text("select_lang");
    SizeConfig().init(context);
    var screenSize = MediaQuery.of(context).size;
    if (screenSize.height > 800) {
      maxtop = 80;
    } else {
      maxtop = 40;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFF167F67),
      ),
      home: new Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          body: Container(
            height: SizeConfig.blockSizeVertical * 160,
            width: SizeConfig.blockSizeHorizontal * 100,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: maxtop),
                        child: Container(
                          // margin: EdgeInsets.only(top: 40.0),
                          child: Image.asset(
                            "assets/emplooy.png",
                            width: 300,
                            height: 300,
                          ),
                        )),
                    // SizedBox(height: 10),
                    Container(
                      margin:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 1.0),
                      padding: EdgeInsets.symmetric(vertical: 1.0),
                      width: double.infinity,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Hexcolor('EA6012')),
                        onPressed: () => select("English"),
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          'English',
                          style: TextStyle(
                            color: Hexcolor('EA6012'),
                            letterSpacing: 1,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans-Regular',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Hexcolor('EA6012')),
                        onPressed: () => select("Español"),
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          'Español',
                          style: TextStyle(
                            color: Hexcolor('EA6012'),
                            letterSpacing: 1,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans-Regular',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
