import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/email_auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController namecontroller = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void saveUser() async {
    String name = namecontroller.text.trim();

    namecontroller.clear();

    if (name != "") {
      await firestore.collection("Users").add({"name": name});
    } else {
      var snackbar = SnackBar(content: Text("Please fill all the fields!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                logout();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: namecontroller,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.teal,
              onPressed: () {
                saveUser();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: firestore.collection("Users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            Map userMap = snapshot.data!.docs[index].data();
                            return ListTile(
                              title: Text(userMap["name"]),
                              trailing: IconButton(
                                  onPressed: () {
                                    snapshot.data!.docs[index].reference
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete)),
                            );
                          }),
                    );
                  } else {
                    const Text("No Data!");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const Text("hehe");
              },
            ),
          ],
        ),
      ),
    );
  }
}
