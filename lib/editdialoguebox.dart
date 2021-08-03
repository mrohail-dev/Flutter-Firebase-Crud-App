import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditDialogueBox extends StatefulWidget {
  final Map data;
  EditDialogueBox({required this.data});

  @override
  _EditDialogueBoxState createState() => _EditDialogueBoxState();
}

class _EditDialogueBoxState extends State<EditDialogueBox> {
  late String imagePath;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState(){
    super.initState();
    titleController.text= widget.data["title"];
    descriptionController.text= widget.data["description"];
  }
  Widget build(BuildContext context) {

    void pickImage()async{
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final image = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        imagePath=image.path;
      });
    }
    void done()async{
      try{
        String imageName = path.basename(imagePath);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName'); // String interpolation

        File file=File(imagePath);
        await ref.putFile(file);
        String downloadURL = await ref.getDownloadURL();
        FirebaseFirestore db = FirebaseFirestore.instance;

        Map<String,dynamic> newPost = {
          "title":titleController.text,
          "description":descriptionController.text,
          "url":downloadURL
        };
        await db.collection("posts").doc(widget.data["id"]).set(newPost);
        Navigator.of(context).pop();
      }
      catch (e){
        print("err");
      }
    }
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
          ElevatedButton(onPressed: pickImage, child: Text("Pick Image")),
          ElevatedButton(onPressed: done, child: Text("Done")),
        ],
        ),
      ),
    );
  }
}
