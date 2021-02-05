import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinyhabits/models/profile.dart';
import 'package:tinyhabits/screens/profile/edit_profile.dart';
import 'package:tinyhabits/services/firebase/auth.dart';
import 'package:tinyhabits/styles/styles.dart';
import 'package:tinyhabits/wrapper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Profile>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(profile: user)));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: kPrimaryColor,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            user == null
                ? Container()
                : Text(user.fullName, style: BigBoldHeading),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, left: 30, right: 30),
              child: RaisedButton(
                color: Colors.red,
                elevation: 0,
                textColor: Colors.white,
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => WrapperUser()),
                      (route) => false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Text(
                      'LOGOUT',
                      style: WhiteSubtitle,
                    ),
                    Icon(Icons.close)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
