import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/lat_lng.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _pinnedChatRef =
          prefs.getString('ff_pinnedChatRef')?.ref ?? _pinnedChatRef;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  DocumentReference? _currentChatRef;
  DocumentReference? get currentChatRef => _currentChatRef;
  set currentChatRef(DocumentReference? value) {
    _currentChatRef = value;
  }

  DocumentReference? _currentChatUserRef;
  DocumentReference? get currentChatUserRef => _currentChatUserRef;
  set currentChatUserRef(DocumentReference? value) {
    _currentChatUserRef = value;
  }

  String _currentMainView = '';
  String get currentMainView => _currentMainView;
  set currentMainView(String value) {
    _currentMainView = value;
  }

  bool _showBottomNav = true;
  bool get showBottomNav => _showBottomNav;
  set showBottomNav(bool value) {
    _showBottomNav = value;
  }

  DocumentReference? _selectedMembers;
  DocumentReference? get selectedMembers => _selectedMembers;
  set selectedMembers(DocumentReference? value) {
    _selectedMembers = value;
  }

  String _mainNavView = '';
  String get mainNavView => _mainNavView;
  set mainNavView(String value) {
    _mainNavView = value;
  }

  DocumentReference? _pinnedChatRef;
  DocumentReference? get pinnedChatRef => _pinnedChatRef;
  set pinnedChatRef(DocumentReference? value) {
    _pinnedChatRef = value;
    value != null
        ? prefs.setString('ff_pinnedChatRef', value.path)
        : prefs.remove('ff_pinnedChatRef');
  }

  DocumentReference? _forwardMessageRef;
  DocumentReference? get forwardMessageRef => _forwardMessageRef;
  set forwardMessageRef(DocumentReference? value) {
    _forwardMessageRef = value;
  }

  DocumentReference? _forwardToRef;
  DocumentReference? get forwardToRef => _forwardToRef;
  set forwardToRef(DocumentReference? value) {
    _forwardToRef = value;
  }

  User? _currentChatUser;
  User? get currentChatUser => _currentChatUser;
  set currentChatUser(User? value) {
    _currentChatUser = value;
  }

  final _allChatsQueryCacheManager = StreamRequestManager<List<ChatsRecord>>();
  Stream<List<ChatsRecord>> allChatsQueryCache({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<ChatsRecord>> Function() requestFn,
  }) =>
      _allChatsQueryCacheManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAllChatsQueryCacheCache() => _allChatsQueryCacheManager.clear();
  void clearAllChatsQueryCacheCacheKey(String? uniqueKey) =>
      _allChatsQueryCacheManager.clearRequest(uniqueKey);
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
