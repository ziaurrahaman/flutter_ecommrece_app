import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPopUp extends StatelessWidget {
  final String message;
  final String title;

  ErrorPopUp({@required this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title ?? "Error"),
      content: Column(
        children: <Widget>[
          SizedBox(height: 24.0),
          Text(
            message,
            style: TextStyle(
              fontFamily: "RB",
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 36.0),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Okay",
              style: TextStyle(
                fontFamily: "RB",
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
