//User Model

import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  String songUrl;
  DateTime date;
  String name;
  int size;
  int likes;

  SongModel({
    this.songUrl,
    this.date,
    this.name,
    this.size,
    this.likes,
  });

  factory SongModel.fromMap(Map data) {
    return SongModel(
      songUrl: data['songUrl'] ?? '',
      size: data['size'],
      name: data['name'] ?? '',
      date: data['date'],
      likes: data['likes'] ?? 0,
    );
  }

  factory SongModel.fromfirestore(QueryDocumentSnapshot querySnapshot) {
    var map = querySnapshot.data();
    return SongModel(
      songUrl: map['songUrl'] ?? '',
      size: map['size'],
      name: map['name'] ?? '',
      date: map['date'],
      likes: map['likes'],
    );
  }

  Map<String, dynamic> toJson() => {
        "songUrl": songUrl,
        "date": date,
        "size": size,
        "name": name,
        "likes": likes,
      };
}
