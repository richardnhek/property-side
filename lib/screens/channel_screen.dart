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
    Future<void> getOrCreateCall(
        {List<String> memberIds = const [], String? specificCallType}) async {
      var callId = generateAlphanumericString(12);

      // Assume showLoadingIndicator(context) is to display a loading animation.
      // unawaited(showLoadingIndicator(context)); // Uncomment or use according to your needs.

      _call = _streamVideo.makeCall(
          type: specificCallType ?? kCallType,
          id: callId); // Make sure 'kCallType' is defined or replace it with default call type.

      try {
        await _call!.getOrCreate(
          memberIds: memberIds,
          ringing: memberIds.isNotEmpty,
        );
      } catch (e, stk) {
        debugPrint('Error joining or creating call: $e');
        debugPrint(stk.toString());
        // If there's an error, ideally you should handle it, for example, by showing an error message.
        return; // Return from the function if there was an error.
      }

      if (mounted) {
        // hideLoadingIndicator(context); // Uncomment or use according to your needs.

        CallConnectOptions connectOptions = CallConnectOptions(
            camera: TrackOption.disabled(),
            microphone: TrackOption.enabled(),
            screenShare: TrackOption.disabled());

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
                        memberIds: memberList, specificCallType: 'audio_room');
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
          Expanded(child: streamFlutter.StreamMessageListView()),
          streamFlutter.StreamMessageInput(),
        ],
      ),
    );
  }
}
