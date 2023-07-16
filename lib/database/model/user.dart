class User {
  //Data class
  static const String collectionName = 'User';
  String? id;
  String? name;
  String? email;

  User({this.name, this.id, this.email});

  User.formeFireStore(Map<String, dynamic>? data)
      : this(id: data?['id'], name: data?['name'], email: data?['email']);

  // {
  //   id = data["id"];
  //   name = data["name"];
  //   email = data["email"];
  // }
  Map<String, dynamic> toFireStore() {
    return {"id": id, "name": name, "email": email};
  }
}
