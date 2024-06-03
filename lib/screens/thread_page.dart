import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ThreadPage extends StatelessWidget {
  const ThreadPage({super.key, this.parent, this.channel});

  final Message? parent;
  final Channel? channel;

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel!,
      child: Column(
        children: <Widget>[
          StreamThreadHeader(
            parent: parent!,
          ),
          Expanded(
            child: StreamMessageListView(
              parentMessage: parent,
            ),
          ),
          StreamMessageInput(
            messageInputController: StreamMessageInputController(
              message: Message(parentId: parent!.id),
            ),
          ),
        ],
      ),
    );
  }
}
