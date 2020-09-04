import 'dart:io';
import 'package:signature/signature.dart';
import 'package:worker/model/offer.dart';
import 'package:worker/providers/offer_job.dart';
import 'package:worker/widgets/dashboard/index.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
//
import 'dart:async';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
//
import '../../../model/user.dart';
import '../../../model/country.dart';
import '../../../model/states.dart';
import '../../../model/city.dart';
import '../../../providers/offer_job.dart';
import '../../widgets.dart';

class PostulationPage extends StatefulWidget {
  static const routeName = '/postulation';
  final User user;
  final String offer;

  PostulationPage({@required this.user, @required this.offer});

  @override
  _PostulationPageState createState() => _PostulationPageState(user, offer);
}

class _PostulationPageState extends State<PostulationPage> {
  User user;
  String offer;
  _PostulationPageState(this.user, this.offer);
  bool address = false;
  bool sign = false;
  // ignore: non_constant_identifier_names
  bool other_meeting = false;
  String _valEdo;
  bool edo = false;
  String _valMeeting;
  String _valCond;
  bool meetingV = false;
  String _valAdd2;
  List _listAdd2 = ['Agregar'];
  List _listEdo = ['Si', 'No'];
  List meeting = List();
  // ignore: unused_field
  List _listCountry = ["EEUU", 'Mexico'];
  // ignore: unused_field
  List _listState = ['Florida', 'Houston'];
  // ignore: unused_field
  List _listCity = ['Manhattan', 'BeverlyHills'];
  final _form = GlobalKey<FormState>();
  GlobalKey<_PostulationPageState> signatureKey = GlobalKey();
  static const directoryName = 'Signature';
  var image;
  var _isLoading = false;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.blue,
  );
  var _dateOffer = Offer(
      is_accepted: null,
      accepted_contracting_conditions: null,
      arrives_on_his_own: null,
      departure_location: '',
      country: null,
      state: null,
      city: null,
      address: '',
      wants_to_be_driver: null,
      signature: null);

  // LIST COUNTRYS
  List<Country> _countrys = Country.getCountrys();
  List<DropdownMenuItem<Country>> _dropdownMenuItemsC;
  Country _selectedCountry;

  // LIST STATES
  List<States> _states = States.getStates();
  List<DropdownMenuItem<States>> _dropdownMenuItemsS;
  States _selectedState;

  // LIST CITYS
  List<City> _citys = City.getCitys();
  List<DropdownMenuItem<City>> _dropdownMenuItemsCI;
  City _selectedCity;

  int _selectedIndex = 4;

  // ITEMS DROPDOWN COUNTRY

  List<DropdownMenuItem<Country>> buildDropdownMenuItems(List countrys) {
    List<DropdownMenuItem<Country>> items = List();
    for (Country country in countrys) {
      items.add(
        DropdownMenuItem(
          value: country,
          child: Text(country.name),
        ),
      );
    }
    return items;
  }

  // ITEMS DROPDOWN STATE

  List<DropdownMenuItem<States>> buildDropdownMenuItemsS(List states) {
    List<DropdownMenuItem<States>> items = List();
    for (States state in states) {
      items.add(
        DropdownMenuItem(
          value: state,
          child: Text(state.name),
        ),
      );
    }
    return items;
  }

  // ITEMS DROPDOWN CITY

  List<DropdownMenuItem<City>> buildDropdownMenuItemsC(List citys) {
    List<DropdownMenuItem<City>> items = List();
    for (City city in citys) {
      items.add(
        DropdownMenuItem(
          value: city,
          child: Text(city.name),
        ),
      );
    }
    return items;
  }

  void _showQr() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Scaffold(
            body: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Image.asset(
                  'assets/emplooy.png',
                  width: 130,
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, top: 10, right: 30),
                  child: ClipOval(
                    child: Image.network(
                      user.profile_image.path,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  width: 285,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                  child: Card(
                    elevation: 6,
                    child: Column(children: <Widget>[
                      SizedBox(height: 20),
                      Text(user.first_name + ' ' + user.last_name,
                          style: TextStyle(
                              color: Hexcolor('233062'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text('EMPLOOY' + ' ' + user.btn_id,
                          style: TextStyle(
                              color: Hexcolor('9c9c9c'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      //SizedBox(height:30),
                      QrImage(
                        data: user.btn_id,
                        gapless: true,
                        size: 260,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      )
                    ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 40.0, right: 40.0),
                  width: double.infinity,
                  child: RaisedButton(
                    elevation: 5.0,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                      Navigator.of(ctx).pop();
                    },
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.green[700],
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
          );
        });
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<OfferJob>(context, listen: false)
          .applyOffer(_dateOffer, offer, _controller.toString())
          .then((response) {
        setState(() {
          _isLoading = false;
          // ignore: unused_local_variable
          String offer = response['id'].toString();
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailJobOfferPage(user: this.widget.user, offer: offer)),
        );
      });
    } catch (error) {}
    /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePartOblig2()),
          );*/
  }

  _onTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardHome()),
        );
        break;
      case 1:
        break;
      case 2:
        _showQr();
        break;
      case 4:
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showInputSignature() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Scaffold(
              body: SingleChildScrollView(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text('Firma con el dedo',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Hexcolor('EA6012'),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Hexcolor('EA6012')),
                    borderRadius: BorderRadius.circular(5)),
                child: Signature(
                  key: signatureKey,
                  controller: _controller,
                  height: 400,
                  width: 600,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    setState(() {
                      sign = true;
                      //_valName = _valName;
                      //_valFirstName = _valFirstName;
                    });

                    Navigator.of(ctx).pop();
                  },
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.green[700],
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0, right: 40.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Hexcolor('EA6012'),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          )));
        });
  }

  @override
  void initState() {
    _controller.addListener(() => print("Value changed"));
    _dropdownMenuItemsC = buildDropdownMenuItems(_countrys);
    _selectedCountry = _dropdownMenuItemsC[0].value;
    _dropdownMenuItemsS = buildDropdownMenuItemsS(_states);
    _selectedState = _dropdownMenuItemsS[0].value;
    _dropdownMenuItemsCI = buildDropdownMenuItemsC(_citys);
    _selectedCity = _dropdownMenuItemsCI[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Hexcolor('EA6012'),
        ),
        title: Image.asset(
          "assets/homelogo.png",
          width: 120,
          alignment: Alignment.topLeft,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Image.asset(
                          'assets/contrato.png',
                          width: 50,
                          color: Hexcolor('EA6012'),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 35, right: 60),
                      child: Text('Aceptacion de oferta laboral',
                          style: TextStyle(
                              color: Hexcolor('EA6012'),
                              fontFamily: 'OpenSans-Regular',
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
              SizedBox(height: 10),
              Row(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 17, right: 5),
                    child: Checkbox(
                      activeColor: Hexcolor('EA6012'),
                      value: address,
                      onChanged: (bool value) async {
                        setState(() {
                          address = value;
                          print(address);
                        });
                        _dateOffer = Offer(
                            is_accepted: address,
                            accepted_contracting_conditions: address,
                            arrives_on_his_own: edo,
                            departure_location: _valMeeting,
                            country: _selectedCountry.id,
                            state: _selectedState.id,
                            city: _selectedCity.id,
                            address: _dateOffer.address,
                            wants_to_be_driver: meetingV);
                      },
                    )),
                Text('Acepto las condiciones de contratación',
                    style: TextStyle(color: Colors.grey, fontSize: 17))
              ]),
              Container(
                  margin: EdgeInsets.only(left: 32, right: 32),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('¿Llegas por tus propios medios?',
                          style: TextStyle(color: Colors.grey, fontSize: 17)))),
              Container(
                  margin: EdgeInsets.only(left: 32, right: 32),
                  child: FormField(
                    builder: (state) {
                      return DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text('Seleccione'),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valEdo,
                        items: _listEdo.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) => setState(() {
                          _valEdo = value;
                          if (_valEdo == 'Si') {
                            edo = true;
                          } else {
                            edo = false;
                          }
                          state.didChange(value);
                        }),
                      );
                      // ignore: dead_code
                      // ignore: unnecessary_statements
                      // ignore: dead_code
                      onSaved:
                      // ignore: unnecessary_statements
                      (value) {
                        _dateOffer = Offer(
                            is_accepted: address,
                            accepted_contracting_conditions: address,
                            arrives_on_his_own: edo,
                            departure_location: _valMeeting,
                            country: _selectedCountry.id,
                            state: _selectedState.id,
                            city: _selectedCity.id,
                            address: value,
                            wants_to_be_driver: meetingV);
                      };
                    },
                  )),
              if (_valEdo == 'No') ...[
                Container(
                    margin: EdgeInsets.only(left: 32, right: 32),
                    child: DropdownButton(
                      value: _valMeeting,
                      iconEnabledColor: Hexcolor('EA6012'),
                      isExpanded: true,
                      items: meeting.map((item) {
                        return new DropdownMenuItem(
                            child: new Text(item['point']), value: item['id']);
                      }).toList(),
                      onChanged: (newVal) {
                        _valMeeting = newVal;
                        setState(() {});
                      },
                      hint: Text('Lugar de Salida'),
                    )),
                Row(children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 17, right: 5),
                      child: Checkbox(
                        activeColor: Hexcolor('EA6012'),
                        value: other_meeting,
                        onChanged: (bool value) {
                          setState(() {
                            other_meeting = value;
                            print(other_meeting);
                          });
                        },
                      )),
                  Text('Seleccionar otro lugar de salida?',
                      style: TextStyle(color: Colors.grey, fontSize: 17))
                ])
              ],
              if (other_meeting) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 147.0,
                      child: FormField(
                        builder: (state) {
                          return DropdownButton(
                            isExpanded: true,
                            iconEnabledColor: Hexcolor('EA6012'),
                            hint: Text('Seleccione Pais'),
                            underline: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            items: _dropdownMenuItemsC,
                            value: _selectedCountry,
                            onChanged: (value) => setState(() {
                              _selectedCountry = value;
                              state.didChange(value);
                            }),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: 147.0,
                      child: FormField(
                        builder: (state) {
                          return DropdownButton(
                            isExpanded: true,
                            iconEnabledColor: Hexcolor('EA6012'),
                            hint: Text('Seleccione Estado'),
                            underline: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            items: _dropdownMenuItemsS,
                            value: _selectedState,
                            onChanged: (value) => setState(() {
                              _selectedState = value;
                              state.didChange(value);
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 147.0,
                        child: FormField(
                          builder: (state) {
                            return DropdownButton(
                              isExpanded: true,
                              iconEnabledColor: Hexcolor('EA6012'),
                              hint: Text('Seleccione Ciudad'),
                              underline: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              items: _dropdownMenuItemsCI,
                              value: _selectedCity,
                              onChanged: (value) => setState(() {
                                _selectedCity = value;
                                state.didChange(value);
                              }),
                            );
                          },
                        )),
                    Container(
                      width: 147.0,
                      height: 90,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Otro'),
                        onSaved: (value) {
                          _dateOffer = Offer(
                              is_accepted: address,
                              accepted_contracting_conditions: address,
                              arrives_on_his_own: edo,
                              departure_location: _valMeeting,
                              country: _selectedCountry.id,
                              state: _selectedState.id,
                              city: _selectedCity.id,
                              address: value,
                              wants_to_be_driver: meetingV);
                        },
                      ),
                    ),
                  ],
                )
              ],
              Container(
                  margin: EdgeInsets.only(
                    left: 30,
                  ),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('¿Quieres ser conductor?',
                          style: TextStyle(color: Colors.grey, fontSize: 17)))),
              Container(
                  margin: EdgeInsets.only(left: 32, right: 32),
                  child: FormField(
                    builder: (state) {
                      return DropdownButton(
                        isExpanded: true,
                        iconEnabledColor: Hexcolor('EA6012'),
                        hint: Text('Seleccione'),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        value: _valCond,
                        items: _listEdo.map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) => setState(() {
                          _valCond = value;
                          if (_valCond == 'Si') {
                            meetingV = true;
                          } else {
                            meetingV = false;
                          }
                          _dateOffer = Offer(
                              is_accepted: address,
                              accepted_contracting_conditions: address,
                              arrives_on_his_own: edo,
                              departure_location: _valMeeting,
                              country: _selectedCountry.id,
                              state: _selectedState.id,
                              city: _selectedCity.id,
                              address: _dateOffer.address,
                              wants_to_be_driver: meetingV);
                          state.didChange(value);
                        }),
                      );
                      // ignore: unnecessary_statements
                      // ignore: dead_code
                    },
                  )),
              Container(
                margin: EdgeInsets.only(left: 32, right: 32),
                // padding: EdgeInsets.symmetric(vertical: 1.0),
                width: double.infinity,
                child: DropdownButton(
                  hint: Text("Firma con el dedo"),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  isExpanded: true,
                  iconEnabledColor: Hexcolor('EA6012'),
                  value: _valAdd2,
                  items: _listAdd2.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _valAdd2 =
                          value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                    });
                    _showInputSignature();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 40.0,
                    margin: EdgeInsets.only(bottom: 15),
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // padding: EdgeInsets.only(left: 20, right: 20,top: 15, bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: Hexcolor('EA6012'),
                      child: Text(
                        'Volver',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          width: 130,
                          height: 40.0,
                          margin: EdgeInsets.only(bottom: 15),
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: address && sign ? _saveForm : null
                            /*  Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PostulationPage(user: this.widget.user,offer: data)),
                          );*/
                            ,
                            // padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Hexcolor('009444'),
                            child: Text(
                              'Aceptar',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png'), size: 25),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/chat.png'), size: 25),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/codigo-qr.png'),
                color: Colors.black, size: 35),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/notif.png'), size: 25),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/usuario.png'), size: 25),
            title: Text(''),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onTap,
      ),
    );
  }

  renderBenefits(benefitsO) {
    return Column(
        children: benefitsO
            .map<Widget>((ben) =>
                //Mostar items
                Container(
                    margin: EdgeInsets.only(left: 21, right: 21),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          (ben['concept'] != null) ? ben['concept'] : '',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    )))
            .toList());
  }

  Future<Null> showImage(BuildContext context) async {
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    // Use plugin [path_provider] to export image to storage
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);
    await Directory('$path/$directoryName').create(recursive: true);
    File('$path/$directoryName/${formattedDate()}.png')
        .writeAsBytesSync(pngBytes.buffer.asInt8List());
  }

  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = 'Signature_' +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        ':' +
        dateTime.minute.toString() +
        ':' +
        dateTime.second.toString() +
        ':' +
        dateTime.millisecond.toString() +
        ':' +
        dateTime.microsecond.toString();
    return dateTimeString;
  }
}
