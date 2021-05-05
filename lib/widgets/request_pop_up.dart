import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestProductPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Column(
        children: <Widget>[
          SizedBox(height: 24.0),
          Text(
            'Product not registered yet. would you like us to add it?',
            style: TextStyle(
              fontFamily: "RB",
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 36.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontFamily: "RB",
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              SizedBox(width: 24.0),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "No",
                  style: TextStyle(
                    fontFamily: "RB",
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
