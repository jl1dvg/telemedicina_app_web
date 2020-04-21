import 'dart:math';

import 'package:flutter/material.dart';
import 'package:telemedicina/models/call.dart';
import 'package:telemedicina/models/users.dart';
import 'package:telemedicina/screens/callscreens/call_screen.dart';
import 'package:telemedicina/services/call_methods.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({Usuario from, Usuario to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
