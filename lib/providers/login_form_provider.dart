import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }



  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}