import 'dart:io';
import 'package:blogger/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  File imageselected;
  final picker = ImagePicker();
  var downloadUrl;

  TextEditingController authorTec = new TextEditingController();
  TextEditingController titleTec = new TextEditingController();
  TextEditingController descTec = new TextEditingController();

  uploadBlog() async {
    if (imageselected != null) {
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref('/images');
      var uploadTask = reference.putFile(imageselected);
      downloadUrl = await (await uploadTask).ref.getDownloadURL();

      FirebaseFirestore.instance.collection("albums").add({
        "authorName": authorTec.text,
        "desc": descTec.text,
        "title": titleTec.text,
        "imgUrl": downloadUrl
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageselected = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Page"),
        actions: [
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              imageselected != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          imageselected,
                          fit: BoxFit.cover,
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                      ),
                    ),
              TextField(
                controller: authorTec,
                decoration: InputDecoration(hintText: "Author Name"),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: titleTec,
                decoration: InputDecoration(hintText: "Title"),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: descTec,
                decoration: InputDecoration(hintText: "Description"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
