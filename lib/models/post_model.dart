import 'package:free_swingers_dating/models/post_comment_model.dart';
import 'package:free_swingers_dating/models/post_like_model.dart';
import 'package:free_swingers_dating/models/post_share_model.dart';
import 'package:free_swingers_dating/models/user_model.dart';

class PostModel {
  final String postId;
  final String userId;
  final String? caption;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<String> media;
  final UserModel user;
  final List<PostLikeModel> likes;
  final List<PostCommentModel> comments;
  final List<PostShareModel> shares;

  PostModel({
    required this.postId,
    required this.userId,
    this.caption,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.media,
    required this.user,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      media: List<String>.from(json['media'] as List<dynamic>),
      user: UserModel.fromJson(json['user']),
      likes: (json['likes'] as List<dynamic>)
          .map((likeJson) => PostLikeModel.fromJson(likeJson))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) => PostCommentModel.fromJson(commentJson))
          .toList(),
      shares: (json['shares'] as List<dynamic>)
          .map((shareJson) => PostShareModel.fromJson(shareJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'caption': caption,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'media': media,
      'user': user.toJson(),
      'likes': likes.map((like) => like.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'shares': shares.map((share) => share.toJson()).toList(),
    };
  }
}
