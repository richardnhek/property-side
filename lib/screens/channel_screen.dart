import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/flutter_flow/flutter_flow_theme.dart';
// ignore: library_prefixes
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as streamFlutter;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../app_state.dart';
import '../di/injector.dart';
import '../router/routes.dart';
import '../utils/consts.dart';
import '../utils/loading_dialog.dart';
import 'call_screen.dart';
import 'thread_page.dart';

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
  streamFlutter.Message? _replyMessage;

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
    Future<void> sendJoinCallMessage(
        streamFlutter.Channel channel, String callId) async {
      final message = streamFlutter.Message(
        text: 'Join Call',
        extraData: {
          'callId': callId,
        },
      );

      try {
        await channel.sendMessage(message);
        debugPrint('Join call message sent successfully');
      } catch (e) {
        debugPrint('Error sending join call message: $e');
      }
    }

    Future<void> getOrCreateCall(
        {List<String> memberIds = const [],
        String? specificCallType,
        required streamFlutter.Channel channel}) async {
      var callId = generateAlphanumericString(12);
      _call = _streamVideo.makeCall(
          type: specificCallType ?? kCallType, id: callId);

      try {
        await _call!.getOrCreate(
          memberIds: memberIds,
          ringing: memberIds.isNotEmpty,
        );
      } catch (e, stk) {
        debugPrint('Error joining or creating call: $e');
        debugPrint(stk.toString());
        return;
      }

      if (mounted) {
        CallConnectOptions connectOptions = CallConnectOptions(
            camera: TrackOption.disabled(),
            microphone: TrackOption.enabled(),
            screenShare: TrackOption.disabled());
        try {
          await sendJoinCallMessage(channel!, callId);
        } catch (e) {
          debugPrint('Error in messaging: $e');
        }

        if (memberIds.length > 2) {
          LobbyRoute($extra: _call!).push(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CallScreen(call: _call!, connectOptions: connectOptions),
            ),
          );
        }
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
                InkWell(
                  onTap: () {
                    getOrCreateCall(
                        memberIds: memberList,
                        specificCallType: 'audio_room',
                        channel:
                            streamFlutter.StreamChannel.of(context).channel);
                  },
                  child: Icon(
                    Icons.call,
                    size: 24,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                InkWell(
                  onTap: () {
                    getOrCreateCall(
                        memberIds: memberList,
                        channel:
                            streamFlutter.StreamChannel.of(context).channel);
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
      body: Column(
        children: <Widget>[
          Expanded(child: streamFlutter.StreamMessageListView(
            messageBuilder: (ctx, details, messages, defaultMessage) {
              return defaultMessage.copyWith(
                  showFlagButton: true,
                  showEditMessage: details.isMyMessage,
                  showCopyMessage: true,
                  showDeleteMessage: details.isMyMessage,
                  showThreadReplyMessage: true,
                  onThreadTap: (message) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ThreadPage(
                          parent: message,
                          channel:
                              streamFlutter.StreamChannel.of(context).channel,
                        ),
                      ),
                    );
                  },
                  bottomRowBuilderWithDefaultWidget: (p0, p1, bottomRow) {
                    final callId = p1.extraData["callId"];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (callId != null)
                          Padding(
                            padding: details.isMyMessage
                                ? EdgeInsets.only(right: 50)
                                : EdgeInsets.only(right: 20),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    final thisCall = _streamVideo.makeCall(
                                        id: callId.toString(), type: kCallType);
                                    await thisCall.getOrCreate();
                                    LobbyRoute($extra: thisCall).push(context);
                                  } catch (e, stk) {
                                    debugPrint(
                                        'Error joining or creating call: $e');
                                    debugPrint(stk.toString());
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  child: Icon(
                                    Icons.video_camera_front_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        bottomRow.copyWith(
                          message: p1,
                          showThreadReplyIndicator: true,
                          onThreadTap: (message) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => ThreadPage(
                                  parent: message,
                                  channel:
                                      streamFlutter.StreamChannel.of(context)
                                          .channel,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  });
            },
          )),
          if (_replyMessage != null)
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to: ${_replyMessage!.text}',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _replyMessage = null;
                      });
                    },
                  )
                ],
              ),
            ),
          streamFlutter.StreamMessageInput(
            preMessageSending: (message) async {
              if (_replyMessage != null) {
                message = message.copyWith(parentId: _replyMessage!.id);
                _replyMessage = null;
              }
              return message;
            },
          ),
        ],
      ),
    );
  }
}
