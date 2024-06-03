// 🐦 Flutter imports:
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/screens/channel_list.dart';
import 'package:flutter_dogfooding/screens/profile/profile_widget.dart';
import 'package:flutter_dogfooding/screens/team/team_widget.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/screens/call_screen.dart';
import 'package:flutter_dogfooding/screens/home_screen.dart';
import 'package:flutter_dogfooding/screens/lobby_screen.dart';
import '../core/repos/app_preferences.dart';
import '../core/repos/token_service.dart';
import '../di/injector.dart';
import '../screens/channel_screen.dart';
import '../screens/code_verification/code_verification_page_widget.dart';
import '../screens/home_property/home_property_widget.dart';
import '../screens/login_screen.dart';
import '../screens/new_login/new_login_widget.dart';
import '../screens/thread_page.dart';

part 'routes.g.dart';

@immutable
@TypedGoRoute<HomeRoute>(path: '/home', name: 'home')
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    void connectChatUser() async {
      // final prefs = locator.get<AppPreferences>();
      // final credentials = prefs.userCredentials!;
      // final client = StreamChat.of(context).client;
      // try {
      //   final tokenResponse = await locator
      //       .get<TokenService>()
      //       .loadToken(userId: credentials.userInfo.id);
      //   final token = tokenResponse.token;
      //   // ignore: use_build_context_synchronously

      //   await client.connectUser(
      //     OwnUser(
      //       id: credentials.userInfo.id,
      //     ),
      //     token,
      //   );
      // } catch (error) {
      //   // Handle connection error
      //   print("Failed to connect user: $error");
      //   throw error; // Rethrow if you need to catch it outside
      // }
    }

    if (StreamChat.of(context).currentUser == null) {
      connectChatUser();
      return const HomeScreen();
    } else {
      return const HomeScreen();
    }
  }
}

@immutable
@TypedGoRoute<ChannelListRoute>(path: '/channelList', name: 'channelList')
class ChannelListRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChannelList();
  }
}

@immutable
@TypedGoRoute<ChannelPageRoute>(path: '/channel', name: 'channel')
class ChannelPageRoute extends GoRouteData {
  const ChannelPageRoute({required this.selectedMembers});

  final List<String?> selectedMembers;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChannelPage(
      selectedMembers: selectedMembers,
    );
  }
}

@immutable
@TypedGoRoute<ThreadPageRoute>(path: '/thread', name: 'thread')
class ThreadPageRoute extends GoRouteData {
  const ThreadPageRoute(
      {required this.parentMessage, required this.threadChannel});

  final Message parentMessage;
  final Channel threadChannel;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ThreadPage(
      parent: parentMessage,
      channel: threadChannel,
    );
  }
}

@immutable
@TypedGoRoute<HomePropertyRoute>(path: '/homeProperty', name: 'homeProperty')
class HomePropertyRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeProperty();
  }
}

@immutable
@TypedGoRoute<ProfileRoute>(path: '/profile', name: 'profile')
class ProfileRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileWidget();
  }
}

@immutable
@TypedGoRoute<TeamRoute>(path: '/team', name: 'team')
class TeamRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TeamWidget();
  }
}

@immutable
@TypedGoRoute<LoginRoute>(path: '/', name: 'login')
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewLoginScreen();
  }
}

@immutable
@TypedGoRoute<OTPRoute>(path: '/codeVerification', name: 'codeVerification')
class OTPRoute extends GoRouteData {
  const OTPRoute({required this.phoneNumber, required this.verificationId});

  final String? phoneNumber;
  final String? verificationId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // Correctly return the widget for OTP verification, passing parameters as needed
    return CodeVerificationPageWidget(
        phoneNumber: phoneNumber, verificationId: verificationId);
  }
}

@immutable
@TypedGoRoute<LobbyRoute>(path: '/lobby', name: 'lobby')
class LobbyRoute extends GoRouteData {
  const LobbyRoute({required this.$extra});

  final Call $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LobbyScreen(
      call: $extra,
      onJoinCallPressed: (connectOptions) {
        // Navigate to the call screen.
        CallRoute(
          $extra: (
            call: $extra,
            connectOptions: connectOptions,
          ),
        ).replace(context);
      },
    );
  }
}

@immutable
@TypedGoRoute<CallRoute>(path: '/call', name: 'call')
class CallRoute extends GoRouteData {
  const CallRoute({required this.$extra});

  final ({
    Call call,
    CallConnectOptions connectOptions,
  }) $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CallScreen(
      call: $extra.call,
      connectOptions: $extra.connectOptions,
    );
  }
}
