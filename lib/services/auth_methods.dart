import 'package:firebase/firebase.dart' as WebFirebase;
import 'package:firebase/firestore.dart' as WebFirestore;
import 'package:telemedicina/constants/strings.dart';
import 'package:telemedicina/models/message.dart';
import 'package:telemedicina/models/users.dart';
import 'package:telemedicina/utils/utilities.dart';

WebFirebase.User webFirebaseUser;

class AuthMethods {
  final WebFirebase.Auth webAuth = WebFirebase.auth();
  WebFirebase.GoogleAuthProvider webGoogleSignIn;
  static final WebFirestore.Firestore webFirestore = WebFirebase.firestore();

  //Clase Usuario
  Usuario usuario = Usuario();

  //Obtiene datos del usuario actual
  Future<WebFirebase.User> getCurrentUser() async {
    WebFirebase.User currentUser;
    currentUser = webAuth.currentUser;
    return currentUser;
  }

  //Funcion para loguear mediante google devuelve un usuario actual tambien
  //Pero hace que se repita el login
  Future<WebFirebase.User> singIn() async {
    var provider = new WebFirebase.GoogleAuthProvider();
    WebFirebase.UserCredential _userCredential =
        await webAuth.signInWithPopup(provider);
    webFirebaseUser = _userCredential.user;
    return webFirebaseUser;
  }

  //Revisa la base de datos para saber si el usuario existe
  Future<bool> authenticateUser(WebFirebase.User user) async {
    WebFirestore.QuerySnapshot result = await webFirestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, '==', user.email)
        .get();

    final List<WebFirestore.DocumentSnapshot> docus = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docus.length == 0 ? true : false;
  }

  //Agrega los datos del usuario a la base de datos de firestore
  Future<void> addDataToDb(WebFirebase.User webFirebaseUser) async {
    String username = Utils.getUsername(webFirebaseUser.email);
    usuario = Usuario(
        uid: webFirebaseUser.uid,
        email: webFirebaseUser.email,
        name: webFirebaseUser.displayName,
        profilePhoto: webFirebaseUser.photoURL,
        username: username);

    webFirestore
        .collection(USERS_COLLECTION)
        .doc(webFirebaseUser.uid)
        .set(usuario.toMap(usuario));
  }

  //Logout
  Future<void> signOut() async {
    webAuth.signOut();
  }

  //Busca usuarios de la base de datos
  Future<List<Usuario>> fetchAllUsers(WebFirebase.User currentUser) async {
    List<Usuario> userList = List<Usuario>();

    WebFirestore.QuerySnapshot querySnapshot =
        await webFirestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(Usuario.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  //anade los mensajes a la base de datos de firestore
  Future<void> addMessageToDb(
      Message message, Usuario sender, Usuario receiver) async {
    var map = message.toMap();

    await webFirestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);
    
    return await webFirestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }
}
