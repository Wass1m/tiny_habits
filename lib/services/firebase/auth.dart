import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:tinyhabits/helpers/toast.dart';
import 'package:tinyhabits/models/profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  User getUser() => _auth.currentUser;

  Stream<User> get user => _auth.authStateChanges();

  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      if (e.code == 'wrong-password') {
        return 'Invalid password';
      }
      if (e.code == 'user-not-found') {
        return 'Mail doesn\'t exist';
      }
      return null;
    }
  }

  Future changePassword(String password) async {
    //Create an instance of the current user.
    User user = getUser();

    //Pass in the password to updatePassword.
    return user.updatePassword(password).then((_) {
      toast(
          "Your password changed Succesfully don't forget to login and logout ");
    }).catchError((err) {
      toast("You can't change the Password" + err.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  Future signUpWithEmailandPassword(
      String email, String password, String fullName) async {
    print(email);
    print(password);
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      Profile profile = Profile(fullName: fullName);

      await _db.collection('profiles').doc(user.uid).set(profile.toMap());

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogle() async {
    try {
      User user;

      final GoogleSignInAccount account = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredentials =
          await _auth.signInWithCredential(credential);

      user = userCredentials.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> signUpWithGoogle() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;

      var profile = await _db.collection('profiles').doc(user.uid).get();
      print('EXISTS EXISTSLASDKLAKDL;AKDADADLKAL;DK;ALSKDL;AKDL;KSDDKSLD');
      print(profile);
      if (profile.data() == null) {
        print('DOEST EXIST');
        await _db.collection('profiles').doc(user.uid).set({
          'fullName': user.displayName,
          'avatar': user.photoURL,
        });
      }

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut().then((_) {
        _googleSignIn.signOut();
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
