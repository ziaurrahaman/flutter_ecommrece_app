import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:promohunter/providers/auth_provider.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String terms = context.select((AuthService auth) => auth.terms);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Terms And Conditions',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'sans-serif',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: terms == null
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    HtmlWidget(
                      terms ?? '',
                      webView: true,
                      textStyle: TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
