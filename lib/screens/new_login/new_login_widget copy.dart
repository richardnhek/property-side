import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_dogfooding/backend/backend.dart';
import 'package:flutter_dogfooding/screens/home_screen.dart';
import 'package:flutter_dogfooding/screens/login_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:easy_debounce/easy_debounce.dart';

// import '../../auth/firebase_auth/auth_util.dart';
// import '../../flutterflow/flutter_flow_model.dart';
// import '../../flutterflow/flutter_flow_widgets.dart';
// import '../../flutterflow/nav/serialization_util.dart';
// import 'new_login_model.dart';

class NewLoginScreenCopy extends StatefulWidget {
  const NewLoginScreenCopy({super.key});

  @override
  State<NewLoginScreenCopy> createState() => _NewLoginScreenCopyState();
}

class _NewLoginScreenCopyState extends State<NewLoginScreenCopy> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  // late NewLoginModel _model;

  String? _verificationId;

  @override
  void initState() {
    super.initState();
    // _model = createModel(context, () => NewLoginModel());

    // _model.phoneNumberController ??= TextEditingController();
    // _model.phoneNumberFocusNode ??= FocusNode();

    // authManager.handlePhoneAuthStateChanges(context);
    // authManager.handlePhoneAuthStateChanges(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
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
      appBar: AppBar(title: const Text("Phone Auth")),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 50),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            // children: [
            //   Align(
            //     alignment: const AlignmentDirectional(0.0, 0.0),
            //     child: Padding(
            //       padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            //       child: Column(
            //         mainAxisSize: MainAxisSize.max,
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Welcome Back',
            //             style: GoogleFonts.inter(
            //               fontSize: 23,
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //           Padding(
            //             padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
            //             child: Text(
            //               'Please enter your phone number to verify and join the workspace.',
            //               style: GoogleFonts.inter(
            //                 color: Colors.black54,
            //                 fontSize: 15,
            //               ),
            //             ),
            //           ),
            //           Padding(
            //             padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
            //             child: Column(
            //               mainAxisSize: MainAxisSize.max,
            //               children: [
            //                 Align(
            //                   alignment: const AlignmentDirectional(-1.0, -1.0),
            //                   child: Text(
            //                     'Phone number',
            //                     style: GoogleFonts.inter(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding:
            //                       EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            //                   child: Row(
            //                     mainAxisSize: MainAxisSize.max,
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Expanded(
            //                         child: Align(
            //                           alignment:
            //                               const AlignmentDirectional(0.0, 0.0),
            //                           child: TextFormField(
            //                             controller:
            //                                 _model.phoneNumberController,
            //                             onChanged: (_) => EasyDebounce.debounce(
            //                               '_model.phoneNumberController',
            //                               const Duration(milliseconds: 100),
            //                               () => setState(() {}),
            //                             ),
            //                             onFieldSubmitted: (_) async {
            //                               final phoneNumberVal = _model
            //                                   .phoneNumberController?.text;
            //                               if (phoneNumberVal == null ||
            //                                   phoneNumberVal.isEmpty ||
            //                                   !phoneNumberVal.startsWith('+')) {
            //                                 ScaffoldMessenger.of(context)
            //                                     .showSnackBar(
            //                                   SnackBar(
            //                                     content: Text(
            //                                         'Phone Number is required and has to start with +.'),
            //                                   ),
            //                                 );
            //                                 return;
            //                               }
            //                               await authManager.beginPhoneAuth(
            //                                 context: context,
            //                                 phoneNumber: phoneNumberVal,
            //                                 onCodeSent: (context) async {
            //                                   context.goNamedAuth(
            //                                     'VerificationPage',
            //                                     context.mounted,
            //                                     queryParameters: {
            //                                       'phoneNumber': serializeParam(
            //                                         _model.phoneNumberController
            //                                             .text,
            //                                         ParamType.String,
            //                                       ),
            //                                     }.withoutNulls,
            //                                     ignoreRedirect: true,
            //                                   );
            //                                 },
            //                               );
            //                             },
            //                             obscureText: false,
            //                             decoration: InputDecoration(
            //                               labelStyle: GoogleFonts.inter(
            //                                 color: Colors.transparent,
            //                                 fontSize: 16,
            //                                 fontWeight: FontWeight.w600,
            //                               ),
            //                               hintText: '(555) 000-000',
            //                               hintStyle: GoogleFonts.inter(
            //                                 color: Colors.black54,
            //                                 fontSize: 16,
            //                               ),
            //                               enabledBorder: OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Colors.black87,
            //                                   width: 1,
            //                                 ),
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                               ),
            //                               focusedBorder: OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Colors.black87,
            //                                   width: 1,
            //                                 ),
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                               ),
            //                               errorBorder: OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0x00000000),
            //                                   width: 1,
            //                                 ),
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                               ),
            //                               focusedErrorBorder:
            //                                   OutlineInputBorder(
            //                                 borderSide: BorderSide(
            //                                   color: Color(0x00000000),
            //                                   width: 1,
            //                                 ),
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                               ),
            //                               filled: true,
            //                               fillColor: Colors.black,
            //                               contentPadding:
            //                                   const EdgeInsets.all(10.0),
            //                             ),
            //                             style: GoogleFonts.inter(
            //                               color: Colors.white,
            //                               fontSize: 16,
            //                             ),
            //                             maxLines: null,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            //   Padding(
            //     padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            //     child: FFButtonWidget(
            //       onPressed: (_model.phoneNumberController?.text == '')
            //           ? null
            //           : () async {
            //               _model.existingUser = await queryUsersRecordOnce(
            //                 queryBuilder: (usersRecord) => usersRecord.where(
            //                   'phone_number',
            //                   isEqualTo: functions.getFormattedPhoneNo(
            //                       _model.phoneNumberController.text),
            //                 ),
            //                 singleRecord: true,
            //               ).then((s) => s.firstOrNull);
            //               if ((_model.existingUser != null) == true) {
            //                 final phoneNumberVal =
            //                     _model.phoneNumberController.text;
            //                 if (phoneNumberVal.isEmpty ||
            //                     !phoneNumberVal.startsWith('+')) {
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     const SnackBar(
            //                       content: Text(
            //                           'Phone Number is required and has to start with +.'),
            //                     ),
            //                   );
            //                   return;
            //                 }
            //                 await authManager.beginPhoneAuth(
            //                   context: context,
            //                   phoneNumber: phoneNumberVal,
            //                   onCodeSent: (context) async {
            //                     context.goNamedAuth(
            //                       'VerificationPage',
            //                       context.mounted,
            //                       queryParameters: {
            //                         'phoneNumber': serializeParam(
            //                           _model.phoneNumberController.text,
            //                           ParamType.String,
            //                         ),
            //                       }.withoutNulls,
            //                       ignoreRedirect: true,
            //                     );
            //                   },
            //                 );
            //               } else {
            //                 ScaffoldMessenger.of(context).showSnackBar(
            //                   SnackBar(
            //                     content: Text(
            //                       'User does not exist!',
            //                       style: GoogleFonts.getFont(
            //                         'Inter',
            //                         color: Colors.white,
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 15.0,
            //                       ),
            //                     ),
            //                     duration: const Duration(milliseconds: 2000),
            //                     backgroundColor: const Color(0x7F000000),
            //                   ),
            //                 );
            //               }

            //               setState(() {});
            //             },
            //       text: 'Continue',
            //       options: FFButtonOptions(
            //         width: double.infinity,
            //         height: 50,
            //         padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            //         iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            //         color: Colors.redAccent,
            //         textStyle: GoogleFonts.inter(
            //           color: Colors.white,
            //         ),
            //         elevation: 0,
            //         borderSide: BorderSide(
            //           color: Colors.transparent,
            //           width: 0,
            //         ),
            //         borderRadius: BorderRadius.circular(8),
            //         disabledColor: Colors.black54,
            //       ),
            //     ),
            //   ),
            // ],
            children: [
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(hintText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _sendOTP,
                child: const Text("Send OTP"),
              ),
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(hintText: "Enter OTP"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text("Verify OTP"),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const LoginScreen()),
              //     );
              //   },
              //   child: const Text("Verify OTP"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
