import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class ChatMessagesRecord extends FirestoreRecord {
  ChatMessagesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "chat" field.
  DocumentReference? _chat;
  DocumentReference? get chat => _chat;
  bool hasChat() => _chat != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "chat_message_ref" field.
  DocumentReference? _chatMessageRef;
  DocumentReference? get chatMessageRef => _chatMessageRef;
  bool hasChatMessageRef() => _chatMessageRef != null;

  // "is_forward" field.
  bool? _isForward;
  bool get isForward => _isForward ?? false;
  bool hasIsForward() => _isForward != null;

  // "fwd_message_ref" field.
  DocumentReference? _fwdMessageRef;
  DocumentReference? get fwdMessageRef => _fwdMessageRef;
  bool hasFwdMessageRef() => _fwdMessageRef != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _chat = snapshotData['chat'] as DocumentReference?;
    _text = snapshotData['text'] as String?;
    _image = snapshotData['image'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _chatMessageRef = snapshotData['chat_message_ref'] as DocumentReference?;
    _isForward = snapshotData['is_forward'] as bool?;
    _fwdMessageRef = snapshotData['fwd_message_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chat_messages');

  static Stream<ChatMessagesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatMessagesRecord.fromSnapshot(s));

  static Future<ChatMessagesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatMessagesRecord.fromSnapshot(s));

  static ChatMessagesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChatMessagesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatMessagesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatMessagesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatMessagesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatMessagesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatMessagesRecordData({
  DocumentReference? user,
  DocumentReference? chat,
  String? text,
  String? image,
  DateTime? timestamp,
  DocumentReference? chatMessageRef,
  bool? isForward,
  DocumentReference? fwdMessageRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'chat': chat,
      'text': text,
      'image': image,
      'timestamp': timestamp,
      'chat_message_ref': chatMessageRef,
      'is_forward': isForward,
      'fwd_message_ref': fwdMessageRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatMessagesRecordDocumentEquality
    implements Equality<ChatMessagesRecord> {
  const ChatMessagesRecordDocumentEquality();

  @override
  bool equals(ChatMessagesRecord? e1, ChatMessagesRecord? e2) {
    return e1?.user == e2?.user &&
        e1?.chat == e2?.chat &&
        e1?.text == e2?.text &&
        e1?.image == e2?.image &&
        e1?.timestamp == e2?.timestamp &&
        e1?.chatMessageRef == e2?.chatMessageRef &&
        e1?.isForward == e2?.isForward &&
        e1?.fwdMessageRef == e2?.fwdMessageRef;
  }

  @override
  int hash(ChatMessagesRecord? e) => const ListEquality().hash([
        e?.user,
        e?.chat,
        e?.text,
        e?.image,
        e?.timestamp,
        e?.chatMessageRef,
        e?.isForward,
        e?.fwdMessageRef
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatMessagesRecord;
}
