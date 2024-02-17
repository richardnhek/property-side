import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as streamFlutter;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({required this.selectedMembers, super.key});

  final List<String?> selectedMembers;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late StreamVideo video;
  late Call selectedCall;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: streamFlutter.StreamChannelHeader(
        title: const Text(
          "All Chats",
          style: TextStyle(color: Colors.black, fontSize: 21),
        ),
        onImageTap: () async {},
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {},
                  child: const Icon(
                    Icons.call,
                    size: 24,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                GestureDetector(
                  onTap: () async {},
                  child: const Icon(
                    Icons.video_camera_front_rounded,
                    size: 32,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: streamFlutter.StreamMessageListView(
            messageBuilder:
                (context, msgDetails, messageList, streamMsgWidget) {
              final isMyMessage = msgDetails.message.user?.id ==
                  streamFlutter.StreamChat.of(context).currentUser?.id;

              // Define colors and styles
              final messageBackgroundColor =
                  isMyMessage ? Color(0xFFDCF8C6) : Colors.white;
              final messageTextColor = Colors.black;
              final borderRadius = BorderRadius.circular(16);
              final tailCurveHeight = 10.0; // Height of the curve for the tail

              // The main widget for a message
              return Align(
                alignment:
                    isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name of the sender for received messages
                      if (!isMyMessage)
                        Text(
                          msgDetails.message.user?.name ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      // Message bubble with tail
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color:
                              messageBackgroundColor, // Make container color transparent, paint will draw the background
                          borderRadius: borderRadius,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                offset: Offset(1, 2),
                                blurRadius: 2)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Message text
                            Text(
                              msgDetails.message.text ?? '',
                              style: TextStyle(
                                color: messageTextColor,
                              ),
                            ),
                            // Message time and status
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  msgDetails.message.createdAt
                                      .toLocal()
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (isMyMessage)
                                  Icon(
                                    Icons
                                        .check, // This is just an example icon, you will have to implement message status logic
                                    size: 15,
                                    color: msgDetails.message.state.isSent
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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

