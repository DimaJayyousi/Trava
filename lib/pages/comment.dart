import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Pages/home.dart';
import 'package:travel_app/services/database.dart';

class CommentPage extends StatefulWidget {
  String username, userimage, postid;

  CommentPage({
    required this.userimage,
    required this.username,
    required this.postid,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentcontroller = TextEditingController();
  Stream? commentstream;
  DatabaseMethods databaseMethods = DatabaseMethods();

  getontheload() async {
    commentstream = await databaseMethods.getcomments(widget.postid);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allcomments() {
    return StreamBuilder(
      stream: commentstream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No comments yet"));
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(bottom:20.0),
              child: Material(
                elevation: 3.0,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 10.0,
                    bottom: 30.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  ds["userimage"] ?? "images/profile.jpeg",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "images/profile.jpeg",
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ds["username"]?.isNotEmpty == true 
                                        ? ds["username"] 
                                        : "Anonymous",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 1.5,
                                    child: Text(
                                      ds["comment"] ?? "",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          71,
                                          1,
                                          82,
                                        ),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white54),
                        child: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 7),
                  const Center(
                    child: Text(
                      "Add Comment",
                      style: TextStyle(
                        color: Color(0xFF28126A),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            Expanded(
              child: Container(
                child: allcomments(),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black45, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: commentcontroller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: " Write a comment...",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () async {
                      if (commentcontroller.text.isNotEmpty) {
                        Map<String, dynamic> addComment = {
                          "userimage": widget.userimage,
                          "username": widget.username,
                          "comment": commentcontroller.text,
                          "timestamp": FieldValue.serverTimestamp(),
                        };
                        await DatabaseMethods.addComment(
                            addComment, widget.postid);
                        commentcontroller.clear();
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Color.fromARGB(247, 104, 58, 183),
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}