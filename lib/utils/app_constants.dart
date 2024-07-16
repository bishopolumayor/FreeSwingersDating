class AppConstants {

  // basic
  static const String APP_NAME = "Free Swingers";

  // static const String BASE_URL = "https://api.freeswingers.net";
  static const String BASE_URL = "http://localhost:3000";

  static const String REMEMBER_KEY = 'remember-me';
  static const String USER_KEY = "user-key";
  static const String SELECTED_USER_KEY = "selected-user-key";

  // auth
  static const String TOKEN = "token";
  static const String SIGN_UP_URI = "/api/users/signup";
  static const String LOGIN_URI = "/api/users/login";

  static const String TOTAL_USERS_URI = "/api/total-users";

  static const String CHANGE_USERNAME_URI = "/api/users/change-username";
  static const String CHANGE_PASSWORD_URI = "/api/users/change-password";

  // posts
  static const String UPLOAD_POST_URI = "/api/users/upload-post";
  static const String UPLOAD_STORY_URI = "/api/users/upload-story";
  static const String GET_POST_URI = "/api/users/posts";
  static const String GET_STORY_URI = "/api/users/stories";
  static const String GET_HOT_PICTURES = "/api/users/hot-pictures";

  // user
  static const String USER_URI = '/api/users';
  static const String GET_USER = '/api/user';
  static const String UPDATE_USER_DETAILS_URI = '/api/users/update-details';
  static const String GET_MEDIA_URI = '/api/media';

  // messaging
  static const String CONVERSATIONS_URI = '/api/conversations';
  static const String MESSAGES_URI = '/api/messages';

  // friends
  static const String GET_FRIENDS_URI = '/api/friends';
  static const String GET_FRIEND_REQUESTS_URI = '/api/getFriendRequests';
  static const String RESPOND_FRIEND_REQUESTS_URI = '/api/respondToFriendRequest';
  static const String SEND_FRIEND_REQUEST_URI = '/api/sendFriendRequest';

  // clubs
  static const String CREATE_CLUB_URI = '/api/create-club';
  static const String REVIEW_CLUB_URI = '/api/clubs/review';
  static const String GET_CLUBS_URI = '/api/clubs';

  static const String LOOKS_URI = '/api/looks';
}