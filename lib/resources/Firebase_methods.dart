import 'dart:io';

import 'package:Skype_clone/constants/strings.dart';
import 'package:Skype_clone/models/message.dart';
import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/provider/image_upload_provider.dart';
import 'package:Skype_clone/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as WebFirebase;
import 'package:firebase_storage/firebase_storage.dart';

WebFirebase.User webFirebaseUser;

class FirebaseMethods {
  final WebFirebase.Auth webAuth = WebFirebase.auth();
  WebFirebase.GoogleAuthProvider webGoogleSignIn;
  static final Firestore firestore = Firestore.instance;

  StorageReference _storageReference;

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

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    firestore
        .collection(MESSAGES_COLLECTION)
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    // Set some loading val ue to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    setImageMsg(url, receiverId, senderId);
  }
}
