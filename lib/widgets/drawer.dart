import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promohunter/providers/auth_provider.dart';
import 'package:promohunter/ui/auth/login_screen.dart';
import 'package:promohunter/ui/library_screen.dart';
import 'package:promohunter/ui/main_screen.dart';
import 'package:promohunter/ui/my_account_screen.dart';
import 'package:promohunter/ui/policy_screen.dart';
import 'package:promohunter/ui/terms_screen.dart';
import 'package:promohunter/utils/auth_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 210.0,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/ph.png',
                  height: 64.0,
                  width: 64.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Promo',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hunter',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).accentColor,
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  ListTile(
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                        settings: RouteSettings(name: MainScreen.routeName),
                      ),
                      (route) => false,
                    ),
                    leading: Image.asset(
                      'assets/icons/ph.png',
                      width: 28.0,
                      height: 28.0,
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MyAccountScreen(),
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/person.png',
                      width: 28.0,
                      height: 28.0,
                    ),
                    title: Text(
                      'My Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TermsScreen(),
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/note.png',
                      width: 28.0,
                      height: 28.0,
                    ),
                    title: Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PolicyScreen(),
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/note.png',
                      width: 28.0,
                      height: 28.0,
                    ),
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AboutPromoHunterScreen(),
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/info.png',
                      width: 28.0,
                      height: 28.0,
                    ),
                    title: Text(
                      'About Promo Hunter',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LibraryScreen(
                          type: 1,
                          index: 1,
                        ),
                      ),
                    ),
                    leading: Icon(
                      Icons.card_membership,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Memberships',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      AuthClient.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false);
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Calibri',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPromoHunterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String about = context.select((AuthService auth) => auth.about);
    return Scaffold(
      body: about == null
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : WebView(
              initialUrl: about ?? '',
              javascriptMode: JavascriptMode.unrestricted,
            ),
    );
  }
}
