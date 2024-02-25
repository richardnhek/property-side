import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class MailRecord extends FirestoreRecord {
  MailRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "message" field.
  MailMessageStruct? _message;
  MailMessageStruct get message => _message ?? MailMessageStruct();
  bool hasMessage() => _message != null;

  // "to" field.
  String? _to;
  String get to => _to ?? '';
  bool hasTo() => _to != null;

  void _initializeFields() {
    _message = MailMessageStruct.maybeFromMap(snapshotData['message']);
    _to = snapshotData['to'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('mail');

  static Stream<MailRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MailRecord.fromSnapshot(s));

  static Future<MailRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MailRecord.fromSnapshot(s));

  static MailRecord fromSnapshot(DocumentSnapshot snapshot) => MailRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MailRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MailRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MailRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MailRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMailRecordData({
  MailMessageStruct? message,
  String? to,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'message': MailMessageStruct().toMap(),
      'to': to,
    }.withoutNulls,
  );

  // Handle nested data for "message" field.
  addMailMessageStructData(firestoreData, message, 'message');

  return firestoreData;
}

class MailRecordDocumentEquality implements Equality<MailRecord> {
  const MailRecordDocumentEquality();

  @override
  bool equals(MailRecord? e1, MailRecord? e2) {
    return e1?.message == e2?.message && e1?.to == e2?.to;
  }

  @override
  int hash(MailRecord? e) => const ListEquality().hash([e?.message, e?.to]);

  @override
  bool isValidKey(Object? o) => o is MailRecord;
}
