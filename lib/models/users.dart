class Usuario {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  Usuario({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
  });

  Map toMap(Usuario usuario) {
    var data = Map<String, dynamic>();
    data['uid'] = usuario.uid;
    data['name'] = usuario.name;
    data['email'] = usuario.email;
    data['username'] = usuario.username;
    data["status"] = usuario.status;
    data["state"] = usuario.state;
    data["profile_photo"] = usuario.profilePhoto;
    return data;
  }

  Usuario.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }
} 