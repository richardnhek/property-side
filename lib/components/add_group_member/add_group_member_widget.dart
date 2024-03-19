import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../core/repos/app_preferences.dart';
import '../../di/injector.dart';
import '../../screens/channel_screen.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:sticky_headers/sticky_headers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_group_member_model.dart';
export 'add_group_member_model.dart';

class AddGroupMemberWidget extends StatefulWidget {
  const AddGroupMemberWidget({required this.userListController, super.key});

  final StreamUserListController userListController;

  @override
  State<AddGroupMemberWidget> createState() => _AddGroupMemberWidgetState();
}

class _AddGroupMemberWidgetState extends State<AddGroupMemberWidget> {
  late AddGroupMemberModel _model;
  List<String> selectedUserIds = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddGroupMemberModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.allUsers = await queryUsersRecordOnce();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            StickyHeader(
              overlapHeaders: false,
              header: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 75,
                          height: 25,
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).accent1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Add Members',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1,
                            ),
                      ),
                      InkWell(
                        onTap: selectedUserIds.isEmpty ||
                                selectedUserIds.length < 2
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please select at least 2 members',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    duration:
                                        const Duration(milliseconds: 4000),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).darkGrey,
                                  ),
                                );
                              }
                            : () async {
                                final prefs = locator.get<AppPreferences>();
                                final credentials = prefs.userCredentials;
                                final StreamChatClient client = locator.get();
                                final channel =
                                    client.channel('messaging', extraData: {
                                  'members': selectedUserIds.toList() +
                                      [credentials!.userInfo.id]
                                });
                                await channel.create();
                                await channel.watch();

                                // ignore: use_build_context_synchronously
                                Navigator.pop(
                                    context); // Close the add members page
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StreamChannel(
                                            channel: channel,
                                            child: ChannelPage(
                                                selectedMembers: selectedUserIds
                                                        .toList() +
                                                    [
                                                      credentials.userInfo.id
                                                    ]))));
                              },
                        child: Container(
                          width: 75,
                          height: 25,
                          decoration: BoxDecoration(),
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Text(
                              'Next',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              content: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1, -1),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 0, 0, 10),
                              child: Text(
                                'Testing Members',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
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
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 20, 10),
                                child: Builder(
                                  builder: (context) {
                                    final initialAUsers = _model.allUsers
                                            ?.where((e) =>
                                                functions.getUserInitial(
                                                    e.displayName) ==
                                                'A')
                                            .toList()
                                            ?.sortedList((e) => e.displayName)
                                            ?.toList() ??
                                        [];
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        PagedValueListenableBuilder<int, User>(
                                          valueListenable:
                                              widget.userListController,
                                          builder: (context, value, child) {
                                            return value.when(
                                              (users, nextPageKey, error) {
                                                if (users.isEmpty) {
                                                  return const Center(
                                                      child: Text(
                                                          'There are no users'));
                                                }
                                                return LazyLoadScrollView(
                                                  onEndOfPage: () async {
                                                    if (nextPageKey != null) {
                                                      widget.userListController
                                                          .loadMore(
                                                              nextPageKey);
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: users.length,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          final user =
                                                              users[index];
                                                          final selected =
                                                              selectedUserIds
                                                                  .contains(
                                                                      user.id);
                                                          return _ContactTile(
                                                            user: user,
                                                            selected: selected,
                                                            onTap: () {
                                                              setState(() {
                                                                if (selected) {
                                                                  selectedUserIds
                                                                      .remove(user
                                                                          .id);
                                                                } else {
                                                                  selectedUserIds
                                                                      .add(user
                                                                          .id);
                                                                }
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              loading: () => const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              error: (e) => Text(e.message),
                                            );
                                          },
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1, -1),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 0, 0, 10),
                              child: Text(
                                'Current Members',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
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
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 10, 20, 10),
                                child: Builder(
                                  builder: (context) {
                                    final initialRUsers = _model.allUsers
                                            ?.where((e) =>
                                                functions.getUserInitial(
                                                    e.displayName) ==
                                                'R')
                                            .toList()
                                            ?.sortedList((e) => e.displayName)
                                            ?.toList() ??
                                        [];
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children:
                                          List.generate(initialRUsers.length,
                                              (initialRUsersIndex) {
                                        final initialRUsersItem =
                                            initialRUsers[initialRUsersIndex];
                                        return Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CachedNetworkImage(
                                                  fadeInDuration: Duration(
                                                      milliseconds: 500),
                                                  fadeOutDuration: Duration(
                                                      milliseconds: 500),
                                                  imageUrl: initialRUsersItem
                                                      .photoUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1, -1),
                                                          child: Text(
                                                            initialRUsersItem
                                                                .displayName,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent1,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  lineHeight: 1,
                                                                ),
                                                          ),
                                                        ),
                                                        Theme(
                                                          data: ThemeData(
                                                            checkboxTheme:
                                                                CheckboxThemeData(
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .standard,
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .padded,
                                                              shape:
                                                                  CircleBorder(),
                                                            ),
                                                            unselectedWidgetColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                          ),
                                                          child: Checkbox(
                                                            value: _model
                                                                    .checkboxValueMap2[
                                                                initialRUsersItem] ??= true,
                                                            onChanged:
                                                                (newValue) async {
                                                              setState(() =>
                                                                  _model.checkboxValueMap2[
                                                                          initialRUsersItem] =
                                                                      newValue!);
                                                            },
                                                            activeColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            checkColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 0,
                                                      thickness: 1,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .lineColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 15)),
                                          ),
                                        );
                                      }).divide(SizedBox(height: 10)),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    Key? key,
    required this.user,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final User user;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              NetworkImage(user.image ?? 'https://placekitten.com/200/200'),
          backgroundColor: Colors.grey[200],
        ),
        title: Text(user.name ?? 'No Name',
            style: FlutterFlowTheme.of(context).bodyText1),
        subtitle: Text(user.id, style: FlutterFlowTheme.of(context).bodyText2),
        trailing:
            selected ? Icon(Icons.check_circle, color: Colors.green) : null,
      ),
    );
  }
}
