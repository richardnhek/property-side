import 'dart:async';
import 'dart:math' as Math;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dogfooding/backend/backend.dart';
import 'package:flutter_dogfooding/screens/code_verification/code_verification_page_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as strChat;

import '../../core/repos/app_preferences.dart';
import '../../core/repos/token_service.dart';
import '../../di/injector.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'new_login_model.dart';
import '/flutter_flow/custom_functions.dart' as functions;

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  late NewLoginModel _model;

  String? _verificationId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewLoginModel());

    _model.phoneNumberController ??= TextEditingController();
    _model.phoneNumberFocusNode ??= FocusNode();

    // authManager.handlePhoneAuthStateChanges(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _checkLoginState();
    });
  }

  Future<void> _sendOTP() async {
    try {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
            phoneNumber: _model.phoneNumberController.text,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to send OTP: ${e.message}")),
              );
            },
            codeSent: (String verificationId, int? resendToken) {
              setState(() {
                _verificationId = verificationId;
              });
              print(_verificationId);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CodeVerificationPageWidget(
                        phoneNumber: _model.phoneNumberController.text,
                        verificationId: _verificationId)),
              );
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          )
          .then((value) => null);
      // ignore: use_build_context_synchronously
    } catch (e) {
      rethrow;
    }
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
          id: credentials.userInfo.id,
        ),
        token,
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1.0, -1.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
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
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    alignment: const AlignmentDirectional(0.0, -1.0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 0, 20, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome Back',
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                          fontFamily: 'Inter',
                                          fontSize: 23,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 15, 0, 0),
                                    child: Text(
                                      'Please enter your phone number to verify and join the workspace.',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context)
                                                .darkGrey,
                                            fontSize: 15,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 40, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              -1.0, -1.0),
                                          child: Text(
                                            'Phone number',
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: TextFormField(
                                                    controller: _model
                                                        .phoneNumberController,
                                                    focusNode: _model
                                                        .phoneNumberFocusNode,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      '_model.phoneNumberController',
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () => setState(() {}),
                                                    ),
                                                    onFieldSubmitted:
                                                        (_) async {
                                                      final phoneNumberVal = _model
                                                          .phoneNumberController
                                                          .text;
                                                      if (phoneNumberVal == null ||
                                                          phoneNumberVal
                                                              .isEmpty ||
                                                          !phoneNumberVal
                                                              .startsWith(
                                                                  '+')) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Phone Number is required and has to start with +.'),
                                                          ),
                                                        );
                                                        return;
                                                      }
                                                      _sendOTP();
                                                    },
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Colors
                                                                    .transparent,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                      hintText:
                                                          '+61 ### ### ###',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .darkGrey,
                                                                fontSize: 16,
                                                                lineHeight: 1.5,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .darkGrey3,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .darkGrey3,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0x00000000),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 16,
                                                        ),
                                                    maxLines: null,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    validator: _model
                                                        .phoneNumberControllerValidator
                                                        .asValidator(context),
                                                    inputFormatters: [
                                                      AustralianPhoneInputFormatter(),
                                                      LengthLimitingTextInputFormatter(
                                                          15), // Limiting length including country code
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: FFButtonWidget(
                              onPressed: (_model.phoneNumberController.text ==
                                      '')
                                  ? null
                                  : () async {
                                      _model.existingUser =
                                          await queryUsersRecordOnce(
                                        queryBuilder: (usersRecord) =>
                                            usersRecord.where(
                                          'phone_number',
                                          isEqualTo: functions
                                              .getFormattedPhoneNo(_model
                                                  .phoneNumberController.text),
                                        ),
                                        singleRecord: true,
                                      ).then((s) => s.firstOrNull);
                                      if ((_model.existingUser != null) ==
                                          true) {
                                        final phoneNumberVal =
                                            _model.phoneNumberController.text;
                                        if (phoneNumberVal.isEmpty ||
                                            !phoneNumberVal.startsWith('+')) {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Phone Number is required and has to start with +.'),
                                            ),
                                          );
                                          return;
                                        }
                                        await _sendOTP();
                                      }
                                    },
                              text: 'Continue',
                              options: FFButtonOptions(
                                splashColor:
                                    FlutterFlowTheme.of(context).accent1,
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                    ),
                                elevation: 0,
                                borderSide: const BorderSide(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AustralianPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    // Return directly if user is deleting and manage deletion to avoid format issues
    if (newValue.text.length < oldValue.text.length) {
      if (oldValue.text.endsWith(" 0") &&
          newValue.text.length + 1 == oldValue.text.length) {
        // Handle specific case where user backspaces the "0" after "+61 "
        return newValue.copyWith(
            text:
                newValue.text.substring(0, newValue.text.length - 3) + "+61 ");
      }
      return newValue;
    }
    // Remove all non-digit characters
    newText = newText.replaceAll(RegExp(r'\D'), '');

    String formattedString = '+61';
    if (newText.startsWith('61')) {
      newText = newText.substring(2); // Remove '61' if it's part of the input
    }

    // Applying logic for temporary leading zero visibility
    if (newText.startsWith('0') && newText.length == 1) {
      // Keep the "0" if it's the only digit entered after "+61"
    } else if (newText.startsWith('0')) {
      // Remove the leading "0" for any subsequent digit entry
      newText = newText.substring(1);
    }

    // Formatting the rest of the phone number after handling the leading "0"
    if (newText.length > 0) {
      formattedString +=
          ' ' + newText.substring(0, Math.min(3, newText.length));
    }
    if (newText.length > 3) {
      formattedString +=
          ' ' + newText.substring(3, Math.min(6, newText.length));
    }
    if (newText.length > 6) {
      formattedString +=
          ' ' + newText.substring(6, Math.min(9, newText.length));
    }

    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(offset: formattedString.length),
    );
  }
}
