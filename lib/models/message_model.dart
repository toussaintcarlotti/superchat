import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class MessageModel {
  final String from;
  final String to;
  final String content;
  final DateTime createdAt;
  late String authorName;

  MessageModel({
    required this.from,
    required this.to,
    required this.content,
    required this.createdAt,
    this.authorName = '',
  });

  toJson() => {
        'From': from,
        'To': to,
        'Message': content,
        'CreatedAt': createdAt,
        'AuthorName': authorName,
      };

  factory MessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return MessageModel(
      from: data['from'],
      to: data['to'],
      content: data['content'],
      createdAt: data['timestamp'].toDate(),
    );
  }

  types.TextMessage toChatUiMessage() {
    return types.TextMessage(
        id: Uuid().v4(),
        author: types.User(
          id: from,
          firstName: authorName,
        ),
        text: content,
        createdAt: createdAt.millisecondsSinceEpoch
    );
  }
}
