import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dogfooding/screens/login_screen.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  String? _verificationId;

  @override
  void initState() {
    super.initState();
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
            ],
          ),
        ),
      ),
    );
  }
}
