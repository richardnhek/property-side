// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $channelListRoute,
      $channelPageRoute,
      $homePropertyRoute,
      $profileRoute,
      $teamRoute,
      $loginRoute,
      $oTPRoute,
      $lobbyRoute,
      $callRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/home',
      name: 'home',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $channelListRoute => GoRouteData.$route(
      path: '/channelList',
      name: 'channelList',
      factory: $ChannelListRouteExtension._fromState,
    );

extension $ChannelListRouteExtension on ChannelListRoute {
  static ChannelListRoute _fromState(GoRouterState state) => ChannelListRoute();

  String get location => GoRouteData.$location(
        '/channelList',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $channelPageRoute => GoRouteData.$route(
      path: '/channel',
      name: 'channel',
      factory: $ChannelPageRouteExtension._fromState,
    );

extension $ChannelPageRouteExtension on ChannelPageRoute {
  static ChannelPageRoute _fromState(GoRouterState state) => ChannelPageRoute(
        selectedMembers: state.uri.queryParametersAll['selected-members']!
            .map((e) => e)
            .toList(),
      );

  String get location => GoRouteData.$location(
        '/channel',
        queryParams: {
          'selected-members': selectedMembers.map((e) => e).toList(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homePropertyRoute => GoRouteData.$route(
      path: '/homeProperty',
      name: 'homeProperty',
      factory: $HomePropertyRouteExtension._fromState,
    );

extension $HomePropertyRouteExtension on HomePropertyRoute {
  static HomePropertyRoute _fromState(GoRouterState state) =>
      HomePropertyRoute();

  String get location => GoRouteData.$location(
        '/homeProperty',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      name: 'profile',
      factory: $ProfileRouteExtension._fromState,
    );

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $teamRoute => GoRouteData.$route(
      path: '/team',
      name: 'team',
      factory: $TeamRouteExtension._fromState,
    );

extension $TeamRouteExtension on TeamRoute {
  static TeamRoute _fromState(GoRouterState state) => TeamRoute();

  String get location => GoRouteData.$location(
        '/team',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/',
      name: 'login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $oTPRoute => GoRouteData.$route(
      path: '/codeVerification',
      name: 'codeVerification',
      factory: $OTPRouteExtension._fromState,
    );

extension $OTPRouteExtension on OTPRoute {
  static OTPRoute _fromState(GoRouterState state) => OTPRoute(
        phoneNumber: state.uri.queryParameters['phone-number'],
        verificationId: state.uri.queryParameters['verification-id'],
      );

  String get location => GoRouteData.$location(
        '/codeVerification',
        queryParams: {
          if (phoneNumber != null) 'phone-number': phoneNumber,
          if (verificationId != null) 'verification-id': verificationId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $lobbyRoute => GoRouteData.$route(
      path: '/lobby',
      name: 'lobby',
      factory: $LobbyRouteExtension._fromState,
    );

extension $LobbyRouteExtension on LobbyRoute {
  static LobbyRoute _fromState(GoRouterState state) => LobbyRoute(
        $extra: state.extra as Call,
      );

  String get location => GoRouteData.$location(
        '/lobby',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $callRoute => GoRouteData.$route(
      path: '/call',
      name: 'call',
      factory: $CallRouteExtension._fromState,
    );

extension $CallRouteExtension on CallRoute {
  static CallRoute _fromState(GoRouterState state) => CallRoute(
        $extra: state.extra as ({Call call, CallConnectOptions connectOptions}),
      );

  String get location => GoRouteData.$location(
        '/call',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
