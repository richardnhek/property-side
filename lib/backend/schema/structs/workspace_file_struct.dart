// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../flutter_flow/nav/serialization_util.dart';
import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';

class WorkspaceFileStruct extends FFFirebaseStruct {
  WorkspaceFileStruct({
    String? fileUrl,
    String? fileType,
    DateTime? sentDateTime,
    DocumentReference? sharedBy,
    String? fileThumnail,
    String? fileName,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _fileUrl = fileUrl,
        _fileType = fileType,
        _sentDateTime = sentDateTime,
        _sharedBy = sharedBy,
        _fileThumnail = fileThumnail,
        _fileName = fileName,
        super(firestoreUtilData);

  // "fileUrl" field.
  String? _fileUrl;
  String get fileUrl => _fileUrl ?? '';
  set fileUrl(String? val) => _fileUrl = val;
  bool hasFileUrl() => _fileUrl != null;

  // "fileType" field.
  String? _fileType;
  String get fileType => _fileType ?? '';
  set fileType(String? val) => _fileType = val;
  bool hasFileType() => _fileType != null;

  // "sentDateTime" field.
  DateTime? _sentDateTime;
  DateTime? get sentDateTime => _sentDateTime;
  set sentDateTime(DateTime? val) => _sentDateTime = val;
  bool hasSentDateTime() => _sentDateTime != null;

  // "sharedBy" field.
  DocumentReference? _sharedBy;
  DocumentReference? get sharedBy => _sharedBy;
  set sharedBy(DocumentReference? val) => _sharedBy = val;
  bool hasSharedBy() => _sharedBy != null;

  // "fileThumnail" field.
  String? _fileThumnail;
  String get fileThumnail => _fileThumnail ?? '';
  set fileThumnail(String? val) => _fileThumnail = val;
  bool hasFileThumnail() => _fileThumnail != null;

  // "fileName" field.
  String? _fileName;
  String get fileName => _fileName ?? '';
  set fileName(String? val) => _fileName = val;
  bool hasFileName() => _fileName != null;

  static WorkspaceFileStruct fromMap(Map<String, dynamic> data) =>
      WorkspaceFileStruct(
        fileUrl: data['fileUrl'] as String?,
        fileType: data['fileType'] as String?,
        sentDateTime: data['sentDateTime'] as DateTime?,
        sharedBy: data['sharedBy'] as DocumentReference?,
        fileThumnail: data['fileThumnail'] as String?,
        fileName: data['fileName'] as String?,
      );

  static WorkspaceFileStruct? maybeFromMap(dynamic data) => data is Map
      ? WorkspaceFileStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fileUrl': _fileUrl,
        'fileType': _fileType,
        'sentDateTime': _sentDateTime,
        'sharedBy': _sharedBy,
        'fileThumnail': _fileThumnail,
        'fileName': _fileName,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fileUrl': serializeParam(
          _fileUrl,
          ParamType.String,
        ),
        'fileType': serializeParam(
          _fileType,
          ParamType.String,
        ),
        'sentDateTime': serializeParam(
          _sentDateTime,
          ParamType.DateTime,
        ),
        'sharedBy': serializeParam(
          _sharedBy,
          ParamType.DocumentReference,
        ),
        'fileThumnail': serializeParam(
          _fileThumnail,
          ParamType.String,
        ),
        'fileName': serializeParam(
          _fileName,
          ParamType.String,
        ),
      }.withoutNulls;

  static WorkspaceFileStruct fromSerializableMap(Map<String, dynamic> data) =>
      WorkspaceFileStruct(
        fileUrl: deserializeParam(
          data['fileUrl'],
          ParamType.String,
          false,
        ),
        fileType: deserializeParam(
          data['fileType'],
          ParamType.String,
          false,
        ),
        sentDateTime: deserializeParam(
          data['sentDateTime'],
          ParamType.DateTime,
          false,
        ),
        sharedBy: deserializeParam(
          data['sharedBy'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
        fileThumnail: deserializeParam(
          data['fileThumnail'],
          ParamType.String,
          false,
        ),
        fileName: deserializeParam(
          data['fileName'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'WorkspaceFileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WorkspaceFileStruct &&
        fileUrl == other.fileUrl &&
        fileType == other.fileType &&
        sentDateTime == other.sentDateTime &&
        sharedBy == other.sharedBy &&
        fileThumnail == other.fileThumnail &&
        fileName == other.fileName;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [fileUrl, fileType, sentDateTime, sharedBy, fileThumnail, fileName]);
}

WorkspaceFileStruct createWorkspaceFileStruct({
  String? fileUrl,
  String? fileType,
  DateTime? sentDateTime,
  DocumentReference? sharedBy,
  String? fileThumnail,
  String? fileName,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    WorkspaceFileStruct(
      fileUrl: fileUrl,
      fileType: fileType,
      sentDateTime: sentDateTime,
      sharedBy: sharedBy,
      fileThumnail: fileThumnail,
      fileName: fileName,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

WorkspaceFileStruct? updateWorkspaceFileStruct(
  WorkspaceFileStruct? workspaceFile, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    workspaceFile
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addWorkspaceFileStructData(
  Map<String, dynamic> firestoreData,
  WorkspaceFileStruct? workspaceFile,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (workspaceFile == null) {
    return;
  }
  if (workspaceFile.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && workspaceFile.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final workspaceFileData =
      getWorkspaceFileFirestoreData(workspaceFile, forFieldValue);
  final nestedData =
      workspaceFileData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = workspaceFile.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getWorkspaceFileFirestoreData(
  WorkspaceFileStruct? workspaceFile, [
  bool forFieldValue = false,
]) {
  if (workspaceFile == null) {
    return {};
  }
  final firestoreData = mapToFirestore(workspaceFile.toMap());

  // Add any Firestore field values
  workspaceFile.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getWorkspaceFileListFirestoreData(
  List<WorkspaceFileStruct>? workspaceFiles,
) =>
    workspaceFiles
        ?.map((e) => getWorkspaceFileFirestoreData(e, true))
        .toList() ??
    [];
