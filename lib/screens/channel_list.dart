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
                  Icons.keyboard_control_rounded,
                  color: FlutterFlowTheme.of(context).primary,
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
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
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
          // itemBuilder: (context, channelList, channelIndex, channelListTile) {
          //   final channel = channelList[channelIndex];
          //   final channelName = channel.name;
          //   final lastMessage =
          //       channel.state?.messages.last.text ?? 'No messages yet';
          //   final lastMessageTime =
          //       channel.state?.messages.last.createdAt ?? DateTime.now();

          //   return InkWell(
          //     onTap: () async {
          //       final members = await getMemberIds(channel);
          //       // ignore: use_build_context_synchronously
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => StreamChannel(
          //             channel: channel,
          //             child: ChannelPage(
          //               selectedMembers: members,
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //     child: Container(
          //       width: double.infinity,
          //       height: 75,
          //       decoration: BoxDecoration(
          //         color: Colors.transparent,
          //       ),
          //       child: Padding(
          //         padding: EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.max,
          //           children: [
          //             Row(
          //               mainAxisSize: MainAxisSize.max,
          //               children: [
          //                 Container(
          //                     width: 50,
          //                     height: 50,
          //                     clipBehavior: Clip.antiAlias,
          //                     decoration: const BoxDecoration(
          //                       shape: BoxShape.circle,
          //                     ),
          //                     child: StreamChannelAvatar(
          //                       channel: channel,
          //                       constraints: const BoxConstraints(
          //                           maxHeight: 50, maxWidth: 50),
          //                     )),
          //               ],
          //             ),
          //             Expanded(
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.max,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Padding(
          //                     padding:
          //                         EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
          //                     child: Row(
          //                       mainAxisSize: MainAxisSize.max,
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Align(
          //                           alignment: AlignmentDirectional(-1, -1),
          //                           child: Column(
          //                             mainAxisSize: MainAxisSize.max,
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               StreamChannelName(
          //                                 channel: channel,
          //                                 textOverflow: TextOverflow.ellipsis,
          //                                 textStyle:
          //                                     FlutterFlowTheme.of(context)
          //                                         .bodyMedium
          //                                         .override(
          //                                           fontFamily: 'Inter',
          //                                           fontSize: 15,
          //                                           fontWeight: FontWeight.w600,
          //                                           lineHeight: 1,
          //                                         ),
          //                               ),
          //                               RichText(
          //                                 textScaleFactor:
          //                                     MediaQuery.of(context)
          //                                         .textScaleFactor,
          //                                 text: TextSpan(
          //                                   children: [
          //                                     TextSpan(
          //                                       text: channel.state?.messages
          //                                                   .last.user?.id ==
          //                                               credentials.userInfo.id
          //                                           ? ''
          //                                           : "${channel.state?.messages.last.user?.name}: " ??
          //                                               'Alex: ',
          //                                       style:
          //                                           FlutterFlowTheme.of(context)
          //                                               .bodyMedium
          //                                               .override(
          //                                                 fontFamily: 'Inter',
          //                                                 color: FlutterFlowTheme
          //                                                         .of(context)
          //                                                     .darkGrey4,
          //                                                 fontWeight:
          //                                                     FontWeight.w600,
          //                                                 lineHeight: 1,
          //                                               ),
          //                                     ),
          //                                     TextSpan(
          //                                       text: lastMessage ?? 'Awesome!',
          //                                       style: GoogleFonts.getFont(
          //                                         'Inter',
          //                                         color: FlutterFlowTheme.of(
          //                                                 context)
          //                                             .darkGrey4,
          //                                         fontSize: 14,
          //                                         height: 1,
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         Column(
          //                           mainAxisSize: MainAxisSize.max,
          //                           children: [
          //                             Text(
          //                               formatCreatedAt(channel
          //                                   .state!.messages.last.createdAt),
          //                               style: FlutterFlowTheme.of(context)
          //                                   .bodyMedium
          //                                   .override(
          //                                     fontFamily: 'Inter',
          //                                     color:
          //                                         FlutterFlowTheme.of(context)
          //                                             .darkGrey3,
          //                                     lineHeight: 1,
          //                                   ),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Divider(
          //                     height: 0,
          //                     thickness: 1,
          //                     color: FlutterFlowTheme.of(context).lineColor,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   );
          // },
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
