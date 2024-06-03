import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat/src/core/models/filter.dart' as filterStream;
import 'package:intl/intl.dart';

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
  String _searchQuery = '';
  late TextEditingController _searchController;

  late final messageSearchListController = StreamMessageSearchListController(
      client: StreamChat.of(context).client,
      searchQuery: '',
      filter: filterStream.Filter.in_('members', [currentChatUser!.id]));

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
    _searchController = TextEditingController();
    _listController = StreamChannelListController(
      client: client,
      filter: filterStream.Filter.in_('members', [currentChatUser!.id]),
      channelStateSort: const [SortOption('last_message_at')],
      limit: 20,
    );

    messageSearchListController.doInitialLoad();
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

  void _updateListController() {
    filterStream.Filter filter;
    if (_searchQuery.isNotEmpty) {
      filter = filterStream.Filter.and([
        filterStream.Filter.in_('members', [currentChatUser!.id]),
        filterStream.Filter.equal('name', _searchQuery)
      ]);
    } else {
      filter = filterStream.Filter.in_('members', [currentChatUser!.id]);
    }

    _listController = StreamChannelListController(
      client: client,
      filter: filter,
      channelStateSort: const [SortOption('last_message_at')],
      limit: 20,
    );

    // Force widget to rebuild with new controller
    setState(() {});
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
                    MaterialPageRoute(
                        builder: (context) => const ContactsPage()),
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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      border: Border.all(
                          color: FlutterFlowTheme.of(context).darkGrey2,
                          width: 2.0)),
                  height: 60.0,
                  child: Center(
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: FlutterFlowTheme.of(context).primaryText),
                      cursorColor: Colors.red,
                      decoration: const InputDecoration(
                          hintText: 'Search for chats...',
                          prefixIcon: Icon(Icons.search),
                          focusedBorder: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _updateListController();
                          messageSearchListController
                            ..searchQuery = value
                            ..doInitialLoad();
                        });
                      },
                    ),
                  ),
                ),
              ),
              _searchQuery.isNotEmpty
                  ? Expanded(
                      child: PagedValueListenableBuilder<String,
                          GetMessageResponse>(
                        valueListenable: messageSearchListController,
                        builder: (context, value, child) {
                          return value.when(
                            (responses, nextPageKey, error) =>
                                LazyLoadScrollView(
                              onEndOfPage: () async {
                                if (nextPageKey != null) {
                                  messageSearchListController
                                      .loadMore(nextPageKey);
                                }
                              },
                              child: ListView.builder(
                                itemCount:
                                    (nextPageKey != null || error != null)
                                        ? responses.length + 1
                                        : responses.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == responses.length) {
                                    if (error != null) {
                                      return TextButton(
                                        onPressed: () {
                                          messageSearchListController.retry();
                                        },
                                        child: Text(error.message),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  }

                                  final item = responses[index];
                                  final searchedChannel = client.channel(
                                      'messaging',
                                      id: item.channel?.id);
                                  return InkWell(
                                    onTap: () async {
                                      final members =
                                          await getMemberIds(searchedChannel);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StreamChannel(
                                            channel: searchedChannel,
                                            child: ChannelPage(
                                              selectedMembers: members,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: StreamChannelListTile(
                                        channel: searchedChannel,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            loading: () => const Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (e) => Center(
                              child: Text(
                                'Oh no, something went wrong. '
                                'Please check your config. $e',
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                    ),
              _searchQuery.isEmpty
                  ? Expanded(
                      child: StreamChannelListView(
                        controller: _listController!,
                        separatorBuilder: (context, channelList, channelIndex) {
                          return Divider(
                              color: FlutterFlowTheme.of(context).darkGrey3,
                              indent: 10.0,
                              endIndent: 10.0,
                              height: 10);
                        },
                        itemBuilder:
                            (context, channels, index, defaultChannelListTile) {
                          final channel = channels[index];
                          return InkWell(
                            onTap: () async {
                              if (_isSelectionMode) {
                                setState(() {
                                  if (_selectedChannelIds
                                      .contains(channel.id)) {
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
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listController?.dispose();
    _searchController.dispose();
    messageSearchListController.dispose();
    super.dispose();
  }
}
