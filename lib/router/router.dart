// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/di/injector.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/router/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../app/user_auth_controller.dart';
import '../app_state.dart';
import '../flutter_flow/custom_icons.dart';
import '../flutter_flow/flutter_flow_theme.dart';

GoRouter initRouter(UserAuthController authNotifier) {
  // Add this within initRouter function or as a global list depending on your preference.

  return GoRouter(
    routes: [
      ShellRoute(
        routes: [
          $homeRoute,
          $lobbyRoute,
          $callRoute,
          $channelListRoute,
          $homePropertyRoute,
          $teamRoute,
          $profileRoute
        ],
        builder: (context, state, child) {
          // Current index for BottomNavigationBar
          int currentIndex = 0;
          // Determine the current index based on state
          if (state.matchedLocation == HomeRoute().location) {
            currentIndex = 0;
          } else if (state.matchedLocation == ChannelListRoute().location) {
            currentIndex = 1;
          } else if (state.matchedLocation == HomePropertyRoute().location) {
            currentIndex = 2;
          } else if (state.matchedLocation == TeamRoute().location) {
            currentIndex = 3;
          } else if (state.matchedLocation == ProfileRoute().location) {
            currentIndex = 4;
          }

          return StreamChat(
            client: locator.get(),
            streamChatThemeData: StreamChatThemeData.light(),
            child: Scaffold(
                body: child,
                backgroundColor: Colors.white,
                bottomNavigationBar: SizedBox(
                  height: 85.0,
                  child: FFAppState().showBottomNav == true
                      ? BottomNavigationBar(
                          currentIndex: currentIndex,
                          onTap: (index) {
                            // Logic to navigate based on the index
                            if (index == 0) {
                              context.go(HomeRoute().location);
                            } else if (index == 1) {
                              context.go(ChannelListRoute().location);
                            } else if (index == 2) {
                              context.go(HomePropertyRoute().location);
                            } else if (index == 3) {
                              context.go(TeamRoute().location);
                            } else if (index == 4) {
                              context.go(ProfileRoute().location);
                            }
                          },
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          selectedItemColor:
                              FlutterFlowTheme.of(context).primary,
                          unselectedItemColor: const Color(0xFFAAAAAA),
                          showSelectedLabels: true,
                          showUnselectedLabels: true,
                          unselectedFontSize: 10,
                          selectedFontSize: 10,
                          unselectedLabelStyle: GoogleFonts.inter(
                              height: 1.5, fontWeight: FontWeight.w400),
                          selectedLabelStyle: GoogleFonts.inter(
                              height: 1.5, fontWeight: FontWeight.w400),
                          type: BottomNavigationBarType.fixed,
                          items: const <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.developer_mode,
                                size: 18.0,
                              ),
                              activeIcon: Icon(
                                Icons.developer_mode,
                                size: 18.0,
                              ),
                              label: 'Beta',
                              tooltip: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                FFIcons.kchat,
                                size: 18.0,
                              ),
                              activeIcon: Icon(
                                FFIcons.kchatActive,
                                size: 18.0,
                              ),
                              label: 'Chats',
                              tooltip: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                FFIcons.kicon,
                                size: 18.0,
                              ),
                              activeIcon: Icon(
                                FFIcons.khomeActive,
                                size: 18.0,
                              ),
                              label: 'Search',
                              tooltip: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.group_outlined,
                                size: 18.0,
                              ),
                              activeIcon: Icon(
                                Icons.group,
                                size: 18.0,
                              ),
                              label: 'Team',
                              tooltip: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.person_outline,
                                size: 18.0,
                              ),
                              activeIcon: Icon(
                                Icons.person,
                                size: 18.0,
                              ),
                              label: 'Profile',
                              tooltip: '',
                            ),
                          ],
                        )
                      : null,
                )),
          );
        },
      ),
      $loginRoute,
    ],
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final currentUser = authNotifier.currentUser;
      final bool loggedIn = currentUser != null;
      final bool loggingIn = state.matchedLocation == LoginRoute().location;
      if (!loggedIn && !loggingIn) return LoginRoute().location;
      if (loggedIn && loggingIn) return HomeRoute().location;
      return null;
    },
  );
}
