import 'dart:io';

import 'package:flrx_validator/flrx_validator.dart';
import 'package:flutter/material.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/ui/auth/otp_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LOGIN_SCREEN';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  void _phoneLogin() {
    if (!_formKey.currentState.validate()) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      return;
    }
    _formKey.currentState.save();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OTPScreen(),
        settings: RouteSettings(name: OTPScreen.routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthService>();

    return Scaffold(
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
                  GestureDetector(
                    onTap: () => exit(0),
                    child: Image.asset(
                      'assets/icons/exit.png',
                      height: 80.0,
                      width: 80.0,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                'Sign in',
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
                  'Sign in with your mobile number to receive your One Time Password',
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
                onSaved: (v) => provider.currentUser.phone = v,
                validator: Validator<String>(
                  rules: [
                    RequiredRule(
                      validationMessage: "Phone number is required",
                    ),
                  ],
                ),
                decoration: InputDecoration(
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/phone.png',
                        height: 32.0,
                        width: 32.0,
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        '+ 230',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Calibri',
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(width: 4.0),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Container(
                height: 48.0,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () => _phoneLogin(),
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
                  elevation: 1.0,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
