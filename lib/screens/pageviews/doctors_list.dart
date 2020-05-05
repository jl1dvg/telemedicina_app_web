import 'dart:math';

import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/resources/auth_methods.dart';
import 'package:Skype_clone/screens/chatscreens/profile_screen.dart';
import 'package:Skype_clone/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:Skype_clone/theme/light_color.dart';
import 'package:Skype_clone/theme/text_styles.dart';
import 'package:Skype_clone/theme/extention.dart';
import 'package:flutter/material.dart';

class DoctorTile extends StatefulWidget {
  @override
  _DoctorTileState createState() => _DoctorTileState();
}

class _DoctorTileState extends State<DoctorTile> {
  AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    Color randomColor() {
      var random = Random();
      final colorList = [
        Theme.of(context).primaryColor,
        LightColor.orange,
        LightColor.green,
        LightColor.grey,
        LightColor.lightOrange,
        LightColor.skyBlue,
        LightColor.titleTextColor,
        Colors.red,
        Colors.brown,
        LightColor.purpleExtraLight,
        LightColor.skyBlue,
      ];
      var color = colorList[random.nextInt(colorList.length)];
      return color;
    }

    return Container(
      child: FutureBuilder(
          future: _authMethods.getTodosLosUsuarios(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading'),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  Usuario usuario = Usuario.fromMap(snapshot.data[index].data);
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewScreen(
                                      receiver: usuario,
                                    )));
                      },
                      leading: ClipRRect(
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: randomColor(),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                snapshot.data[index].data["profile_photo"],
                                height: 50,
                                width: 50,
                                fit: BoxFit.contain,
                              ),
                              OnlineDotIndicator(
                                uid: usuario.uid,
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: Text(snapshot.data[index].data["name"],
                          style: TextStyles.title.bold),
                      subtitle: Text(
                        usuario.email,
                        style: TextStyles.bodySm.subTitleColor.bold,
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
