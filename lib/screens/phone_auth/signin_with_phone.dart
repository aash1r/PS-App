// import 'dart:html';
// import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/phone_auth/verify_otp.dart';

class SigninWithPhone extends StatefulWidget {
  const SigninWithPhone({
    super.key,
  });

  @override
  State<SigninWithPhone> createState() => _SigninWithPhoneState();
}

class _SigninWithPhoneState extends State<SigninWithPhone> {
  TextEditingController phonecontroller = TextEditingController();

  void signIn() async {
    String phone = "+92${phonecontroller.text.trim()}";
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendtoken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyOtp(verificationId: verificationId)));
        },
        verificationCompleted: (credential) {},
        verificationFailed: (e) {
          var snackbar = SnackBar(content: Text(e.code));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Sign In with Phone")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: phonecontroller,
              decoration: const InputDecoration(hintText: "Phone Number"),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.teal,
              onPressed: () {
                signIn();
              },
              child: const Text(
                "Sign In with Phone",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
