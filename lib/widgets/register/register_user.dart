import 'package:worker/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:hexcolor/hexcolor.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../../model/user.dart';
import '../../model/gender.dart';
import '../../model/country.dart';
import '../../model/http_exception.dart';
import '../../providers/users.dart';
import '../../providers/products.dart';
import '../../providers/product.dart';
import '../widgets.dart';

class RegisterUser extends StatefulWidget {
  static const routeName = '/add-user';

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  List<Gender> _genders = Gender.getGenders();
  List<DropdownMenuItem<Gender>> _dropdownMenuItems;
  List<Country> _countrys = Country.getCountrys();
  List<DropdownMenuItem<Country>> _dropdownMenuItemsC;
  Gender _selectedGender;
  Country _selectedCountry;
  String selectedValue;
  String preselectedValue = "dolor sit";
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  double maxtop;
  double maxwidth;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _editedUser = User(
      id: null,
      first_name: '',
      last_name: '',
      email: '',
      birth_date: null,
      password1: '',
      password2: '',
      gender: '',
      birthplace: '');
  var _initValuesU = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'birth_date': '',
    // ignore: equal_keys_in_map
    'email': '',
    'password1': '',
    'password2': '',
    'gender': '',
    'birthplace': ''
  };
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  // ignore: unused_field
  String _myActivity;
  // ignore: unused_field
  String _value;
  // ignore: unused_field
  String _myActivityResult;
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_genders);
    _selectedGender = _dropdownMenuItems[0].value;
    _dropdownMenuItemsC = buildDropdownMenuItemsC(_countrys);
    _myActivity = '';
    _value = '';
    _myActivityResult = '';
    super.initState();
  }

  List<DropdownMenuItem<Gender>> buildDropdownMenuItems(List genders) {
    List<DropdownMenuItem<Gender>> items = List();
    for (Gender gender in genders) {
      items.add(
        DropdownMenuItem(
          value: gender,
          child: Text(gender.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Country>> buildDropdownMenuItemsC(List countrys) {
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    var successRegister = 0;
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedUser.id != null) {
      Provider.of<User>(context, listen: false);
      //.updateProduct(_editedProduct.id, _editedProduct);
    } else {
      //Provider.of<Users>(context, listen: false).addUser(_editedUser);
      try {
        await Provider.of<Users>(context, listen: false)
            .addUser(_editedUser)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmRegister(_editedUser.email)),
          );
        });
        successRegister = 1;
      } on HttpException catch (email) {
        successRegister = 2;
        var errorMessage = '';
        if (email
            .toString()
            .contains('A user with that email address already exists')) {
          errorMessage = 'This email address is already in use.';
        } else if (email.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (email.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (email.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (email.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        }
        _showErrorDialog(errorMessage);
      } catch (email) {
        successRegister = 2;
        const errorMessage = 'Could not register you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
    }
    //Navigator.of(context).pop();
    print(successRegister);
    if (successRegister == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmRegister(_editedUser.email)),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    String _titleReg = AppTranslations.of(context).text("register_btn");
    SizeConfig().init(context);
    var screenSize = MediaQuery.of(context).size;
    if (screenSize.height > 800) {
      maxtop = 75;
      maxwidth = 165;
    } else {
      maxwidth = 130;
      maxtop = 60;
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              LogoRegister(),
              Container(
                  margin: EdgeInsets.all(16.0),
                  child: Text(
                    _titleReg,
                    style: TextStyle(
                      fontSize: 28,
                      color: Hexcolor('EA6012'),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: maxwidth,
                    child: TextFormField(
                      initialValue: _initValues['first_name'],
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          labelText: AppTranslations.of(context)
                              .text("key_first_name")),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          first_name: capitalize(value),
                          last_name: _editedUser.last_name,
                          email: _editedUser.email,
                          birth_date: _editedUser.birth_date,
                          password1: _editedUser.password1,
                          password2: _editedUser.password2,
                          gender: _editedUser.gender,
                          birthplace: _editedUser.birthplace,
                          id: _editedUser.id,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: maxwidth,
                    child: TextFormField(
                      initialValue: _initValuesU['last_name'],
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          labelText: AppTranslations.of(context)
                              .text("key_last_name")),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          first_name: _editedUser.first_name,
                          last_name: capitalize(value),
                          email: _editedUser.email,
                          birth_date: _editedUser.birth_date,
                          password1: _editedUser.password1,
                          password2: _editedUser.password2,
                          gender: _editedUser.gender,
                          birthplace: _editedUser.birthplace,
                          id: _editedUser.id,
                        );
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: maxwidth,
                    child: DateTimeField(
                      format: format,
                      decoration: InputDecoration(
                          labelText:
                              AppTranslations.of(context).text("birth_date")),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime(2002),
                            lastDate: DateTime(2002));
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          first_name: _editedUser.first_name,
                          last_name: _editedUser.last_name,
                          email: _editedUser.email,
                          birth_date: value,
                          password1: _editedUser.password1,
                          password2: _editedUser.password2,
                          gender: _editedUser.gender,
                          birthplace: _editedUser.birthplace,
                          id: _editedUser.id,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: maxwidth,
                    height: maxtop,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppTranslations.of(context).text("gender"),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ),
                        ),
                        FormField(
                          builder: (state) {
                            return DropdownButton(
                              isExpanded: true,
                              hint: Text('Seleccione'),
                              iconEnabledColor: Hexcolor('EA6012'),
                              underline: Container(
                                height: 1,
                                color: Colors.grey,
                              ),
                              items: _dropdownMenuItems,
                              value: _selectedGender,
                              onChanged: (value) => setState(() {
                                _selectedGender = value;
                                state.didChange(value);
                              }),
                            );
                          },
                          onSaved: (value) => _editedUser = User(
                            id: _editedUser.id,
                            first_name: _editedUser.first_name,
                            email: _editedUser.email,
                            birth_date: _editedUser.birth_date,
                            last_name: _editedUser.last_name,
                            password1: _editedUser.password1,
                            password2: _editedUser.password2,
                            gender: _selectedGender.id,
                            birthplace: _editedUser.birthplace,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 23, right: 23),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Pais de Nacimiento',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 23, right: 23),
                child: SearchableDropdown.single(
                  items: _dropdownMenuItemsC,
                  value: _selectedCountry,
                  iconEnabledColor: Hexcolor('EA6012'),
                  hint: "Seleccione",
                  searchHint: "Seleccione",
                  onChanged: (value) => setState(() {
                    _selectedCountry = value;
                  }),
                  isExpanded: true,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 23, right: 23),
                  child: TextFormField(
                    initialValue: _initValuesU['email'],
                    decoration: InputDecoration(
                        labelText:
                            AppTranslations.of(context).text("key_email")),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Email Invalido!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedUser = User(
                        first_name: _editedUser.first_name,
                        last_name: _editedUser.last_name,
                        email: value,
                        birth_date: _editedUser.birth_date,
                        password1: _editedUser.password1,
                        password2: _editedUser.password2,
                        gender: _editedUser.gender,
                        birthplace: _selectedCountry.name,
                        id: _editedUser.id,
                      );
                    },
                  )),
              Container(
                margin: EdgeInsets.only(left: 23, right: 23),
                child: TextFormField(
                  obscureText: true,
                  initialValue: _initValuesU['password1'],
                  decoration: InputDecoration(
                      labelText:
                          AppTranslations.of(context).text("key_password")),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty || value.length < 8) {
                      return 'Password es muy corto!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedUser = User(
                      first_name: _editedUser.first_name,
                      last_name: _editedUser.last_name,
                      email: _editedUser.email,
                      birth_date: _editedUser.birth_date,
                      password1: value,
                      password2: _editedUser.password2,
                      gender: _editedUser.gender,
                      birthplace: _selectedCountry.name,
                      id: _editedUser.id,
                    );
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 23, right: 23),
                  child: TextFormField(
                    initialValue: _initValuesU['password2'],
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText:
                            AppTranslations.of(context).text("confirmpasswd")),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedUser = User(
                        first_name: _editedUser.first_name,
                        last_name: _editedUser.last_name,
                        email: _editedUser.email,
                        birth_date: _editedUser.birth_date,
                        password1: _editedUser.password1,
                        password2: value,
                        gender: _editedUser.gender,
                        birthplace: _selectedCountry.name,
                        id: _editedUser.id,
                      );
                    },
                  )),
              SizedBox(
                height: 60,
              ),
              Container(
                  margin: EdgeInsets.only(left: 23, right: 23),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          elevation: 5.0,
                          onPressed: _saveForm,
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 15, bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.green[700],
                          child: Text(
                            AppTranslations.of(context).text("register"),
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        )),
              Container(
                // padding: EdgeInsets.symmetric(vertical: 25.0),
                margin: EdgeInsets.only(left: 23.0, right: 23.0, top: 10.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Hexcolor('EA6012'),
                  child: Text(
                    'Volver',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
