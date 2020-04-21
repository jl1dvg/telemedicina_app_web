import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/resources/firebase_repository.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  Usuario _usuario;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  Usuario get getUser => _usuario;

  void refreshUser() async {
    Usuario usuario = await _firebaseRepository.getUserDetails();
    _usuario = usuario;
    notifyListeners();
  }

}