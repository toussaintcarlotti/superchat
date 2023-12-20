import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String? bio;

  const UserModel({
    required this.id,
    required this.name,
    this.bio,
  });

  toJson() => {
        'id': id,
        'displayName': name,
        'bio': bio,
      };

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return UserModel(
      id: data['id'],
      name: data['displayName'],
      bio: data['bio'],
    );
  }
}
