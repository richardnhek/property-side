// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../flutter_flow/flutter_flow_util.dart';
import '../../../flutter_flow/nav/serialization_util.dart';
import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';

class WorkspaceOverviewStruct extends FFFirebaseStruct {
  WorkspaceOverviewStruct({
    String? currentStatus,
    double? loanAmount,
    String? communicationNotes,
    List<DocumentReference>? clients,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _currentStatus = currentStatus,
        _loanAmount = loanAmount,
        _communicationNotes = communicationNotes,
        _clients = clients,
        super(firestoreUtilData);

  // "current_status" field.
  String? _currentStatus;
  String get currentStatus => _currentStatus ?? '';
  set currentStatus(String? val) => _currentStatus = val;
  bool hasCurrentStatus() => _currentStatus != null;

  // "loan_amount" field.
  double? _loanAmount;
  double get loanAmount => _loanAmount ?? 0.0;
  set loanAmount(double? val) => _loanAmount = val;
  void incrementLoanAmount(double amount) => _loanAmount = loanAmount + amount;
  bool hasLoanAmount() => _loanAmount != null;

  // "communication_notes" field.
  String? _communicationNotes;
  String get communicationNotes => _communicationNotes ?? '';
  set communicationNotes(String? val) => _communicationNotes = val;
  bool hasCommunicationNotes() => _communicationNotes != null;

  // "clients" field.
  List<DocumentReference>? _clients;
  List<DocumentReference> get clients => _clients ?? const [];
  set clients(List<DocumentReference>? val) => _clients = val;
  void updateClients(Function(List<DocumentReference>) updateFn) =>
      updateFn(_clients ??= []);
  bool hasClients() => _clients != null;

  static WorkspaceOverviewStruct fromMap(Map<String, dynamic> data) =>
      WorkspaceOverviewStruct(
        currentStatus: data['current_status'] as String?,
        loanAmount: castToType<double>(data['loan_amount']),
        communicationNotes: data['communication_notes'] as String?,
        clients: getDataList(data['clients']),
      );

  static WorkspaceOverviewStruct? maybeFromMap(dynamic data) => data is Map
      ? WorkspaceOverviewStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'current_status': _currentStatus,
        'loan_amount': _loanAmount,
        'communication_notes': _communicationNotes,
        'clients': _clients,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'current_status': serializeParam(
          _currentStatus,
          ParamType.String,
        ),
        'loan_amount': serializeParam(
          _loanAmount,
          ParamType.double,
        ),
        'communication_notes': serializeParam(
          _communicationNotes,
          ParamType.String,
        ),
        'clients': serializeParam(
          _clients,
          ParamType.DocumentReference,
          true,
        ),
      }.withoutNulls;

  static WorkspaceOverviewStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      WorkspaceOverviewStruct(
        currentStatus: deserializeParam(
          data['current_status'],
          ParamType.String,
          false,
        ),
        loanAmount: deserializeParam(
          data['loan_amount'],
          ParamType.double,
          false,
        ),
        communicationNotes: deserializeParam(
          data['communication_notes'],
          ParamType.String,
          false,
        ),
        clients: deserializeParam<DocumentReference>(
          data['clients'],
          ParamType.DocumentReference,
          true,
          collectionNamePath: ['users'],
        ),
      );

  @override
  String toString() => 'WorkspaceOverviewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is WorkspaceOverviewStruct &&
        currentStatus == other.currentStatus &&
        loanAmount == other.loanAmount &&
        communicationNotes == other.communicationNotes &&
        listEquality.equals(clients, other.clients);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([currentStatus, loanAmount, communicationNotes, clients]);
}

WorkspaceOverviewStruct createWorkspaceOverviewStruct({
  String? currentStatus,
  double? loanAmount,
  String? communicationNotes,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    WorkspaceOverviewStruct(
      currentStatus: currentStatus,
      loanAmount: loanAmount,
      communicationNotes: communicationNotes,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

WorkspaceOverviewStruct? updateWorkspaceOverviewStruct(
  WorkspaceOverviewStruct? workspaceOverview, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    workspaceOverview
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addWorkspaceOverviewStructData(
  Map<String, dynamic> firestoreData,
  WorkspaceOverviewStruct? workspaceOverview,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (workspaceOverview == null) {
    return;
  }
  if (workspaceOverview.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && workspaceOverview.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final workspaceOverviewData =
      getWorkspaceOverviewFirestoreData(workspaceOverview, forFieldValue);
  final nestedData =
      workspaceOverviewData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = workspaceOverview.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getWorkspaceOverviewFirestoreData(
  WorkspaceOverviewStruct? workspaceOverview, [
  bool forFieldValue = false,
]) {
  if (workspaceOverview == null) {
    return {};
  }
  final firestoreData = mapToFirestore(workspaceOverview.toMap());

  // Add any Firestore field values
  workspaceOverview.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getWorkspaceOverviewListFirestoreData(
  List<WorkspaceOverviewStruct>? workspaceOverviews,
) =>
    workspaceOverviews
        ?.map((e) => getWorkspaceOverviewFirestoreData(e, true))
        .toList() ??
    [];
