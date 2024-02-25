// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dogfooding/backend/backend.dart';

import '../../../flutter_flow/nav/serialization_util.dart';
import '/backend/schema/util/firestore_util.dart';

class MailMessageStruct extends FFFirebaseStruct {
  MailMessageStruct({
    String? subject,
    String? text,
    String? html,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _subject = subject,
        _text = text,
        _html = html,
        super(firestoreUtilData);

  // "subject" field.
  String? _subject;
  String get subject => _subject ?? '';
  set subject(String? val) => _subject = val;
  bool hasSubject() => _subject != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;
  bool hasText() => _text != null;

  // "html" field.
  String? _html;
  String get html => _html ?? '';
  set html(String? val) => _html = val;
  bool hasHtml() => _html != null;

  static MailMessageStruct fromMap(Map<String, dynamic> data) =>
      MailMessageStruct(
        subject: data['subject'] as String?,
        text: data['text'] as String?,
        html: data['html'] as String?,
      );

  static MailMessageStruct? maybeFromMap(dynamic data) => data is Map
      ? MailMessageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'subject': _subject,
        'text': _text,
        'html': _html,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'subject': serializeParam(
          _subject,
          ParamType.String,
        ),
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'html': serializeParam(
          _html,
          ParamType.String,
        ),
      }.withoutNulls;

  static MailMessageStruct fromSerializableMap(Map<String, dynamic> data) =>
      MailMessageStruct(
        subject: deserializeParam(
          data['subject'],
          ParamType.String,
          false,
        ),
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        html: deserializeParam(
          data['html'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MailMessageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MailMessageStruct &&
        subject == other.subject &&
        text == other.text &&
        html == other.html;
  }

  @override
  int get hashCode => const ListEquality().hash([subject, text, html]);
}

MailMessageStruct createMailMessageStruct({
  String? subject,
  String? text,
  String? html,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    MailMessageStruct(
      subject: subject,
      text: text,
      html: html,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

MailMessageStruct? updateMailMessageStruct(
  MailMessageStruct? mailMessage, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    mailMessage
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addMailMessageStructData(
  Map<String, dynamic> firestoreData,
  MailMessageStruct? mailMessage,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (mailMessage == null) {
    return;
  }
  if (mailMessage.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && mailMessage.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final mailMessageData =
      getMailMessageFirestoreData(mailMessage, forFieldValue);
  final nestedData =
      mailMessageData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = mailMessage.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getMailMessageFirestoreData(
  MailMessageStruct? mailMessage, [
  bool forFieldValue = false,
]) {
  if (mailMessage == null) {
    return {};
  }
  final firestoreData = mapToFirestore(mailMessage.toMap());

  // Add any Firestore field values
  mailMessage.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getMailMessageListFirestoreData(
  List<MailMessageStruct>? mailMessages,
) =>
    mailMessages?.map((e) => getMailMessageFirestoreData(e, true)).toList() ??
    [];
