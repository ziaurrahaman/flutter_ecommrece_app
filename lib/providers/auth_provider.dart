import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:promohunter/models/user_model.dart';
import 'package:promohunter/utils/analytics_client.dart';
import 'package:promohunter/utils/auth_client.dart';
import 'package:promohunter/utils/database_client.dart';

export 'package:provider/provider.dart';

class AuthService extends ChangeNotifier {
  final DatabaseClient _firestore = DatabaseClient.instance;
  final AuthClient _auth = AuthClient.instance;
  final Analytics _analytics = Analytics.instance;
  FirebaseUser user;
  UserModel currentUser = UserModel();
  bool userExist = false;

  String smsCode = '';
  String verificationId = '';

  bool canResend = false;
  bool checkVal = false;

  bool get isLogged => user != null;

  String terms;

  String policy;
  String about;

  Future<bool> autoLogin() async {
    getTerms();
    getPolicy();
    getAboutLink();

//    await Future<void>.delayed(Duration(seconds: 1));
    user = await AuthClient.instance.user();

    if (user != null) {
      userExist = await _firestore.isUserExist();

      if (userExist) {
        currentUser = await _firestore.getUserData();

        updateDailyPoints();
      }

      return true;
    }
    //
    final isLoggedIn = await AuthClient.instance.isLoggedIn();

    //
    if (!isLoggedIn) return false;
    //
    try {
      //
      userExist = await _firestore.isUserExist();

      if (userExist) {
        currentUser = await _firestore.getUserData();

        updateDailyPoints();
      }

      _analytics
        ..setUserId(userId: currentUser.id)
        ..setUserProperty(name: 'user_auth', value: 'phone');

      return true;
    } catch (e, s) {
      print(e);
      print(s);
      Crashlytics.instance.recordError('Manuel Reporting Crash $e', s);
      return false;
    }
  }

  Future<void> login({FirebaseUser firebaseUser}) async {
    if (firebaseUser == null)
      user = await _auth.signInWithPhoneNumber(smsCode, verificationId);
    _analytics.logLogin(loginMethod: 'phone');
    _analytics
      ..setUserId(userId: currentUser.id)
      ..setUserProperty(name: 'user_auth', value: 'phone');
    notifyListeners();
  }

  void toggleCanResend() {
    canResend = !canResend;
    notifyListeners();
  }

  Future<void> logout() async {
    _auth.signOut();
    _analytics.logEvent(name: 'logout');
    currentUser = null;
    _analytics.resetAnalytics();
    notifyListeners();
  }

  Future<void> saveUserData() async {
    await _firestore.putUserData(currentUser);
    _analytics.logEvent(name: 'saveUserData');
  }

  Future<void> editProfile() async {
//    final _user = await _fireStore.updateProfile(user);
//    currentUser = _user.copyWith(addresses: currentUser.addresses);
    _analytics.logEvent(name: 'edited_profile');
    notifyListeners();
  }

  Future<bool> isUserExist() async {
    return (await _firestore.isUserExist() ?? false);
  }

  Future<bool> checkReferral(num ref) async {
    return (await _firestore.checkReferral(ref) ?? false);
  }

  Future<void> updateDailyPoints() async {
    await DatabaseClient.instance.updateUserData(currentUser);
  }

  void toggleCheck() {
    checkVal = !checkVal;
    notifyListeners();
  }

  Future<void> getTerms() async {
    terms = (await DatabaseClient.instance.getTerms()) ?? '';
  }

  Future<void> getPolicy() async {
    policy = (await DatabaseClient.instance.getPolicy()) ?? '';
  }

  Future<void> getAboutLink() async {
    about = (await DatabaseClient.instance.getAbout()) ?? '';
  }
}
