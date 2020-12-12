import 'package:blogger/create.dart';
import 'package:blogger/description.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QuerySnapshot albums;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Widget pages() {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore.collection("albums").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text("No albums found");
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return BlogsTile(
                      title: snapshot.data.docs[index].data()['title'],
                      description: snapshot.data.docs[index].data()['desc'],
                      authorName:
                          snapshot.data.docs[index].data()['authorName'],
                      imgeUrl: snapshot.data.docs[index].data()['imgUrl'],
                    );
                  });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
      ),
      body: pages(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreatePage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  final String title, description, authorName, imgeUrl;

  BlogsTile({this.title, this.description, this.authorName, this.imgeUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 180,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Description(description, imgeUrl, title, authorName)));
        },
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: imgeUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      authorName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
