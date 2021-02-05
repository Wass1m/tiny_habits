import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:tinyhabits/services/firebase/auth.dart';
import 'package:tinyhabits/styles/styles.dart';
import 'package:tinyhabits/wrapper.dart';

import 'login.dart';

class RegScreen extends StatefulWidget {
  static const routename = "/reg";

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  File _imageFile;
  AuthService _auth = AuthService();

  bool hidden = true;
  bool loading = false;
  bool loadingGoogle = false;

  bool checkedValue = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _name = TextEditingController();
  String avatarPath = '';

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected =
        await ImagePicker().getImage(source: source, imageQuality: 70);

    setState(() {
      _imageFile = File(selected.path);
    });
  }

  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://goaltracker-dc635.appspot.com');

  UploadTask _uploadTask;

  UploadTask _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';

    _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);

    return _uploadTask;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/patternTrans.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Form(
              key: _formKey,
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

                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Getting Started',
                      style: BigBoldHeading,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Create an account to continue!',
                      style: GreySubtitle.copyWith(fontSize: 16),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _email,
                    autofillHints: [
                      AutofillHints.email,
                    ],
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                    ),
                    validator: (String value) {
                      if (value == '') {
                        return 'This field is required';
                      }
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return 'Please enter correct email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: _name,
                    autofillHints: [
                      AutofillHints.name,
                    ],
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: hidden,
                    obscuringCharacter: '*',
                    controller: _pass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidden = !hidden;
                          });
                        },
                        icon: Icon(
                          hidden ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'This field is required';
                      }
                      if (value.length < 8) {
                        return 'Password length must be atleast 8 characters long';
                      }
                      return null;
                    },
                  ),

                  CheckboxListTile(
                    title: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'By Creating an account you agree to our ',
                          style: GreySubtitle),
                      TextSpan(
                          text: 'Terms & Conditions', style: SmallBoldBlackText)
                    ])),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  loading == true
                      ? CircularProgressIndicator()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: RaisedButton(
                            elevation: 0,
                            textColor: Colors.white,
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              if (!_formKey.currentState.validate()) {
                                setState(() {
                                  loading = false;
                                });
                                return;
                              }

// uploading the image
//                           var upload = await _startUpload();
//
//                           var url = await upload.ref.getDownloadURL();

                              // login

                              var result = _auth.signUpWithEmailandPassword(
                                  _email.text, _pass.text, _name.text);

                              if (result == null) {
                                print('ERROR LOGIN WITH EMAIL AND PASSWORD');
                                setState(() {
                                  loading = false;
                                });
                              } else {
                                setState(() {
                                  loading = false;
                                });

                                // Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WrapperUser()));
                              }

                              setState(() {
                                loading = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                Text('SIGN UP'),
                                Icon(Icons.exit_to_app)
                              ],
                            ),
                          ),
                        ),
                  MaterialButton(
                    enableFeedback: false,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GreySubtitle,
                        text: "ALREADY HAVE AN ACCOUNT? ",
                        children: [
                          TextSpan(
                            style: GreySubtitle.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                            text: "LOGIN",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
