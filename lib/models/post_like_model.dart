import 'package:free_swingers_dating/models/user_model.dart';

class PostLikeModel {
  String likeId;
  String postId;
  String likerId;
  int likedStatus;
  UserModel likerDetails;

  PostLikeModel({
    required this.likeId,
    required this.postId,
    required this.likerId,
    required this.likedStatus,
    required this.likerDetails,
  });

  factory PostLikeModel.fromJson(Map<String, dynamic> json) {
    return PostLikeModel(
      likeId: json['like_id'],
      postId: json['post_id'],
      likerId: json['liker_id'],
      likedStatus: json['liked_status'],
      likerDetails: UserModel.fromJson(json['liker_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'like_id': likeId,
      'post_id': postId,
      'liker_id': likerId,
      'liked_status': likedStatus,
      'liker_details': likerDetails.toJson(),
    };
  }
}
