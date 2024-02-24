import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class ChatsRecord extends FirestoreRecord {
  ChatsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "users" field.
  List<DocumentReference>? _users;
  List<DocumentReference> get users => _users ?? const [];
  bool hasUsers() => _users != null;

  // "user_a" field.
  DocumentReference? _userA;
  DocumentReference? get userA => _userA;
  bool hasUserA() => _userA != null;

  // "user_b" field.
  DocumentReference? _userB;
  DocumentReference? get userB => _userB;
  bool hasUserB() => _userB != null;

  // "last_message" field.
  String? _lastMessage;
  String get lastMessage => _lastMessage ?? '';
  bool hasLastMessage() => _lastMessage != null;

  // "last_message_time" field.
  DateTime? _lastMessageTime;
  DateTime? get lastMessageTime => _lastMessageTime;
  bool hasLastMessageTime() => _lastMessageTime != null;

  // "last_message_sent_by" field.
  DocumentReference? _lastMessageSentBy;
  DocumentReference? get lastMessageSentBy => _lastMessageSentBy;
  bool hasLastMessageSentBy() => _lastMessageSentBy != null;

  // "last_message_seen_by" field.
  List<DocumentReference>? _lastMessageSeenBy;
  List<DocumentReference> get lastMessageSeenBy =>
      _lastMessageSeenBy ?? const [];
  bool hasLastMessageSeenBy() => _lastMessageSeenBy != null;

  // "chat_type" field.
  String? _chatType;
  String get chatType => _chatType ?? '';
  bool hasChatType() => _chatType != null;

  // "workspace_id" field.
  String? _workspaceId;
  String get workspaceId => _workspaceId ?? '';
  bool hasWorkspaceId() => _workspaceId != null;

  // "channel_name" field.
  String? _channelName;
  String get channelName => _channelName ?? '';
  bool hasChannelName() => _channelName != null;

  // "workspace_ref" field.
  DocumentReference? _workspaceRef;
  DocumentReference? get workspaceRef => _workspaceRef;
  bool hasWorkspaceRef() => _workspaceRef != null;

  // "chat_ref" field.
  DocumentReference? _chatRef;
  DocumentReference? get chatRef => _chatRef;
  bool hasChatRef() => _chatRef != null;

  // "pinnedBy" field.
  List<DocumentReference>? _pinnedBy;
  List<DocumentReference> get pinnedBy => _pinnedBy ?? const [];
  bool hasPinnedBy() => _pinnedBy != null;

  // "archivedBy" field.
  List<DocumentReference>? _archivedBy;
  List<DocumentReference> get archivedBy => _archivedBy ?? const [];
  bool hasArchivedBy() => _archivedBy != null;

  void _initializeFields() {
    _users = getDataList(snapshotData['users']);
    _userA = snapshotData['user_a'] as DocumentReference?;
    _userB = snapshotData['user_b'] as DocumentReference?;
    _lastMessage = snapshotData['last_message'] as String?;
    _lastMessageTime = snapshotData['last_message_time'] as DateTime?;
    _lastMessageSentBy =
        snapshotData['last_message_sent_by'] as DocumentReference?;
    _lastMessageSeenBy = getDataList(snapshotData['last_message_seen_by']);
    _chatType = snapshotData['chat_type'] as String?;
    _workspaceId = snapshotData['workspace_id'] as String?;
    _channelName = snapshotData['channel_name'] as String?;
    _workspaceRef = snapshotData['workspace_ref'] as DocumentReference?;
    _chatRef = snapshotData['chat_ref'] as DocumentReference?;
    _pinnedBy = getDataList(snapshotData['pinnedBy']);
    _archivedBy = getDataList(snapshotData['archivedBy']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatsRecord.fromSnapshot(s));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatsRecord.fromSnapshot(s));

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) => ChatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatsRecordData({
  DocumentReference? userA,
  DocumentReference? userB,
  String? lastMessage,
  DateTime? lastMessageTime,
  DocumentReference? lastMessageSentBy,
  String? chatType,
  String? workspaceId,
  String? channelName,
  DocumentReference? workspaceRef,
  DocumentReference? chatRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_a': userA,
      'user_b': userB,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'last_message_sent_by': lastMessageSentBy,
      'chat_type': chatType,
      'workspace_id': workspaceId,
      'channel_name': channelName,
      'workspace_ref': workspaceRef,
      'chat_ref': chatRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatsRecordDocumentEquality implements Equality<ChatsRecord> {
  const ChatsRecordDocumentEquality();

  @override
  bool equals(ChatsRecord? e1, ChatsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.users, e2?.users) &&
        e1?.userA == e2?.userA &&
        e1?.userB == e2?.userB &&
        e1?.lastMessage == e2?.lastMessage &&
        e1?.lastMessageTime == e2?.lastMessageTime &&
        e1?.lastMessageSentBy == e2?.lastMessageSentBy &&
        listEquality.equals(e1?.lastMessageSeenBy, e2?.lastMessageSeenBy) &&
        e1?.chatType == e2?.chatType &&
        e1?.workspaceId == e2?.workspaceId &&
        e1?.channelName == e2?.channelName &&
        e1?.workspaceRef == e2?.workspaceRef &&
        e1?.chatRef == e2?.chatRef &&
        listEquality.equals(e1?.pinnedBy, e2?.pinnedBy) &&
        listEquality.equals(e1?.archivedBy, e2?.archivedBy);
  }

  @override
  int hash(ChatsRecord? e) => const ListEquality().hash([
        e?.users,
        e?.userA,
        e?.userB,
        e?.lastMessage,
        e?.lastMessageTime,
        e?.lastMessageSentBy,
        e?.lastMessageSeenBy,
        e?.chatType,
        e?.workspaceId,
        e?.channelName,
        e?.workspaceRef,
        e?.chatRef,
        e?.pinnedBy,
        e?.archivedBy
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatsRecord;
}
