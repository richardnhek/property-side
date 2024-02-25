// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'channel_list.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({
    super.key,
    required this.onJoinCallPressed,
    required this.call,
  });

  final ValueChanged<CallConnectOptions> onJoinCallPressed;
  final Call call;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamLobbyViewTheme(
      data: StreamLobbyViewThemeData(
        backgroundColor: theme.scaffoldBackgroundColor,
        cardBackgroundColor: const Color(0xFF4C525C),
      ),
      child: StreamLobbyView(
        onCloseTap: () {
          if (Navigator.of(context).canPop()) {
            // ignore: use_build_context_synchronously
            context.pop();
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChannelList(),
              ));
        },
        call: call,
        onJoinCallPressed: onJoinCallPressed,
      ),
    );
  }
}
