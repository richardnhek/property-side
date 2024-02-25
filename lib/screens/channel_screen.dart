import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/flutter_flow/flutter_flow_theme.dart';
// ignore: library_prefixes
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as streamFlutter;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../di/injector.dart';
import '../router/routes.dart';
import '../utils/consts.dart';
import '../utils/loading_dialog.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({required this.selectedMembers, super.key});

  final List<String?> selectedMembers;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late Call selectedCall;
  late final _streamVideo = locator.get<StreamVideo>();
  Call? _call;
  late List<String> memberList;

  @override
  void initState() {
    super.initState();
    memberList = widget.selectedMembers
        .where((member) => member != null)
        .map((member) => member!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> getOrCreateCall({List<String> memberIds = const []}) async {
      var callId = generateAlphanumericString(12);

      unawaited(showLoadingIndicator(context));
      _call = _streamVideo.makeCall(type: kCallType, id: callId);

      try {
        await _call!.getOrCreate(
          memberIds: memberIds,
          ringing: memberIds.isNotEmpty,
        );
      } catch (e, stk) {
        debugPrint('Error joining or creating call: $e');
        debugPrint(stk.toString());
      }

      if (mounted) {
        hideLoadingIndicator(context);
        LobbyRoute($extra: _call!).push(context);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: streamFlutter.StreamChannelHeader(
        onImageTap: () async {},
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {},
                  child: Icon(
                    Icons.call,
                    size: 24,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    getOrCreateCall(memberIds: memberList);
                  },
                  child: Icon(
                    Icons.video_camera_front_rounded,
                    size: 32,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: const Column(
        children: <Widget>[
          Expanded(
              child: streamFlutter.StreamMessageListView(
                  // messageBuilder:
                  //     (context, msgDetails, messageList, streamMsgWidget) {
                  //   final isMyMessage = msgDetails.message.user?.id ==
                  //       streamFlutter.StreamChat.of(context).currentUser?.id;

                  //   // Define colors and styles
                  //   final messageBackgroundColor =
                  //       isMyMessage ? Color(0xFFDCF8C6) : Colors.white;
                  //   final messageTextColor = Colors.black;
                  //   final borderRadius = BorderRadius.circular(16);
                  //   final tailCurveHeight = 10.0; // Height of the curve for the tail

                  //   // The main widget for a message
                  //   return Align(
                  //     alignment:
                  //         isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                  //     child: ConstrainedBox(
                  //       constraints: BoxConstraints(
                  //           maxWidth: MediaQuery.of(context).size.width * 0.8),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           // Name of the sender for received messages
                  //           if (!isMyMessage)
                  //             Text(
                  //               msgDetails.message.user?.name ?? 'Unknown',
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.grey[700],
                  //               ),
                  //             ),
                  //           // Message bubble with tail
                  //           Container(
                  //             margin: const EdgeInsets.symmetric(vertical: 2),
                  //             padding: const EdgeInsets.symmetric(
                  //                 vertical: 8, horizontal: 12),
                  //             decoration: BoxDecoration(
                  //               color:
                  //                   messageBackgroundColor, // Make container color transparent, paint will draw the background
                  //               borderRadius: borderRadius,
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                     color: Colors.black.withOpacity(0.16),
                  //                     offset: Offset(1, 2),
                  //                     blurRadius: 2)
                  //               ],
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 // Message text
                  //                 Text(
                  //                   msgDetails.message.text ?? '',
                  //                   style: TextStyle(
                  //                     color: messageTextColor,
                  //                   ),
                  //                 ),
                  //                 // Message time and status
                  //                 Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     Text(
                  //                       msgDetails.message.createdAt
                  //                           .toLocal()
                  //                           .toString(),
                  //                       style: const TextStyle(
                  //                         fontSize: 12,
                  //                         color: Colors.grey,
                  //                       ),
                  //                     ),
                  //                     if (isMyMessage)
                  //                       Icon(
                  //                         Icons
                  //                             .check, // This is just an example icon, you will have to implement message status logic
                  //                         size: 15,
                  //                         color: msgDetails.message.state.isSent
                  //                             ? Colors.blue
                  //                             : Colors.grey,
                  //                       ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   );
                  // },
                  )),
          streamFlutter.StreamMessageInput(),
        ],
      ),
    );
  }
}
// messageBuilder: (context, msgDetails, messages, streamMsgWidget) {
//               final message = msgDetails.message;
//               final userId = streamFlutter.StreamChat.of(context).currentUser!.id;
//               final isMyMessage = message.user?.id == userId;
//               final index = msgDetails.index;
//               final nextMessage = index - 1 >= 0 ? messages[index - 1] : null;
//               final isNextUserSame = nextMessage != null &&
//                   message.user!.id == nextMessage.user!.id;

//               return
//             },

