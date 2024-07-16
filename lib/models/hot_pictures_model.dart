class HotPicturesModel {
  final String mediaUrl;
  final String identity;
  final DateTime createdAt;
  final String userId;
  final String username;
  final String profileImage;
  final String firstname;
  final String lastname;

  HotPicturesModel({
    required this.mediaUrl,
    required this.identity,
    required this.createdAt,
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.firstname,
    required this.lastname,
  });

  factory HotPicturesModel.fromJson(Map<String, dynamic> json) {
    return HotPicturesModel(
      mediaUrl: json['media_url'],
      identity: json['identity'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      username: json['username'],
      profileImage: json['profile_image'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_url': mediaUrl,
      'identity': identity,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'username': username,
      'profile_image': profileImage,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
