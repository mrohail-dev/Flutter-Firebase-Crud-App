import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passswordController = TextEditingController();

    void login() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String email = emailController.text;
      final String password = passswordController.text;
      try{
        final UserCredential user = await auth.signInWithEmailAndPassword(email: email, password: password);
        final DocumentSnapshot snapshot = await db.collection("users").doc(user.user.uid).get();
        final data = snapshot.data();
        Navigator.of(context).pushNamed("/home");
      }
      catch (e){
        print("error");

      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(child:  Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your email'
              ),
            ),
            TextFormField(
              controller: passswordController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your password'
              ),
            ),
            ElevatedButton(onPressed: login, child: Text("Login"))
          ],
        ),
        ),
      ),
    );
  }
}
