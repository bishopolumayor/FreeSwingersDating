import 'package:free_swingers_dating/screens/account/my_account.dart';
import 'package:free_swingers_dating/screens/chat/messages_screen.dart';
import 'package:free_swingers_dating/screens/clubs/clubs_screen.dart';
import 'package:free_swingers_dating/screens/events/events_screen.dart';
import 'package:free_swingers_dating/screens/friends/friends_screen.dart';
import 'package:free_swingers_dating/screens/home/home.dart';
import 'package:free_swingers_dating/screens/home_page.dart';
import 'package:free_swingers_dating/screens/hot_pictures/hot_pictures_screen.dart';
import 'package:free_swingers_dating/screens/looked_at_me/looked_at_me_screen.dart';
import 'package:free_swingers_dating/screens/settings/account_settings_screen.dart';
import 'package:free_swingers_dating/screens/settings/change_password_screen.dart';
import 'package:free_swingers_dating/screens/settings/change_username_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String homePage = '/home-page';
  static const String homeScreen = '/home';
  static const String messagesScreen = '/messages-screen';
  static const String myAccountsScreen = '/my-accounts-screen';
  static const String accountSettingsScreen = '/account-settings';
  static const String friendsPage = '/friends-page';
  static const String hotPictures = '/hot-pictures';
  static const String clubsScreen = '/clubs';
  static const String eventsScreen = '/events';
  static const String lookedAtMeScreen = '/looked-at-me';
  static const String changeUsernameScreen = '/change-username';
  static const String changePasswordScreen = '/change-password';

  static String getHomepage() => '$homePage';
  static String getHomeScreen() => '$homeScreen';
  static String getMessagesScreen() => '$messagesScreen';
  static String getMyAccountScreen() => '$myAccountsScreen';
  static String getAccountSettings() => '$accountSettingsScreen';
  static String getFriendsPage() => '$friendsPage';
  static String getHotPictures() => '$hotPictures';
  static String getClubsScreen() => '$clubsScreen';
  static String getEventsScreen() => '$eventsScreen';
  static String getLookedAtMeScreen() => '$lookedAtMeScreen';
  static String getChangeUsernameScreen() => '$changeUsernameScreen';
  static String getChangePasswordScreen() => '$changePasswordScreen';

  static final routes = [
    GetPage(
      name: homePage,
      page: () {
        return const HomePage();
      },
    ),
    GetPage(
      name: homeScreen,
      page: () {
        return const HomeScreen();
      },
    ),
    GetPage(
      name: messagesScreen,
      page: () {
        return const MessagesScreen();
      },
    ),
    GetPage(
      name: myAccountsScreen,
      page: () {
        return const MyAccount();
      },
    ),
    GetPage(
      name: accountSettingsScreen,
      page: () {
        return const AccountSettingsScreen();
      },
    ),
    GetPage(
      name: friendsPage,
      page: () {
        return const FriendsScreen();
      },
    ),
    GetPage(
      name: hotPictures,
      page: () {
        return const HotPicturesScreen();
      },
    ),
    GetPage(
      name: clubsScreen,
      page: () {
        return const ClubsScreen();
      },
    ),
    GetPage(
      name: eventsScreen,
      page: () {
        return const EventsScreen();
      },
    ),
    GetPage(
      name: lookedAtMeScreen,
      page: () {
        return const LookedAtMeScreen();
      },
    ),
    GetPage(
      name: changeUsernameScreen,
      page: () {
        return const ChangeUserNameScreen();
      },
    ),
    GetPage(
      name: changePasswordScreen,
      page: () {
        return const ChangePasswordScreen();
      },
    ),
  ];
}