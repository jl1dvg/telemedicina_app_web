import 'package:flutter/material.dart';

class Medicos {
  final String email;
  final String name;
  final String status;
  final String profile_photo;
  Medicos(
      {@required this.name,
      @required this.email,
      @required this.status,
      @required this.profile_photo})
      : assert(email != null),
        assert(name != null),
        assert(status != null),
        assert(profile_photo != null);
}
