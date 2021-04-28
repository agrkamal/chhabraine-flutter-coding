//User Model

class UserModel {
  String uid;
  String email;
  String name;
  String gender;
  num age;
  String photoUrl;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.age,
    this.photoUrl,
    this.gender,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      age: data['age'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "age": age,
        "email": email,
        "name": name,
        "photoUrl": photoUrl,
        "gender": gender,
      };
}
