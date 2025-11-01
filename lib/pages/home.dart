import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/add_page.dart';
import 'package:travel_app/pages/comment.dart';
import 'package:travel_app/pages/top_places.dart';
import 'package:travel_app/services/database.dart';
import 'package:travel_app/services/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, image, id;
  Stream? postStream;

  getthesharedpref() async {
    name = await SharedPreferencesHelper().getUserDisplayName();
    image = await SharedPreferencesHelper().getUserImage();
    id = await SharedPreferencesHelper().getUserId();
    setState(() {});
  }

  getontheload() async {
    await getthesharedpref();
    postStream = DatabaseMethods().getposts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allPosts() {
    return StreamBuilder(
      stream: postStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No posts yet"));
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            // ← FIXED LOGIC
            List likes = (ds.data() as Map<String, dynamic>)["Like"] ?? [];
            bool isLiked = likes.contains(id);

            return Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // USER INFO
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                ds["userimage"],
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "images/profile.jpeg",
                                    height: 40,
                                    width: 40,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              ds["Username"] ?? "Unknown User",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15.0),

                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          child:
                              ds["postImage"] != null &&
                                  ds["postImage"].toString().isNotEmpty
                              ? Image.network(
                                  ds["postImage"],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "images/Place_one.jpeg",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "images/Place_one.jpeg",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),

                      SizedBox(height: 10.0),

                      // LOCATION
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.deepPurple,
                            size: 20.0,
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: Text(
                              ds["PlaceName"] ?? "Unknown Place",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.0),

                      // CAPTION
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          ds["Caption"] ?? "No caption",
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ),

                      SizedBox(height: 15.0),

                      // LIKE + COMMENT
                      Row(
                        children: [
                          isLiked
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                  size: 24.0,
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    await DatabaseMethods().addLike(ds.id, id!);
                                  },
                                  child: Icon(
                                    Icons.favorite_outline,
                                    size: 24.0,
                                  ),
                                ),
                          SizedBox(width: 8.0),
                          Text("Like", style: TextStyle(fontSize: 16.0)),

                          SizedBox(width: 20.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentPage(
                                    userimage:
                                        image ??
                                        "default_image_path", // Provide default value
                                    username:
                                        name ??
                                        "Unknown User", // Provide default value
                                    postid: ds.id,
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.comment_outlined, size: 24.0),
                          ),
                          SizedBox(width: 8.0),
                          Text("Comment", style: TextStyle(fontSize: 16.0)),
                        ],
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  "images/header.jpeg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, right: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TopPlaces()),
                        ),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              "images/pin.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPage()),
                        ),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.deepPurple,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "images/profile.jpeg",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 180.0, left: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trava",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Travel Community App",
                        style: TextStyle(
                          color: const Color(0xDAFFFFFF),
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            allPosts(),
          ],
        ),
      ),
    );
  }
}
