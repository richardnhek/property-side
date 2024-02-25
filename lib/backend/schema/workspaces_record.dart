import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class WorkspacesRecord extends FirestoreRecord {
  WorkspacesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "members" field.
  List<DocumentReference>? _members;
  List<DocumentReference> get members => _members ?? const [];
  bool hasMembers() => _members != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "overview" field.
  WorkspaceOverviewStruct? _overview;
  WorkspaceOverviewStruct get overview =>
      _overview ?? WorkspaceOverviewStruct();
  bool hasOverview() => _overview != null;

  // "files" field.
  List<WorkspaceFileStruct>? _files;
  List<WorkspaceFileStruct> get files => _files ?? const [];
  bool hasFiles() => _files != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "workspace_ref" field.
  DocumentReference? _workspaceRef;
  DocumentReference? get workspaceRef => _workspaceRef;
  bool hasWorkspaceRef() => _workspaceRef != null;

  // "chat_refs" field.
  List<DocumentReference>? _chatRefs;
  List<DocumentReference> get chatRefs => _chatRefs ?? const [];
  bool hasChatRefs() => _chatRefs != null;

  void _initializeFields() {
    _members = getDataList(snapshotData['members']);
    _name = snapshotData['name'] as String?;
    _overview = WorkspaceOverviewStruct.maybeFromMap(snapshotData['overview']);
    _files = getStructList(
      snapshotData['files'],
      WorkspaceFileStruct.fromMap,
    );
    _id = snapshotData['id'] as String?;
    _workspaceRef = snapshotData['workspace_ref'] as DocumentReference?;
    _chatRefs = getDataList(snapshotData['chat_refs']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('workspaces');

  static Stream<WorkspacesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => WorkspacesRecord.fromSnapshot(s));

  static Future<WorkspacesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => WorkspacesRecord.fromSnapshot(s));

  static WorkspacesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      WorkspacesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static WorkspacesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      WorkspacesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'WorkspacesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is WorkspacesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createWorkspacesRecordData({
  String? name,
  WorkspaceOverviewStruct? overview,
  String? id,
  DocumentReference? workspaceRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'overview': WorkspaceOverviewStruct().toMap(),
      'id': id,
      'workspace_ref': workspaceRef,
    }.withoutNulls,
  );

  // Handle nested data for "overview" field.
  addWorkspaceOverviewStructData(firestoreData, overview, 'overview');

  return firestoreData;
}

class WorkspacesRecordDocumentEquality implements Equality<WorkspacesRecord> {
  const WorkspacesRecordDocumentEquality();

  @override
  bool equals(WorkspacesRecord? e1, WorkspacesRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.members, e2?.members) &&
        e1?.name == e2?.name &&
        e1?.overview == e2?.overview &&
        listEquality.equals(e1?.files, e2?.files) &&
        e1?.id == e2?.id &&
        e1?.workspaceRef == e2?.workspaceRef &&
        listEquality.equals(e1?.chatRefs, e2?.chatRefs);
  }

  @override
  int hash(WorkspacesRecord? e) => const ListEquality().hash([
        e?.members,
        e?.name,
        e?.overview,
        e?.files,
        e?.id,
        e?.workspaceRef,
        e?.chatRefs
      ]);

  @override
  bool isValidKey(Object? o) => o is WorkspacesRecord;
}
