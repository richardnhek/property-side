import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat/src/core/models/filter.dart' as filterStream;

import '../core/model/user_credentials.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
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

  @override
  void initState() {
    super.initState();
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
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                child: const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Container(
                width: 27,
                height: 27,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                child: const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Icon(
                    Icons.video_camera_front_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
          leading: Center(
            child: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              child: const Align(
                alignment: AlignmentDirectional(0, 0),
                child: Icon(
                  Icons.keyboard_control_rounded,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ),
            ),
          ),
          titleBuilder: (context, status, client) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                'Chats',
                style: GoogleFonts.inter(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
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
          itemBuilder: (context, channelList, channelIndex, channelListTile) {
            final channel = channelList[channelIndex];
            final channelName = channel.name;
            final lastMessage =
                channel.state?.messages.last.text ?? 'No messages yet';
            final lastMessageTime =
                channel.state?.messages.last.createdAt ?? DateTime.now();

            return // Generated code for this Container Widget...
                InkWell(
              onTap: () async {
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
              },
              child: Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: StreamChannelAvatar(
                                channel: channel,
                                constraints: const BoxConstraints(
                                    maxHeight: 50, maxWidth: 50),
                              )),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1, -1),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StreamChannelName(
                                          channel: channel,
                                          textOverflow: TextOverflow.ellipsis,
                                          textStyle: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: channel.state?.messages
                                                            .last.user?.id ==
                                                        credentials.userInfo.id
                                                    ? ''
                                                    : "${channel.state?.messages.last.user?.name}: " ??
                                                        'Alex: ',
                                                style: GoogleFonts.inter(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: lastMessage ?? 'Awesome!',
                                                style: GoogleFonts.getFont(
                                                  'Inter',
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  height: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '04:22',
                                        style: GoogleFonts.inter(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          onChannelTap: (channel) async {
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
          },
        ),
        // body: StreamChannelListView(
        //   controller: _listController!,
        //   onChannelTap: (channel) async {
        //     final members = await getMemberIds(channel);
        //     // ignore: use_build_context_synchronously
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => StreamChannel(
        //           channel: channel,
        //           child: ChannelPage(
        //             selectedMembers: members,
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }

  @override
  void dispose() {
    _listController?.dispose();
    super.dispose();
  }
}
