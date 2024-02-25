import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String? getFileName(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) {
    return null;
  }

  // Decode the URL to handle encoded characters
  var decodedUrl = Uri.decodeFull(imagePath);

  // Split the decoded string by '/' and get the last segment
  var segments = decodedUrl.split('/');
  return segments.isNotEmpty ? segments.last.split('?').first : null;
}

List<DocumentReference>? getListOfUnrelatedUsers(
  List<DocumentReference> workspaceMembers,
  List<ChatsRecord> chatDocsList,
) {
  // Initialize an empty list that will hold the references of users who have not started a chat
  List<DocumentReference> unrelatedUsers = [];

  // Create a set of all user references that the current user has chatted with
  Set<DocumentReference> usersWithChats = {};

  for (var chatDoc in chatDocsList) {
    // Assuming the 'users' field is a list of DocumentReferences
    List<dynamic> chatUsers = chatDoc.users;
    print("chatUsers: $chatUsers");
    usersWithChats.addAll(chatUsers.cast<DocumentReference>());
    print("usersWithChats: $usersWithChats");
  }

  // Iterate over the workspace members
  for (var member in workspaceMembers) {
    // Check if the member is not in the set of usersWithChats
    if (!usersWithChats.contains(member)) {
      // If the member is not in the usersWithChats, then the current user has not chatted with them
      // Add them to the list of unrelated users
      unrelatedUsers.add(member);
    }
  }
  print("unrelatedUsers: $unrelatedUsers");
  // Return the list of users who are in the same workspace but have not started a chat with the current user
  return unrelatedUsers;
}

String? createWelcomeMessage(List<String> userNames) {
  if (userNames.isEmpty) {
    return "No users have been added to the channel.";
  } else if (userNames.length == 1) {
    return "${userNames.first} has been added to the channel. Let's give a warm welcome to ${userNames.first}!";
  } else if (userNames.length == 2) {
    return "${userNames.join(' and ')} have been added to the channel. Let's give them a warm welcome!";
  } else {
    String allButLast = userNames.sublist(0, userNames.length - 1).join(", ");
    String last = userNames.last;
    return "$allButLast, and $last have been added to the channel. Let's give them a warm welcome!";
  }
}

String? getFileExt(String? filePath) {
  if (filePath == null || !filePath.contains('.')) {
    return null;
  }

  // Split the URL by '?', take the first part to ignore URL parameters
  var mainPath = filePath.split('?').first;

  // Extract the extension
  var extension = mainPath.split('.').last;

  return extension;
}

String? fullFwdMessage(
  String fwdMessage,
  String newMessage,
) {
  return fwdMessage + '\n' + newMessage;
}

String getMessageTime(DateTime? messageTime) {
  if (messageTime == null) {
    return 'No Date';
  }

  DateTime now = DateTime.now();
  DateTime justNow = DateTime(now.year, now.month, now.day);

  if (messageTime.isAfter(justNow)) {
    return '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';
  } else {
    return '${messageTime.day.toString().padLeft(2, '0')}/${messageTime.month.toString().padLeft(2, '0')}/${messageTime.year.toString().substring(2)}';
  }
}

String getFormattedPhoneNo(String phoneNo) {
  return phoneNo.replaceAll(RegExp(r'[^\d+]'), '');
}

String? getUserInitial(String? userFullName) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  if (userFullName == null) {
    return 'Z';
  }
  return userFullName[0];

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
