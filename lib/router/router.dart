// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/di/injector.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/router/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../app/user_auth_controller.dart';

GoRouter initRouter(UserAuthController authNotifier) {
  return GoRouter(
    routes: [
      ShellRoute(
        routes: [$homeRoute, $lobbyRoute, $callRoute, $channelListRoute],
        builder: (context, state, child) {
          // Current index for BottomNavigationBar
          int currentIndex = 0;
          // Determine the current index based on state
          if (state.matchedLocation == HomeRoute().location) {
            currentIndex = 0;
          } else if (state.matchedLocation == ChannelListRoute().location) {
            currentIndex = 1;
          }

          return StreamChat(
            client: locator.get(),
            streamChatThemeData: StreamChatThemeData.dark(),
            child: Scaffold(
                body: child,
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    // Logic to navigate based on the index
                    if (index == 0) {
                      context.go(HomeRoute().location);
                    } else if (index == 1) {
                      context.go(ChannelListRoute().location);
                    }
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble),
                      label: 'Chat',
                    ),
                  ],
                )),
          );
        },
      ),
      $loginRoute,
    ],
    refreshListenable: authNotifier,
    redirect: (context, state) {
      // get the current user
      final currentUser = authNotifier.currentUser;

      // if the user is not logged in, they need to login
      final bool loggedIn = currentUser != null;
      final bool loggingIn = state.matchedLocation == LoginRoute().location;
      if (!loggedIn && !loggingIn) return LoginRoute().location;
      if (loggedIn && loggingIn) return HomeRoute().location;

      // no need to redirect at all
      return null;
    },
  );
}
