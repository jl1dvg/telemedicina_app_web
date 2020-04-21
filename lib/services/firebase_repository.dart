import 'package:firebase/firebase.dart' as WebFirebase;
import 'package:telemedicina/services/auth_methods.dart';

class FirebaseRepository {
  AuthMethods _authMethods = AuthMethods();
  Future<WebFirebase.User> getCurrentUser() => _authMethods.getCurrentUser();
}