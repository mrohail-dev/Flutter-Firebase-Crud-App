import 'dart:io';
import 'package:crud_app/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String imagePath;
  final Stream<QuerySnapshot> postStream = FirebaseFirestore.instance.collection('posts').snapshots();

  void pickImage()async{
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      imagePath=image.path;
    });
  }

  void submitpost() async {
    try{
      String title=titleController.text;
      String description=descriptionController.text;
      String imageName = path.basename(imagePath);
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('/$imageName'); // String interpolation
      File file=File(imagePath);
      await ref.putFile(file);
      String downloadURL = await ref.getDownloadURL();
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('posts')
          .add({
        "title": title,
        "description": description,
        "url": downloadURL
      });
      print("Post upload sucessfully!");
      titleController.clear();
      descriptionController.clear();
    }
    catch(e){
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Welcome To Home')),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),

                    labelText: 'Enter your Title'
                ),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),

                    labelText: 'Enter your Description'
                ),
              ),
              ElevatedButton(onPressed: pickImage, child: Text("Pick an Image")),
              ElevatedButton(onPressed: submitpost, child: Text("Submit a Post")),
              Expanded(
                child: Container(
                  child:  StreamBuilder<QuerySnapshot>(
                    stream: postStream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return new ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map data = document.data();
                          String id=document.id;
                          data["id"]=id;
                          return Post(data);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}