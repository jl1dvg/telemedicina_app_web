import 'package:Skype_clone/constants/strings.dart';
import 'package:Skype_clone/models/message.dart';
import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as WebFirebase;

WebFirebase.User webFirebaseUser;

class FirebaseMethods {
  final WebFirebase.Auth webAuth = WebFirebase.auth();
  WebFirebase.GoogleAuthProvider webGoogleSignIn;
  static final Firestore firestore = Firestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  static final Firestore _firestore = Firestore.instance;

  //user class
  Usuario usuario = Usuario();

  Future<WebFirebase.User> getCurrentUser() async {
    WebFirebase.User currentUser;
    currentUser = webAuth.currentUser;
    return currentUser;
  }

  Future<Usuario> getUserDetails() async {
    WebFirebase.User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return Usuario.fromMap(documentSnapshot.data);
  }

  Future<WebFirebase.User> singIn() async {
    var provider = new WebFirebase.GoogleAuthProvider();
    WebFirebase.UserCredential _userCredential =
        await webAuth.signInWithPopup(provider);
    webFirebaseUser = _userCredential.user;
    return webFirebaseUser;
  }

  Future<bool> authenticateUser(WebFirebase.User user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(WebFirebase.User currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    usuario = Usuario(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
        username: username);

    firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(usuario.toMap(usuario));
  }

  Future<void> signOut() async {
    webAuth.signOut();
  }

  Future<List<Usuario>> fetchAllUsers(WebFirebase.User currentUser) async {
    List<Usuario> userList = List<Usuario>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(Usuario.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, Usuario sender, Usuario receiver) async {
    var map = message.toMap();

    await firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }
}
