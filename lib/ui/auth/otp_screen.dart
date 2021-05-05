import 'package:firebase_auth/firebase_auth.dart';
import 'package:flrx_validator/flrx_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/ui/auth/info_screen.dart';
import 'package:promohunter/ui/main_screen.dart';
import 'package:promohunter/widgets/error_pop_up.dart';
import 'package:promohunter/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  static const String routeName = 'OTP_SCREEN';

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _initOTP();
  }

  Future<void> _initOTP() async {
    final provider = context.read<AuthService>();
    try {
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) async {
        print(
            '------------ Verification Completed ($phoneAuthCredential) ------------');
        _autoVerify(phoneAuthCredential);
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) async {
        print(
            '------------ Verification Failed (${authException.message}) ------------');

        await showDialog(
          context: context,
          builder: (context) => ErrorPopUp(message: '${authException.message}'),
        );
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        print('------------ Code Sent ($verificationId) ------------');
        provider.verificationId = verificationId;
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        print(
            '------------ Code Auto Retrieval Timeout ($verificationId) ------------');
        provider.verificationId = verificationId;
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+230 ${provider.currentUser.phone}',
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e, s) {
      print(s);

      showDialog(
          context: context,
          builder: (ctx) => ErrorPopUp(message: e.toString()));
    }
  }

  Future<void> _resendOTP() async {
    final provider = context.read<AuthService>();
    try {
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) async {
        print(
            '------------ Verification Completed ($phoneAuthCredential) ------------');
        _autoVerify(phoneAuthCredential);
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) async {
        print(
            '------------ Verification Failed (${authException.message}) ------------');

        await showDialog(
          context: context,
          builder: (context) => ErrorPopUp(message: 'Something went wrong'),
        );
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        print('------------ Code Sent ($verificationId) ------------');
        provider.verificationId = verificationId;
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        print(
            '------------ Code Auto Retrieval Timeout ($verificationId) ------------');
        provider.verificationId = verificationId;
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+230 ${provider.currentUser.phone}',
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Code Sent"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ));
    } catch (e, s) {
      print(s);

      showDialog(
          context: context,
          builder: (ctx) => ErrorPopUp(message: e.toString()));
    }
  }

  Future<void> _autoVerify(AuthCredential authCredential) async {
    final provider = context.read<AuthService>();

    FirebaseUser user = await FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((value) => value.user);

    await provider.login(firebaseUser: user);

    if (await provider.isUserExist()) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainScreen(),
          settings: RouteSettings(name: MainScreen.routeName),
        ),
        (route) => false,
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InfoScreen(),
          settings: RouteSettings(name: InfoScreen.routeName),
        ),
      );
    }
  }

  Future<void> _verify() async {
    if (!_formKey.currentState.validate()) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      return;
    }

    try {
      LoadingScreen.show(context);
      _formKey.currentState.save();

      final provider = context.read<AuthService>();

      await provider.login();

      if (await provider.isUserExist()) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
            settings: RouteSettings(name: MainScreen.routeName),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InfoScreen(),
            settings: RouteSettings(name: InfoScreen.routeName),
          ),
        );
      }
    } on PlatformException catch (e, s) {
      print(s);

      Navigator.of(context).pop();

      showDialog(
          context: context, builder: (ctx) => ErrorPopUp(message: "${e.code}"));
    } catch (e, s) {
      print(s);

      Navigator.of(context).pop();

      showDialog(
          context: context,
          builder: (ctx) => ErrorPopUp(message: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();

    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: [
              SizedBox(height: 24.0),
              Row(
                children: [
                  SizedBox(width: 8.0),
                  Image.asset(
                    'assets/icons/phone.png',
                    height: 80.0,
                    width: 80.0,
                  ),
                ],
              ),
              Spacer(),
              Text(
                'Enter OTP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Enter Password received on your mobile number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Calibri',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                onSaved: (v) => provider.smsCode = v,
                validator: Validator<String>(
                  rules: [
                    RequiredRule(
                      validationMessage:
                          "Please enter Password received on your mobile",
                    ),
                  ],
                ),
                decoration: InputDecoration(
                  hintText: 'OTP',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Calibri',
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Container(
                height: 48.0,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () => _verify(),
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Calibri',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  elevation: 1.0,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => _resendOTP(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Calibri',
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
