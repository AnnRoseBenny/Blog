import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String description, imgeUrl, title, author;
  Description(this.description, this.imgeUrl, this.title, this.author);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: 30),
        Container(
          height: 200,
          padding: EdgeInsets.all(10),
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
                    ]),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Written by ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Text(author,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400))
            ]),
        SizedBox(height: 30),
        Container(
            padding: EdgeInsets.all(10),
            child: Text(
              description,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
            ))
      ]),
    );
  }
}
