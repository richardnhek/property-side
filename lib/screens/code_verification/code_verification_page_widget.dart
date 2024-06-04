import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dogfooding/backend/schema/structs/index.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as strChat;
import 'package:stream_video_flutter/stream_video_flutter.dart' as strVideo;

import '../../app/user_auth_controller.dart';
import '../../backend/backend.dart';
import '../../backend/schema/users_record.dart';
import '../../core/repos/app_preferences.dart';
import '../../core/repos/token_service.dart';
import '../../di/injector.dart';
import '../../flutter_flow/nav/serialization_util.dart';
import '../../utils/loading_dialog.dart';
import '../home_screen.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import '../../flutter_flow/custom_functions.dart' as functions;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'code_verification_page_model.dart';
export 'code_verification_page_model.dart';

class CodeVerificationPageWidget extends StatefulWidget {
  const CodeVerificationPageWidget(
      {super.key, required this.phoneNumber, required this.verificationId});

  final String? phoneNumber;
  final String? verificationId;

  @override
  State<CodeVerificationPageWidget> createState() =>
      _CodeVerificationPageWidgetState();
}

class _CodeVerificationPageWidgetState
    extends State<CodeVerificationPageWidget> {
  late CodeVerificationPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _verificationId;
  String? userId;
  String? userName;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CodeVerificationPageModel());

    authManager.handlePhoneAuthStateChanges(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _loginWithPhoneNumber() async {
    final UsersRecord? thisUsersRecord = await functions.fetchUserRecord();

    // Generate a random string of 12 digits
    if (thisUsersRecord == null) {
      final random = Random();
      final randomNumbers =
          List.generate(12, (_) => random.nextInt(8)).join('');
      final propertySideRandomId = 'buyer$randomNumbers';
      final propertySideRandomName = 'buyer-name$randomNumbers';
      userId = propertySideRandomId;
      userName = propertySideRandomName;
      userImage =
          "https://cdn.iconscout.com/icon/free/png-256/free-profile-1481935-1254808.png";
    } else {
      userId = thisUsersRecord.uid;
      userName = thisUsersRecord.displayName;
      userImage = thisUsersRecord.photoUrl.isEmpty
          ? "https://cdn.iconscout.com/icon/free/png-256/free-profile-1481935-1254808.png"
          : thisUsersRecord.photoUrl;
    }

    final userInfo = strVideo.UserInfo(
        role: 'user', id: userId!, name: userName!, image: userImage);

    return _login(strVideo.User(info: userInfo));
  }

  Future<void> _login(strVideo.User user) async {
    // if (mounted) unawaited(showLoadingIndicator(context));

    // Register StreamVideo client with the user.
    final authController = locator.get<UserAuthController>();
    await authController.login(user);
    // if (mounted) hideLoadingIndicator(context);
    final strChat.StreamChatClient client = locator.get();
    await connectChatUserDev(client);
  }

  Future<void> connectChatUserDev(strChat.StreamChatClient thisClient) async {
    final prefs = locator.get<AppPreferences>();
    final credentials = prefs.userCredentials!;
    try {
      final tokenResponse = await locator
          .get<TokenService>()
          .loadToken(userId: credentials.userInfo.id);
      final token = tokenResponse.token;
      // ignore: use_build_context_synchronously

      await thisClient.connectUser(
        strChat.OwnUser(
            id: credentials.userInfo.id, name: userName, image: userImage),
        token,
      );
    } catch (error) {
      // Handle connection error
      print("Failed to connect user: $error");
      throw error; // Rethrow if you need to catch it outside
    }
  }

  Future<void> _verifyOTP2(String otpCode) async {
    setState(() {
      _verificationId = widget.verificationId;
    });
    print(widget.verificationId);
    print(_verificationId);
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otpCode,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (mounted) {
        // Add this check
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to verify OTP: $e")),
        );
      }
    }
    try {
      await _loginWithPhoneNumber();
      print("After _loginWithPhoneNumber");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to login: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 39, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 1,
                  color: FlutterFlowTheme.of(context).darkGrey3,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 20, 0),
                                child: Text(
                                  'We sent you a code to verify your mobile phone',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Inter',
                                        fontSize: 23,
                                      ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 50, 0, 0),
                                  child: Text(
                                    'Secure Code',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          lineHeight: 1.5,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 10, 20, 0),
                                child: PinCodeTextField(
                                  autoDisposeControllers: false,
                                  appContext: context,
                                  length: 6,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  enableActiveFill: false,
                                  autoFocus: true,
                                  enablePinAutofill: false,
                                  errorTextSpace: 0,
                                  showCursor: true,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  obscureText: false,
                                  hintCharacter: '*',
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    fieldHeight: 50,
                                    fieldWidth: 50,
                                    borderWidth: 1,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    shape: PinCodeFieldShape.box,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    inactiveColor:
                                        FlutterFlowTheme.of(context).darkGrey2,
                                    selectedColor: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    activeFillColor:
                                        FlutterFlowTheme.of(context).primary,
                                    inactiveFillColor:
                                        FlutterFlowTheme.of(context).darkGrey2,
                                    selectedFillColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryText,
                                  ),
                                  controller: _model.pinCodeController,
                                  onChanged: (_) {},
                                  onCompleted: (_) async {
                                    setState(() {
                                      _model.isFilled = true;
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _model.pinCodeControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                child: Builder(
                                  builder: (context) {
                                    if (_model.isSent == false) {
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {
                                            _model.isSent = true;
                                          });
                                          _model.timerController.onStartTimer();
                                          final phoneNumberVal =
                                              '+${widget.phoneNumber}';
                                          if (phoneNumberVal == null ||
                                              phoneNumberVal.isEmpty ||
                                              !phoneNumberVal.startsWith('+')) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Phone Number is required and has to start with +.'),
                                              ),
                                            );
                                            return;
                                          }
                                          // await authManager.beginPhoneAuth(
                                          //   context: context,
                                          //   phoneNumber: phoneNumberVal,
                                          //   onCodeSent: (context) async {
                                          //     context.goNamedAuth(
                                          //       'CodeVerificationPage',
                                          //       context.mounted,
                                          //       queryParameters: {
                                          //         'phoneNumber': serializeParam(
                                          //           widget.phoneNumber,
                                          //           ParamType.String,
                                          //         ),
                                          //       }.withoutNulls,
                                          //       ignoreRedirect: true,
                                          //     );
                                          //   },
                                          // );
                                        },
                                        child: Text(
                                          'Resend Code',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                      );
                                    } else {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FlutterFlowTimer(
                                            initialTime:
                                                _model.timerMilliseconds,
                                            getDisplayTime: (value) =>
                                                StopWatchTimer.getDisplayTime(
                                              value,
                                              hours: false,
                                              milliSecond: false,
                                            ),
                                            controller: _model.timerController,
                                            updateStateInterval:
                                                Duration(milliseconds: 1000),
                                            onChanged: (value, displayTime,
                                                shouldUpdate) {
                                              _model.timerMilliseconds = value;
                                              _model.timerValue = displayTime;
                                              if (shouldUpdate) setState(() {});
                                            },
                                            onEnded: () async {
                                              setState(() {
                                                _model.isSent = false;
                                              });
                                              _model.timerController
                                                  .onResetTimer();
                                            },
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  fontFamily: 'Inter',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    1, 0, 0, 0),
                                            child: Text(
                                              's',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                          child: FFButtonWidget(
                            onPressed: (_model.isFilled == false)
                                ? null
                                : () async {
                                    final smsCodeVal =
                                        _model.pinCodeController!.text;
                                    if (smsCodeVal == null ||
                                        smsCodeVal.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Enter SMS verification code.'),
                                        ),
                                      );
                                      return;
                                    }
                                    await _verifyOTP2(smsCodeVal);
                                  },
                            text: 'Confirm',
                            options: FFButtonOptions(
                              splashColor: FlutterFlowTheme.of(context).accent1,
                              width: double.infinity,
                              height: 50,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                  ),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              disabledColor:
                                  FlutterFlowTheme.of(context).darkGrey,
                            ),
                          ),
                        ),
                      ],
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
