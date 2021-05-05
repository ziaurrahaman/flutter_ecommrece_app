import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthClient {
  //Singleton
  AuthClient._privateConstructor();
  static final AuthClient instance = AuthClient._privateConstructor();

  final FirebaseAuth _authClient = FirebaseAuth.instance;

  // isLoggedIn?
  // Returns FirebaseUser if loggedIn and null if Not LoggedIn
  Future<bool> isLoggedIn() async {
    return await _authClient.currentUser() != null;
  }

  Future<FirebaseUser> user() async {
    return await _authClient.currentUser();
  }

  Future<String> uid() async {
    return await _authClient.currentUser().then((u) => u?.uid);
  }

  Future<String> userPhone() async {
    return await _authClient.currentUser().then((u) => u?.phoneNumber);
  }

  // Sign Out From Google Account & FB Account & Firebase _auth
  // No Returns
  Future<void> signOut() async {
    return await _authClient.signOut();
  }

  Future<FirebaseUser> signInWithPhoneNumber(
      String smsCode, String verificationId) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final FirebaseUser user =
        (await _authClient.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _authClient.currentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }
}
