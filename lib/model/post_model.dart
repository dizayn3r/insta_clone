import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? id;
  String? imageUrl;
  String? caption;
  Timestamp? createdAt;
  String? name;

  PostModel({
    this.id,
    this.imageUrl,
    this.caption,
    this.name,
    this.createdAt,
  });

  // receiving data from server
  factory PostModel.fromMap(map) {
    return PostModel(
      imageUrl: map['imageUrl'],
      id: map['id'],
      caption: map['caption'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'caption': caption,
      'name': name,
      'createdAt': createdAt,
    };
  }
}
