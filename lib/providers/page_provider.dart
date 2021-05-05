import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int page = 0;

  void changePage(int val) {
    page = val;
    notifyListeners();
  }
}
