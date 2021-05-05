import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).accentColor,
        child: Center(
          child: Hero(
            tag: 'logo',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/ph.png',
                  height: 120.0,
                  width: 120.0,
                ),
                Text(
                  'Promo',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Calibri',
                    fontSize: 64.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Hunter',
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
      ),
    );
  }
}
