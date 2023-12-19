import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;

  const UserModel({
    required this.id,
    required this.name,
  });

  toJson() => {
    'id': id,
    'Name': name,
  };

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return UserModel(
      id: data['id'],
      name: data['displayName'],
    );
  }
}
