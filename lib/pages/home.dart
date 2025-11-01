import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/add_page.dart';
import 'package:travel_app/pages/top_places.dart';
import 'package:travel_app/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? postStream;

  getontheload() {
    postStream = DatabaseMethods().getposts();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
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
          physics: NeverScrollableScrollPhysics(), // Important: disable inner scroll
          shrinkWrap: true, // Important: make ListView take only needed space
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
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
                      // User info row
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                ds["userimage"],
                                height: 40, // Reduced size
                                width: 40, // Reduced size
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "images/profile.jpeg",
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              ds["Username"] ?? "Unknown User",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0, // Slightly smaller
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      
                      // Post image with constrained size
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: 200, // Fixed height for consistency
                          width: double.infinity, // Take full width
                          child: ds["postImage"] != null &&
                                  ds["postImage"].toString().isNotEmpty
                              ? Image.network(
                                  ds["postImage"],
                                  fit: BoxFit.cover, // Cover the container
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "images/Place_one.jpeg", // Changed to Place_one.jpeg
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "images/Place_one.jpeg", // Changed to Place_one.jpeg
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      
                      // Location
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
                      
                      // Caption
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          ds["Caption"] ?? "No caption",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      
                      // Like and Comment buttons
                      Row(
                        children: [
                          Icon(
                            Icons.favorite_outlined,
                            color: Colors.black54,
                            size: 24.0, // Slightly smaller
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Like",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0, // Slightly smaller
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Icon(
                            Icons.comment_outlined,
                            color: Colors.black54,
                            size: 24.0, // Slightly smaller
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Comment",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0, // Slightly smaller
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
      body: SingleChildScrollView( // Make entire page scrollable
        child: Container(
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
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TopPlaces(),
                              ),
                            ),
                          },
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
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddPage()),
                            ),
                          },
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
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: MediaQuery.of(context).size.height / 2.7,
                    ),
                    child: Material(
                      elevation: 7.0,
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(108, 255, 255, 255),
                          border: Border.all(width: 1.5),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search your destination",
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              allPosts(),
            ],
          ),
        ),
      ),
    );
  }
}