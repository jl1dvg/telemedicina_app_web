import 'dart:math';

import 'package:Skype_clone/models/users.dart';
import 'package:Skype_clone/provider/user_provider.dart';
import 'package:Skype_clone/resources/auth_methods.dart';
import 'package:Skype_clone/screens/chatscreens/profile_screen.dart';
import 'package:Skype_clone/screens/pageviews/doctors_list.dart';
import 'package:Skype_clone/screens/pageviews/widgets/user_circle.dart';
import 'package:Skype_clone/theme/light_color.dart';
import 'package:Skype_clone/theme/text_styles.dart';
import 'package:Skype_clone/theme/theme.dart';
import 'package:Skype_clone/theme/extention.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactoScreen extends StatefulWidget {
  @override
  _ContactoScreenState createState() => _ContactoScreenState();
}

class _ContactoScreenState extends State<ContactoScreen> {
  homeAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.short_text,
          size: 30,
          color: LightColor.grey,
        ),
        onPressed: () {},
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            size: 30,
            color: LightColor.grey,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          child: Container(
            // height: 40,
            // width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: Image.asset("assets/logo.png", fit: BoxFit.fill),
          ),
        ).p(8)
      ],
    );
  }

  _searchField() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
          decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: InputBorder.none,
        hintText: "Buscar",
        hintStyle: TextStyles.body.subTitleColor,
        suffixIcon: SizedBox(
            width: 50,
            child: Icon(Icons.search, color: LightColor.purple)
                .alignCenter
                .ripple(() {}, borderRadius: BorderRadius.circular(13))),
      )),
    );
  }

  _category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Categoria", style: TextStyles.title.bold),
              Text(
                "See All",
                style: TextStyles.titleNormal
                    .copyWith(color: Theme.of(context).primaryColor),
              ).p(8)
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _categoryCard("Chemist & Drugist", "350 + Stores",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              _categoryCard("Covid - 19 Specilist", "899 Doctors",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
              _categoryCard("Cardiologists Specilist", "500 + Doctors",
                  color: LightColor.orange, lightColor: LightColor.lightOrange)
            ],
          ),
        ),
      ],
    );
  }

  _categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 4 / 4,
      child: Container(
        height: 70,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Text(title, style: titleStyle).hP8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: subtitleStyle,
                      ).hP8,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: homeAppBar(),
      body: Container(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2),
            child: HeaderHomePage(),
          ),
          _searchField(),
          _category(),
          Expanded(child: DoctorTile())
        ],
      )),
    );
  }
}

class HeaderHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hola,", style: TextStyles.title.subTitleColor),
        Text(userProvider.getUser.name, style: TextStyles.h1Style),
      ],
    ).p(16);
  }
}
