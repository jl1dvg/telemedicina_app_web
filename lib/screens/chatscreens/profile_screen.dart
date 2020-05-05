import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/resources/auth_methods.dart';
import 'package:Skype_clone/utils/call_utilities.dart';
import 'package:Skype_clone/utils/universal_variables.dart';
import 'package:Skype_clone/widgets/appbar.dart';
import 'package:Skype_clone/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final Usuario receiver;

  PreviewScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<PreviewScreen> {
  TextEditingController textFieldController = TextEditingController();
  AuthMethods _authMethods = AuthMethods();


  Usuario sender;

  String _currentUserId;

  bool isWriting = false;

  @override
  void initState() {
    super.initState();

    _authMethods.getCurrentUser().then((usuario) {
      _currentUserId = usuario.uid;

      setState(() {
        sender = Usuario(
          uid: usuario.uid,
          name: usuario.displayName,
          profilePhoto: usuario.photoURL,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  widget.receiver.profilePhoto,
                  width: 100,
                ),
              ),
              Text("calling"),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () => CallUtils.dial(
                  from: sender,
                  to: widget.receiver,
                  context: context,
                ),
                backgroundColor: Colors.green,
                child: Icon(Icons.video_call),
              )
            ],
          ),
        ));
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () => CallUtils.dial(
            from: sender,
            to: widget.receiver,
            context: context,
          ),
        ),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
