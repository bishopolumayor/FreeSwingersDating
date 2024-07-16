class PostShareModel {
  String shareId;
  String shareUser;
  String sharedTo;
  DateTime createdAt;
  DateTime updatedAt;

  PostShareModel({
    required this.shareId,
    required this.shareUser,
    required this.sharedTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostShareModel.fromJson(Map<String, dynamic> json) {
    return PostShareModel(
      shareId: json['share_id'] as String,
      shareUser: json['share_user'] as String,
      sharedTo: json['shared_to'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'share_id': shareId,
      'share_user': shareUser,
      'shared_to': sharedTo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}