import 'package:free_swingers_dating/models/user_model.dart';

class MessageModel {
  String messageId;
  String conversationId;
  String text;
  String? media;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel sender;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.text,
    this.media,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'],
      conversationId: json['conversation_id'],
      text: json['text'],
      media: json['media'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sender: UserModel.fromJson(json['sender']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'conversation_id': conversationId,
      'text': text,
      'media': media,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sender': sender.toJson(),
    };
  }
}
