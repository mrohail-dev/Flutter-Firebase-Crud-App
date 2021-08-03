import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/editdialoguebox.dart';
import 'package:flutter/material.dart';
class Post extends StatelessWidget {

  final Map data;
  Post(this.data);
  @override
  Widget build(BuildContext context) {
    void deletepost() async {
      try{
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("posts").doc(data["id"]).delete();
      }
      catch(e){
        print("err");
      }
    }
    void editpost(){
      showDialog(context: context, builder: (BuildContext context){
        return EditDialogueBox(data:data);
      });
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightGreen,width: 2)
      ),

      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),

      child: Column(
        children: [
          Image.network(data["url"],width: 100,height: 100,),
          Text(data["title"]),
          Text(data["description"],textAlign: TextAlign.center,),
          ElevatedButton(onPressed: deletepost, child: Text("Delete")),
          ElevatedButton(onPressed: editpost, child: Text("Update")),
        ],
      ),
    );
  }
}
