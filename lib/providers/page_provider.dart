import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  // private
  bool _isLoading = false;

  // getters
  bool get isLoading {
    return _isLoading;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
