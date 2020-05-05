import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class ContactoItems extends StatelessWidget {
  AuthMethods _authMethods = AuthMethods();
  

  final Usuario usuario;
  ContactoItems({this.usuario});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(usuario.profilePhoto),
      ),
      title: Text(usuario.name),
      subtitle: Text(usuario.email),
    );
  }
}
