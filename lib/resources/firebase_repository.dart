import 'package:Skype_clone/models/message.dart';
import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/resources/Firebase_methods.dart';
import 'package:firebase/firebase.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<User> signIn() => _firebaseMethods.singIn();

  Future<Usuario> getUserDetails() => _firebaseMethods.getUserDetails();

  Future<bool> authenticateUser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);

  ///responsible for signing out
  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<Usuario>> fetchAllUsers(User user) =>
      _firebaseMethods.fetchAllUsers(user);

  Future<void> addMessageToDb(
          Message message, Usuario sender, Usuario receiver) =>
      _firebaseMethods.addMessageToDb(message, sender, receiver);
}
