import 'package:flrx_validator/flrx_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/ui/main_screen.dart';
import 'package:promohunter/ui/policy_screen.dart';
import 'package:promohunter/ui/terms_screen.dart';
import 'package:promohunter/utils/auth_client.dart';
import 'package:promohunter/widgets/error_pop_up.dart';
import 'package:promohunter/widgets/loading_screen.dart';

class InfoScreen extends StatefulWidget {
  static const String routeName = 'INFO_SCREEN';

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  Future<void> _saveInfo() async {
    final provider = context.read<AuthService>();

    if (!provider.checkVal) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'You need to agree to the terms and privacy policy to continue.',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Calibri',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_formKey.currentState.validate()) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      return;
    }
    try {
      _formKey.currentState.save();

      LoadingScreen.show(context);

      if (provider.currentUser.referralNumber == null ||
          await provider.checkReferral(provider.currentUser.referralNumber)) {
        provider.currentUser.phone = await AuthClient.instance.userPhone();

        await provider.saveUserData();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
            settings: RouteSettings(name: MainScreen.routeName),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).pop();

        provider.currentUser.referralNumber = null;

        showDialog(
            context: context,
            builder: (ctx) => ErrorPopUp(message: "Referral Number is wrong!"));
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
    final checkVal =
        context.select((AuthService authService) => authService.checkVal);

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
                    'assets/icons/info.png',
                    height: 80.0,
                    width: 80.0,
                  ),
                ],
              ),
              Spacer(),
              Text(
                'Basic Info',
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
                  'How should we call you?',
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
                keyboardType: TextInputType.text,
                onSaved: (v) => provider.currentUser.fName = v,
                validator: Validator<String>(
                  rules: [
                    RequiredRule(
                      validationMessage: "First Name is required",
                    ),
                  ],
                ),
                decoration: InputDecoration(
                  hintText: 'First Name',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
                keyboardType: TextInputType.text,
                onSaved: (v) => provider.currentUser.lName = v,
                validator: Validator<String>(
                  rules: [
                    RequiredRule(
                      validationMessage: "Last Name is required",
                    ),
                  ],
                ),
                decoration: InputDecoration(
                  hintText: 'Last Name',
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Calibri',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (v) => v.isEmpty
                    ? null
                    : provider.currentUser.referralNumber = int.parse(v),
                decoration: InputDecoration(
                  hintText: 'Referral Number',
                ),
              ),
              SizedBox(height: 24.0),
              Container(
                height: 48.0,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () => _saveInfo(),
                  child: Text(
                    'FINISH',
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 16.0,
                      child: Checkbox(
                        value: checkVal,
                        onChanged: (value) => provider.toggleCheck(),
                        hoverColor: Colors.white,
                        checkColor: Theme.of(context).scaffoldBackgroundColor,
                        focusColor: Colors.white,
                        activeColor: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 20,
                      child: Row(
                        children: [
                          Text(
                            'I agree to the ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Calibri',
                              fontSize: 16.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TermsScreen(),
                              ),
                            ),
                            child: Text(
                              'terms ',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            'and ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Calibri',
                              fontSize: 16.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PolicyScreen(),
                              ),
                            ),
                            child: Text(
                              'Privacy policy',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Calibri',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            '.',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Calibri',
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
