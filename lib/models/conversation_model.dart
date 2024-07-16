import 'package:free_swingers_dating/models/user_model.dart';

class ConversationModel {
  String conversationId;
  UserModel secondUser;
  String? lastMessage;

  ConversationModel({
    required this.conversationId,
    required this.secondUser,
     this.lastMessage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversation_id'],
      secondUser:  UserModel.fromJson(json['second_user']),
      lastMessage: json['last_message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'second_user': secondUser.toJson(),
      'last_message': lastMessage,
    };
  }
}
