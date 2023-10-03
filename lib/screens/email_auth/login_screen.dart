import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/screens/email_auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  void login() async {
    final currentContext = context;
    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();

    if (email == "" || password == "") {
      var snackbar =
          const SnackBar(content: Text("Please fill in the required fields!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, (route) => route.isFirst);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } on FirebaseAuthException catch (e) {
        var snackbar = SnackBar(content: Text(e.code));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(currentContext).showSnackBar(snackbar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Login"),
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  login();
                },
                child: const Text("Login")),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
              child: const Text(
                "Create an Account",
                style: TextStyle(color: Colors.teal),
              ),
            )
          ],
        ),
      ),
    );
  }
}
