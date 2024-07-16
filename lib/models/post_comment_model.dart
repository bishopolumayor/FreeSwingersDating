import 'package:free_swingers_dating/models/user_model.dart';

class PostCommentModel {
  String commentId;
  String comment;
  UserModel commenter;
  DateTime createdAt;
  DateTime updatedAt;

  PostCommentModel({
    required this.commentId,
    required this.comment,
    required this.commenter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
      commentId: json['comment_id'] as String,
      comment: json['comment'] as String,
      commenter: UserModel.fromJson(json['commenter']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'comment': comment,
      'commenter': commenter.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
