import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as streamFlutter;

import '../../app/user_auth_controller.dart';
import '../../backend/backend.dart';
import '../../backend/firebase_storage/storage.dart';
import '../../di/injector.dart';
import '../../flutter_flow/custom_icons.dart';
import '../../flutter_flow/upload_data.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../flutter_flow/custom_functions.dart' as functions;

import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;
  late final _userAuthController = locator.get<UserAuthController>();
  late final User user;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    user = FirebaseAuth.instance.currentUser!;

    _model.fullNameController ??= TextEditingController(text: '');
    _model.fullNameFocusNode ??= FocusNode();
    _model.emailController ??= TextEditingController(text: '');

    _model.emailFocusNode ??= FocusNode();

    _fetchAndSetUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> _fetchAndSetUserData() async {
    final userRecord = await functions.fetchUserRecord();
    if (userRecord != null) {
      setState(() {
        _model.fullNameController?.text = userRecord.displayName ?? '';
        _model.emailController?.text = userRecord.email ?? '';
        _model.userProPic = userRecord.photoUrl ?? '';
        _model.originalUserProPic = userRecord.photoUrl ?? '';
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> updateUserName(String newName) async {
    // final user = FirebaseAuth.instance.currentUser;
    if (newName.isNotEmpty) {
      try {
        // Update Firebase Auth user display name
        await user.updateDisplayName(newName);
        await user.reload(); // Reload the user data from Firebase Auth

        // Update user record in Firestore
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDocRef.update({
          'display_name': newName
        }); // Make sure 'display_name' corresponds to your field in Firestore

        // Optionally, refresh local user data
        final updatedUser = FirebaseAuth.instance.currentUser;
        final DocumentSnapshot userDocSnapshot = await userDocRef.get();
        if (userDocSnapshot.exists) {
          Map<String, dynamic> data =
              userDocSnapshot.data() as Map<String, dynamic>;
          UsersRecord userRecord =
              UsersRecord.getDocumentFromData(data, userDocSnapshot.reference);
          // Update any local state you have with this new userRecord
        }

        // Update the UI or local model to reflect the change
        setState(() {
          _model.fullNameController?.text = updatedUser?.displayName ?? '';
        });

        // Show success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved!')),
        );
      } catch (e) {
        // Handle errors, for example log them or show a message to the user
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving changes')),
        );
        rethrow;
      }
    } else {
      // Handle case where there is no user logged in, or the new name is empty
      print('No user is signed in or the new name is empty.');
    }
  }

  Future<void> updateUserProfilePicture() async {
    if (_model.userProPic.isNotEmpty &&
        _model.userProPic != _model.originalUserProPic) {
      try {
        // Update Firebase Auth user profile picture
        await user.updatePhotoURL(_model.userProPic);
        await user.reload(); // Reload the user data from Firebase Auth

        // Update user record in Firestore
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDocRef.update({'photo_url': _model.userProPic});

        setState(() {
          _model.userProPic = user.photoURL ?? '';
          _model.originalUserProPic = _model.userProPic;
        });
      } catch (e) {
        rethrow;
      }
    } else {
      // No changes made
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = streamFlutter.StreamChat.of(context).client;
    streamFlutter.User? currentChatUser =
        streamFlutter.StreamChat.of(context).currentUser;
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 75,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(-1, 1),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 15),
                      child: Text(
                        'Profile',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 17,
                              lineHeight: 1.5,
                            ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: FlutterFlowTheme.of(context).darkGrey3,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 110,
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      'Full name',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBtnText,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Color(0x14000000),
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .darkGrey3,
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _model.fullNameController,
                                        focusNode: _model.fullNameFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.fullNameController',
                                          Duration(milliseconds: 100),
                                          () async {
                                            setState(() {
                                              _model.isChanged = true;
                                            });
                                          },
                                        ),
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .headlineMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                        validator: _model
                                            .fullNameControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 110,
                                      decoration: BoxDecoration(),
                                      child: Text(
                                        'Profile photo',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              lineHeight: 1.5,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                fadeInDuration:
                                                    Duration(milliseconds: 500),
                                                fadeOutDuration:
                                                    Duration(milliseconds: 500),
                                                imageUrl: _model.userProPic,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  final selectedMedia =
                                                      await selectMediaWithSourceBottomSheet(
                                                    context: context,
                                                    allowPhoto: true,
                                                  );
                                                  if (selectedMedia != null &&
                                                      selectedMedia.every((m) =>
                                                          validateFileFormat(
                                                              m.storagePath,
                                                              context))) {
                                                    setState(() => _model
                                                            .isDataUploading1 =
                                                        true);
                                                    var selectedUploadedFiles =
                                                        <FFUploadedFile>[];
                                                    var downloadUrls =
                                                        <String>[];
                                                    try {
                                                      showUploadMessage(
                                                        context,
                                                        'Uploading file...',
                                                        showLoading: true,
                                                      );
                                                      selectedUploadedFiles =
                                                          selectedMedia
                                                              .map((m) =>
                                                                  FFUploadedFile(
                                                                    name: m
                                                                        .storagePath
                                                                        .split(
                                                                            '/')
                                                                        .last,
                                                                    bytes:
                                                                        m.bytes,
                                                                    height: m
                                                                        .dimensions
                                                                        ?.height,
                                                                    width: m
                                                                        .dimensions
                                                                        ?.width,
                                                                    blurHash: m
                                                                        .blurHash,
                                                                  ))
                                                              .toList();
                                                      downloadUrls =
                                                          (await Future.wait(
                                                        selectedMedia.map(
                                                          (m) async =>
                                                              await uploadData(
                                                                  m.storagePath,
                                                                  m.bytes),
                                                        ),
                                                      ))
                                                              .where((u) =>
                                                                  u != null)
                                                              .map((u) => u!)
                                                              .toList();
                                                    } finally {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar();
                                                      _model.isDataUploading1 =
                                                          false;
                                                    }
                                                    if (selectedUploadedFiles
                                                                .length ==
                                                            selectedMedia
                                                                .length &&
                                                        downloadUrls.length ==
                                                            selectedMedia
                                                                .length) {
                                                      setState(() {
                                                        _model.uploadedLocalFile1 =
                                                            selectedUploadedFiles
                                                                .first;
                                                        _model.uploadedFileUrl1 =
                                                            downloadUrls.first;
                                                      });
                                                      showUploadMessage(
                                                          context, 'Success!');
                                                    } else {
                                                      setState(() {});
                                                      showUploadMessage(context,
                                                          'Failed to upload data');
                                                      return;
                                                    }
                                                  }
                                                  setState(() {
                                                    _model.userProPic =
                                                        _model.uploadedFileUrl1;
                                                    _model.isChanged = true;
                                                    print(
                                                        "This is _model.userProPic: ${_model.userProPic}");
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .darkGrey3,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  child: Text(
                                                    'Upload',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .darkGrey3,
                                                    width: 1,
                                                  ),
                                                ),
                                                alignment:
                                                    AlignmentDirectional(0, 0),
                                                child: Text(
                                                  'Remove',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent1,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 10)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 35, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed: (_model.isChanged == false)
                                            ? null
                                            : () async {
                                                await _fetchAndSetUserData();
                                                setState(() {
                                                  _model.isChanged = false;
                                                });
                                              },
                                        text: 'Discard changes',
                                        options: FFButtonOptions(
                                          height: 50,
                                          padding: EdgeInsets.all(0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          color: Color(0x00FFFFFF),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          elevation: 0,
                                          borderSide: BorderSide(
                                            color: Color(0x7914181B),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          disabledTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .darkGrey4,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed: (_model.isChanged == false)
                                            ? null
                                            : () async {
                                                await updateUserName(_model
                                                        .fullNameController
                                                        ?.text ??
                                                    '');
                                                if (_model.uploadedFileUrl1
                                                    .isNotEmpty) {
                                                  updateUserProfilePicture();
                                                }
                                                await client.updateUser(
                                                  streamFlutter.User(
                                                    id: currentChatUser!.id,
                                                    extraData: {
                                                      'name': _model
                                                              .fullNameController
                                                              ?.text ??
                                                          '',
                                                      'image': _model.userProPic
                                                              .isEmpty
                                                          ? _model
                                                              .originalUserProPic
                                                          : _model.userProPic,
                                                    },
                                                  ),
                                                );

                                                setState(() {
                                                  _model.isChanged = false;
                                                });
                                              },
                                        text: 'Save Changes',
                                        options: FFButtonOptions(
                                          height: 50,
                                          padding: EdgeInsets.all(0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 0,
                                          borderSide: BorderSide(
                                            color: Color(0x49105035),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          disabledColor:
                                              FlutterFlowTheme.of(context)
                                                  .darkGrey4,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 15)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 60,
                          thickness: 1,
                          color: FlutterFlowTheme.of(context).darkGrey3,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Information',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 17,
                                    ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 110,
                                      decoration: BoxDecoration(),
                                      child: Text(
                                        'Email address',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              lineHeight: 1.5,
                                            ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBtnText,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x14000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .darkGrey3,
                                            width: 1,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _model.emailController,
                                          focusNode: _model.emailFocusNode,
                                          readOnly: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'alex@gmail.com',
                                            hintStyle: FlutterFlowTheme.of(
                                                    context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .headlineMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          validator: _model
                                              .emailControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 35, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed:
                                            (_model.isEmailChanged == false)
                                                ? null
                                                : () {
                                                    print('Button pressed ...');
                                                  },
                                        text: 'Discard changes',
                                        options: FFButtonOptions(
                                          height: 50,
                                          padding: EdgeInsets.all(0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          color: Color(0x00FFFFFF),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          elevation: 0,
                                          borderSide: BorderSide(
                                            color: Color(0x7814181B),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          disabledTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .darkGrey4,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FFButtonWidget(
                                        onPressed:
                                            (_model.isEmailChanged == false)
                                                ? null
                                                : () {
                                                    print('Button pressed ...');
                                                  },
                                        text: 'Save Changes',
                                        options: FFButtonOptions(
                                          height: 50,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24, 0, 24, 0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          color: FlutterFlowTheme.of(context)
                                              .accent1,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                          elevation: 0,
                                          borderSide: BorderSide(
                                            color: Color(0x49105035),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          disabledColor:
                                              FlutterFlowTheme.of(context)
                                                  .darkGrey4,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 15)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 60,
                          thickness: 1,
                          color: FlutterFlowTheme.of(context).darkGrey3,
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              await _userAuthController.logout();
                            },
                            text: 'Logout',
                            icon: Icon(
                              FFIcons.klogout,
                              size: 16,
                            ),
                            options: FFButtonOptions(
                              splashColor: FlutterFlowTheme.of(context).accent1,
                              hoverColor: FlutterFlowTheme.of(context).primary,
                              hoverTextColor: Colors.white,
                              width: 140,
                              height: 50,
                              padding: EdgeInsets.all(0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: Colors.transparent,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              print('Button pressed ...');
                            },
                            text: 'Delete Account',
                            icon: Icon(
                              Icons.delete_outline,
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              size: 21,
                            ),
                            options: FFButtonOptions(
                              width: 180,
                              height: 50,
                              padding: EdgeInsets.all(0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: Color(0xFFFF1924),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
                                    fontWeight: FontWeight.w500,
                                  ),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              disabledColor:
                                  FlutterFlowTheme.of(context).darkGrey,
                            ),
                          ),
                        ),
                      ].addToEnd(SizedBox(height: 75)),
                    ),
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
