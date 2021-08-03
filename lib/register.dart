import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passswordController = TextEditingController();

    void register() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passswordController.text;
      try{
        final UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);
        await db.collection('users').doc(user.user.uid).set({
          "email": email,
          "username": username
        });
        print("User is Registered!");
      }
      catch (e){
        print("error");
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('REGISTER')),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(child:  Column(
          children: [
          TextFormField(
            controller: usernameController,
          decoration: InputDecoration(
          border: UnderlineInputBorder(),

            labelText: 'Enter your username'
            ),
           ),
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
            ElevatedButton(onPressed: register, child: Text("Register"))
          ],
        ),
        ),
      ),
    );
  }
}
