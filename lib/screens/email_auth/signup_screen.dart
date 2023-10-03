import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController cpasscontroller = TextEditingController();

  void createAccount() async {
    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();
    String cpassword = cpasscontroller.text.trim();

    if (email == "" || password == "" || cpassword == "") {
      const snackbar = SnackBar(
        content: Text("Please fill in the required fields"),
        backgroundColor: Colors.teal,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else if (password != cpassword) {
      const snackbar = SnackBar(
        content: Text("Passwords do not match!"),
        backgroundColor: Colors.teal,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          var snackbar =
              const SnackBar(content: Text("Your account has been created!"));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        var snackbar = SnackBar(content: Text(e.code));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("SignUp"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: emailcontroller,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passcontroller,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: cpasscontroller,
              decoration: const InputDecoration(hintText: "Confirm Password"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  createAccount();
                },
                child: const Text("Create Account")),
          ],
        ),
      ),
    );
  }
}
