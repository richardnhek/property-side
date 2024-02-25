import 'package:flutter/widgets.dart';

class FFIcons {
  FFIcons._();

  static const String _homeIconFamily = 'HomeIcon';
  static const String _navbarIconsFamily = 'NavbarIcons';
  static const String _navbarIconsActiveFamily = 'NavbarIconsActive';
  static const String _detailIconsFamily = 'DetailIcons';
  static const String _othersFamily = 'Others';
  static const String _messageActionFamily = 'MessageAction';

  // home-icon
  static const IconData kicon = IconData(0xe900, fontFamily: _homeIconFamily);

  // navbar-icons
  static const IconData kchat =
      IconData(0xe901, fontFamily: _navbarIconsFamily);
  static const IconData krefer =
      IconData(0xe902, fontFamily: _navbarIconsFamily);
  static const IconData kservices =
      IconData(0xe903, fontFamily: _navbarIconsFamily);

  // navbar-icons-active
  static const IconData kchatActive =
      IconData(0xe900, fontFamily: _navbarIconsActiveFamily);
  static const IconData khomeActive =
      IconData(0xe901, fontFamily: _navbarIconsActiveFamily);
  static const IconData kservicesActive =
      IconData(0xe902, fontFamily: _navbarIconsActiveFamily);

  // detail-icons
  static const IconData kadd = IconData(0xe900, fontFamily: _detailIconsFamily);
  static const IconData kmute =
      IconData(0xe901, fontFamily: _detailIconsFamily);
  static const IconData kpin = IconData(0xe902, fontFamily: _detailIconsFamily);

  // others
  static const IconData klogout = IconData(0xe902, fontFamily: _othersFamily);

  // message-action
  static const IconData kicon13 =
      IconData(0xe900, fontFamily: _messageActionFamily);
  static const IconData kicon15 =
      IconData(0xe901, fontFamily: _messageActionFamily);
  static const IconData kicon16 =
      IconData(0xe902, fontFamily: _messageActionFamily);
  static const IconData kicon17 =
      IconData(0xe903, fontFamily: _messageActionFamily);
}
