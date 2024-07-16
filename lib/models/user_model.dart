class UserModel {
  final String userId;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String identity;
  final String? profileImage;
  final int status;
  final bool isActive;
  final bool isVerified;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    required this.identity,
    this.profileImage,
    required this.status,
    required this.isActive,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? json['user_id'],
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstname'] as String?,
      lastName: json['lastname'] as String?,
      identity: json['identity'] as String,
      profileImage: json['profile_image'] as String?,
      status: json['status'] as int,
      isActive: json['isActive'] == 1,
      isVerified: json['isVerified'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'firstname': firstName,
      'lastname': lastName,
      'identity': identity,
      'profile_image': profileImage,
      'status': status,
      'isActive': isActive ? 1 : 0,
      'isVerified': isVerified ? 1 : 0,
    };
  }
}