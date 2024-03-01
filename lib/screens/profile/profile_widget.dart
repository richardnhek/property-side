import 'package:go_router/go_router.dart';

import '../../flutter_flow/custom_icons.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());

    _model.fullNameController ??=
        TextEditingController(text: currentUserDisplayName);
    _model.fullNameFocusNode ??= FocusNode();

    _model.emailController ??= TextEditingController(text: currentUserEmail);
    _model.emailFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

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
                                      child: AuthUserStreamWidget(
                                        builder: (context) => TextFormField(
                                          controller: _model.fullNameController,
                                          focusNode: _model.fullNameFocusNode,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintStyle: FlutterFlowTheme.of(
                                                    context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
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
                                              .fullNameControllerValidator
                                              .asValidator(context),
                                        ),
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
                                                imageUrl:
                                                    random_data.randomImageUrl(
                                                  50,
                                                  50,
                                                ),
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
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
                                            : () {
                                                print('Button pressed ...');
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
                              // GoRouter.of(context).prepareAuthEvent();
                              await authManager.signOut();
                              // GoRouter.of(context).clearRedirectLocation();

                              // context.goNamedAuth('Onboard', context.mounted);
                            },
                            text: 'Logout',
                            icon: Icon(
                              FFIcons.klogout,
                              size: 16,
                            ),
                            options: FFButtonOptions(
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
                            onPressed: true
                                ? null
                                : () {
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
