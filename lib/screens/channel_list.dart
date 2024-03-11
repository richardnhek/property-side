import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat/src/core/models/filter.dart' as filterStream;

import '../core/model/user_credentials.dart';
import '../core/repos/app_preferences.dart';
import '../core/repos/token_service.dart';
import '../di/injector.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'channel_screen.dart';
import 'new_chat_screen.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  late final StreamChatClient client;
  StreamChannelListController? _listController;
  OwnUser? currentChatUser;
  late final AppPreferences prefs;
  late final UserCredentials credentials;
  List<String> _selectedChannelIds = [];
  bool _isSelectionMode = false;
  bool _canDeleteSelectedChannels = false;
  bool _isCheckingDeletable = false;

  @override
  void initState() {
    super.initState();
    if (StreamChat.of(context).currentUser == null) {
      connectChatUser();
    }
    client = StreamChatCore.of(context).client;
    prefs = locator.get<AppPreferences>();
    credentials = prefs.userCredentials!;
    currentChatUser = OwnUser(id: credentials.userInfo.id);
    _listController = StreamChannelListController(
      client: client,
      filter: filterStream.Filter.in_('members', [currentChatUser!.id]),
      channelStateSort: const [SortOption('last_message_at')],
      limit: 20,
    );
  }

  Future<void> deleteSelectedChannels() async {
    for (String channelId in _selectedChannelIds) {
      final channel = client.channel('messaging', id: channelId);
      await channel.delete();
    }
    setState(() {
      _selectedChannelIds.clear(); // Clear selection after deletion
    });
    // Optionally, refresh your channel list here if necessary
  }

  Future<void> updateCanDeleteStatus() async {
    setState(() {
      _isCheckingDeletable = true;
    });
    bool canDelete = true;
    for (String channelId in _selectedChannelIds) {
      final channel = client.channel('messaging', id: channelId);
      final response = await channel.queryMembers();
      if (response.members.length > 2) {
        canDelete = false;
        break;
      }
    }
    setState(() {
      _canDeleteSelectedChannels = canDelete;
      _isCheckingDeletable = false;
    });
  }

  void connectChatUser() async {
    final prefs = locator.get<AppPreferences>();
    final credentials = prefs.userCredentials!;
    final client = StreamChat.of(context).client;
    try {
      final tokenResponse = await locator
          .get<TokenService>()
          .loadToken(userId: credentials.userInfo.id);
      final token = tokenResponse.token;
      // ignore: use_build_context_synchronously

      await client.connectUser(
        OwnUser(
          id: credentials.userInfo.id,
        ),
        token,
      );
    } catch (error) {
      // Handle connection error
      print("Failed to connect user: $error");
      throw error; // Rethrow if you need to catch it outside
    }
  }

  String formatCreatedAt(DateTime createdAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck =
        DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (dateToCheck == today) {
      // If the createdAt is today, only show the time
      return DateFormat('HH:mm').format(createdAt);
    } else {
      // If the createdAt is a different day, show the full date in dd/mm/yy format
      return DateFormat('dd/MM/yy').format(createdAt);
    }
  }

  Future<List<String?>> getMemberIds(Channel channel) async {
    try {
      // Await the queryMembers call to complete and get the response
      final response = await channel.queryMembers();

      // Extracting member IDs from the response
      final memberIds = response.members.map((m) => m.userId).toList();

      return memberIds;
    } catch (e) {
      print('Error fetching member IDs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentChatUser == null || _listController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamChatTheme(
      data: StreamChatThemeData.light().copyWith(
          channelListHeaderTheme: const StreamChannelListHeaderThemeData()
              .copyWith(color: Colors.white)),
      child: Scaffold(
        appBar: StreamChannelListHeader(
          client: client,
          centerTitle: true,
          elevation: 0,
          actions: [
            if (_selectedChannelIds.isNotEmpty)
              _isCheckingDeletable
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey, // or any other color
                          ),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _selectedChannelIds.isNotEmpty &&
                              _canDeleteSelectedChannels
                          ? () {
                              // Your existing deletion confirmation logic
                            }
                          : null, // Disable button if deletion is not allowed
                    ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactsPage()),
                );
              },
              child: Container(
                width: 27,
                height: 27,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Icon(
                    Icons.add_rounded,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
          leading: Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _isSelectionMode = !_isSelectionMode;
                  if (!_isSelectionMode) {
                    _selectedChannelIds
                        .clear(); // Clear selections when leaving selection mode
                  }
                });
              },
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.5,
                  ),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Icon(
                    _isSelectionMode
                        ? Icons.close
                        : Icons.keyboard_control_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          titleBuilder: (context, status, client) {
            return !_isSelectionMode
                ? Text(
                    'Chats',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                  )
                : Text(
                    '${_selectedChannelIds.length} selected',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                  );
          },
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: StreamChannelListView(
          controller: _listController!,
          separatorBuilder: (context, channelList, channelIndex) {
            return const SizedBox(width: 0, height: 0);
          },
          itemBuilder: (context, channels, index, defaultChannelListTile) {
            final channel = channels[index];
            return GestureDetector(
              onTap: () async {
                if (_isSelectionMode) {
                  setState(() {
                    if (_selectedChannelIds.contains(channel.id)) {
                      _selectedChannelIds.remove(channel.id);
                    } else {
                      _selectedChannelIds.add(channel.id!);
                    }
                  });
                  await updateCanDeleteStatus();
                } else {
                  final members = await getMemberIds(channel);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StreamChannel(
                        channel: channel,
                        child: ChannelPage(
                          selectedMembers: members,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                color: _selectedChannelIds.contains(channel.id)
                    ? Colors.blue[100]
                    : null, // Highlight if selected
                child: defaultChannelListTile,
              ),
            );
          },
          // onChannelTap: (channel) async {
          //   if (_isSelectionMode == false) {
          // final members = await getMemberIds(channel);
          // // ignore: use_build_context_synchronously
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => StreamChannel(
          //       channel: channel,
          //       child: ChannelPage(
          //         selectedMembers: members,
          //       ),
          //     ),
          //   ),
          // );
          //   }
          // },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listController?.dispose();
    super.dispose();
  }
}
