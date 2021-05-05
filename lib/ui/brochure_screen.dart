import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:promohunter/models/brochures_model.dart';
import 'package:promohunter/widgets/loading_screen.dart';

class BrochureScreen extends StatelessWidget {
  final BrochuresModel brochuresModel;

  const BrochureScreen({Key key, @required this.brochuresModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PDF.network(
          '${brochuresModel.pdf}',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          placeHolder: Center(child: LoadingWidget()),
        ),
      ),
    );
  }
}
