import 'package:free_swingers_dating/models/user_model.dart';

class StoryModel {
  final String storyId;
  final String userId;
  final String caption;
  final String? media;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final UserModel user;

  StoryModel({
    required this.storyId,
    required this.userId,
    required this.caption,
    this.media,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.user,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      storyId: json['story_id'] as String,
      userId: json['user_id'] as String,
      caption: json['caption'] as String,
      media: json['media'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story_id': storyId,
      'user_id': userId,
      'caption': caption,
      'media': media,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'user' : user.toJson(),
    };
  }
}
