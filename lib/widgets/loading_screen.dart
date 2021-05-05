import 'package:flutter/material.dart' hide FontWeight;
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  final Indicator indicator;

  const LoadingWidget({
    Key key,
    this.indicator = Indicator.ballScale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: LoadingIndicator(
          indicatorType: indicator,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class LoadingScreen {
  LoadingScreen._();

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadingWidget(
                indicator: Indicator.ballScale,
              )
            ],
          ),
        );
      },
    );
  }
}
