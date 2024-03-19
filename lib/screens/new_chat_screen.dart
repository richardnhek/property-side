import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/flutter_flow/flutter_flow_util.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import '../components/add_group_member/add_group_member_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';

import '../core/model/user_credentials.dart';
import '../core/repos/app_preferences.dart';
import '../core/repos/token_service.dart';
import '../di/injector.dart';
import 'channel_screen.dart';
import 'new_chat_screen_model.dart';
export 'new_chat_screen_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late final StreamChatClient client;
  late final StreamUserListController userListController;
  late final AppPreferences prefs;
  late final UserCredentials credentials;
  late NewChatModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewChatModel());
    prefs = locator.get<AppPreferences>();
    credentials = prefs.userCredentials!;
    client = StreamChatCore.of(context).client;
    userListController = StreamUserListController(
      client: client,
      limit: 20,
      filter: Filter.notEqual('id', credentials.userInfo.id),
    );
    userListController.doInitialLoad();
  }

  @override
  void dispose() {
    userListController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
        title: Text(
          'New Chat',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 21,
                fontWeight: FontWeight.w500,
                lineHeight: 1,
              ),
        ),
        actions: [
          // Add actions if needed
        ],
      ),
      body: Material(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: Color(0x14000000),
                            offset: Offset(0, 0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return WebViewAware(
                                      child: GestureDetector(
                                        onTap: () => _model
                                                .unfocusNode.canRequestFocus
                                            ? FocusScope.of(context)
                                                .requestFocus(
                                                    _model.unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: Container(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.8,
                                            child: AddGroupMemberWidget(
                                              userListController:
                                                  userListController,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.group,
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        size: 24,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1, -1),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 15, 0, 0),
                                              child: Text(
                                                'New Group',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent1,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          lineHeight: 1,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 0,
                                            thickness: 1,
                                            color: FlutterFlowTheme.of(context)
                                                .lineColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 15)),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person_add_alt_rounded,
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      size: 24,
                                    ),
                                  ),
                                  Text(
                                    'New Contact',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          lineHeight: 1,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 15)),
                              ),
                            ),
                          ].divide(SizedBox(height: 10)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
                  child: PagedValueListenableBuilder<int, User>(
                    valueListenable: userListController,
                    builder: (context, value, child) {
                      return value.when(
                        (users, nextPageKey, error) {
                          if (users.isEmpty) {
                            return const Center(
                                child: Text('There are no users'));
                          }
                          return LazyLoadScrollView(
                            onEndOfPage: () async {
                              if (nextPageKey != null) {
                                userListController.loadMore(nextPageKey);
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 6,
                                        color: Color(0x14000000),
                                        offset: Offset(0, 0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 20, 10),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: users.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final user = users[index];
                                        return _ContactTile(
                                            user: user); // Pass user to tile
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e) => Text(e.message),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  Future<void> createChannel(BuildContext context) async {
    final prefs = locator.get<AppPreferences>();
    final credentials = prefs.userCredentials;
    final StreamChatClient client = locator.get();
    final members = [credentials!.userInfo.id, user.id];
    final channel =
        client.channel('messaging', extraData: {'members': members});
    await channel.watch();
    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Close the current page

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: ChannelPage(selectedMembers: members.map((m) => m).toList()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => createChannel(context),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.image ??
              'https://placekitten.com/200/200'), // Replace with actual image url
          backgroundColor: Colors.grey[200],
        ),
        title: Text(
          user.name ?? 'No Name',
          style: FlutterFlowTheme.of(context).bodyText1,
        ),
        subtitle: Text(
          user.id,
          style: FlutterFlowTheme.of(context).bodyText2,
        ),
      ),
    );
  }
}
