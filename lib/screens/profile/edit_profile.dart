import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinyhabits/models/profile.dart';
import 'package:tinyhabits/screens/auth/register.dart';
import 'package:tinyhabits/services/firebase/auth.dart';
import 'package:tinyhabits/services/firebase/global.dart';
import 'package:tinyhabits/styles/styles.dart';
import 'package:tinyhabits/wrapper.dart';

class EditProfile extends StatefulWidget {
  final Profile profile;

  const EditProfile({Key key, this.profile}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  AuthService _auth = AuthService();
  final TextEditingController _name = TextEditingController();

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  bool _isLoading = false;
  bool loadingGoogle = false;

  String _error = '';

  bool hidden = true;

  @override
  void initState() {
    _name.text = widget.profile.fullName;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/patternTrans.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.1,
                    // ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Bssahtek',
                    //     style: BigBoldHeading,
                    //   ),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Edit your account',
                        style: BigBoldHeading,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Make the changes you want!',
                        style: GreySubtitle.copyWith(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _name,
                            autofillHints: [
                              AutofillHints.name,
                            ],
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'New Username',
                            ),
                            validator: (value) {
                              // if (value == '') {
                              //   return 'This field is required';
                              // }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            controller: _pass,
                            obscureText: hidden,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'New Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidden = !hidden;
                                  });
                                },
                                icon: Icon(
                                  hidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: (value) {
                              // if (value == '') {
                              //   return 'This field is required';
                              // }
                              // if (value.length < 8) {
                              //   return 'Password length must be atleast 8 characters long';
                              // }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _confirm,
                            obscureText: hidden,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidden = !hidden;
                                  });
                                },
                                icon: Icon(
                                  hidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: (value) {
                              // if (value == '') {
                              //   return 'This field is required';
                              // }
                              if (value != _pass.text) {
                                return 'Passwords dont match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _error.length > 0
                              ? Text(
                                  _error,
                                  style: SmallBoldRedText,
                                )
                              : Container(),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    (_isLoading)
                        ? CircularProgressIndicator()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: RaisedButton(
                              elevation: 0,
                              textColor: Colors.white,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  var result;
                                  var resultPass;

                                  if (_pass.text == '') {
                                    var data = {
                                      "fullName": _name.text,
                                    };

                                    result =
                                        await Global.profileRef.upsert(data);

                                    if (result == null) {
                                      print('ERROR CHANGING SETTINGS');
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      if (result is String) {
                                        setState(() {
                                          _error = result;
                                        });
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    }
                                  } else if (_pass.text != '') {
                                    var data = {
                                      "fullName": _name.text,
                                    };

                                    resultPass =
                                        await _auth.changePassword(_pass.text);

                                    result =
                                        await Global.profileRef.upsert(data);

                                    if (result == null || resultPass == null) {
                                      print('ERROR CHANGING SETTINGS PASSWORD');
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      if (result is String ||
                                          resultPass is String) {
                                        setState(() {
                                          _error = resultPass;
                                        });
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    }
                                  }

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  Text('CHANGE SETTINGS'),
                                  Icon(Icons.exit_to_app)
                                ],
                              ),
                            ),
                          ),

                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
