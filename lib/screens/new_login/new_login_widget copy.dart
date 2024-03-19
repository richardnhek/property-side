import 'dart:async';
import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dogfooding/backend/backend.dart';
import 'package:flutter_dogfooding/screens/home_screen.dart';
import 'package:flutter_dogfooding/screens/login_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as strChat;

import '../../app/user_auth_controller.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '../../core/repos/app_preferences.dart';
import '../../core/repos/token_service.dart';
import '../../di/injector.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/nav/serialization_util.dart';
import '../../utils/loading_dialog.dart';
import 'new_login_model.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as strVideo;

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

  void _checkLoginState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _loginWithEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    // Generate a random string of 12 digits
    final random = Random();
    final randomNumbers = List.generate(12, (_) => random.nextInt(8)).join('');
    final propertySideRandomId = 'buyer$randomNumbers';
    final propertySideRandomName = 'buyer-name$randomNumbers';

    final userId = user != null ? user.uid : propertySideRandomId;
    final userName = user?.displayName ?? propertySideRandomName;

    final userInfo = strVideo.UserInfo(
      role: 'user',
      id: userId,
      name: userName,
    );

    return _login(strVideo.User(info: userInfo));
  }

  void _sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
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
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> _login(strVideo.User user) async {
    if (mounted) unawaited(showLoadingIndicator(context));

    // Register StreamVideo client with the user.
    final authController = locator.get<UserAuthController>();
    await authController.login(user);
    final strChat.StreamChatClient client = locator.get();
    await connectChatUserDev(client);

    if (mounted) hideLoadingIndicator(context);
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
      // Handle connection error
      print("Failed to connect user: $error");
      throw error; // Rethrow if you need to catch it outside
    }
  }

  void _verifyOTP2() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _model.pinCodeController.text,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      await _loginWithEmail();
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are logged in!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP: $e")),
      );
    }
  }

  void _verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otpController.text,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are logged in!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP: $e")),
      );
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
    return Scaffold(
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
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  alignment: const AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 0, 0),
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
                                                  onFieldSubmitted: (_) async {
                                                    final phoneNumberVal = _model
                                                        .phoneNumberController
                                                        .text;
                                                    if (phoneNumberVal == null ||
                                                        phoneNumberVal
                                                            .isEmpty ||
                                                        !phoneNumberVal
                                                            .startsWith('+')) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
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
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: Colors
                                                              .transparent,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                    hintText: '(555) 000-000',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .darkGrey,
                                                          fontSize: 16,
                                                          lineHeight: 1.5,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .darkGrey3,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .darkGrey3,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                                    _model.phoneNumberMask
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: Align(
                                          alignment: const AlignmentDirectional(
                                              -1.0, -1.0),
                                          child: Text(
                                            'OTP Code',
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
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20.0, 10.0, 20.0, 0.0),
                                        child: PinCodeTextField(
                                          autoDisposeControllers: false,
                                          appContext: context,
                                          length: 6,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Inter',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              ),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          enableActiveFill: false,
                                          autoFocus: true,
                                          enablePinAutofill: false,
                                          errorTextSpace: 0.0,
                                          showCursor: true,
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          obscureText: false,
                                          hintCharacter: '*',
                                          keyboardType: TextInputType.number,
                                          pinTheme: PinTheme(
                                            fieldHeight: 50.0,
                                            fieldWidth: 50.0,
                                            borderWidth: 1.0,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(8.0),
                                              bottomRight: Radius.circular(8.0),
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0),
                                            ),
                                            shape: PinCodeFieldShape.box,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            inactiveColor:
                                                FlutterFlowTheme.of(context)
                                                    .darkGrey2,
                                            selectedColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            activeFillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            inactiveFillColor:
                                                FlutterFlowTheme.of(context)
                                                    .darkGrey2,
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
                                            _verifyOTP2();
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: _model
                                              .pinCodeControllerValidator
                                              .asValidator(context),
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
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                          child: FFButtonWidget(
                            onPressed: (_model.phoneNumberController.text == '')
                                ? null
                                : () async {
                                    final phoneNumberVal =
                                        _model.phoneNumberController.text;
                                    if (phoneNumberVal.isEmpty ||
                                        !phoneNumberVal.startsWith('+')) {
                                      ScaffoldMessenger.of(context)
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
                            text: 'Continue',
                            options: FFButtonOptions(
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
              )
            ],
            // children: [
            //   TextField(
            //     controller: _phoneController,
            //     decoration: const InputDecoration(hintText: "Phone Number"),
            //     keyboardType: TextInputType.phone,
            //   ),
            //   const SizedBox(height: 8),
            //   ElevatedButton(
            //     onPressed: _sendOTP,
            //     child: const Text("Send OTP"),
            //   ),
            //   TextField(
            //     controller: _otpController,
            //     decoration: const InputDecoration(hintText: "Enter OTP"),
            //     keyboardType: TextInputType.number,
            //   ),
            //   const SizedBox(height: 8),
            //   ElevatedButton(
            //     onPressed: _verifyOTP,
            //     child: const Text("Verify OTP"),
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}
