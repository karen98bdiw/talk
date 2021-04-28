class User {
  String id;
  String email;
  String nickName;
  String imageLink;

  User({
    this.id,
    this.email,
    this.imageLink,
    this.nickName,
  });

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();

    data["id"] = this.id;
    data["email"] = this.email;
    data["nickName"] = this.nickName;
    data["imageLink"] = this.imageLink;

    return data;
  }

  factory User.fromJson(json) {
    return User(
      id: json["id"],
      email: json["email"],
      imageLink: json["imageLink"],
      nickName: json["nickName"],
    );
  }
}
