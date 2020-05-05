import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/resources/auth_methods.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  Usuario _usuario;
  AuthMethods _authMethods = AuthMethods();

  Usuario get getUser => _usuario;

  void refreshUser() async {
    Usuario usuario = await _authMethods.getUserDetails();
    _usuario = usuario;
    notifyListeners();
  }
}
