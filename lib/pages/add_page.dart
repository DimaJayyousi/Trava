import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'dart:io';
import 'package:travel_app/pages/home.dart';
import 'package:travel_app/services/shared_pref.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? name, image;
  
  getthesharedpref() async {
    name = await SharedPreferencesHelper().getUserDisplayName();
    image = await SharedPreferencesHelper().getUserImage();
    setState(() {});
  }
  
  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  TextEditingController placeNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController captionNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          ),
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
                      SizedBox(width: MediaQuery.of(context).size.width / 4.5),
                      const Text(
                        "Add post",
                        style: TextStyle(
                          color: Color(0xFF28126A),
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3.0),
                Material(
                  elevation: 3.0,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 30.0,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section - optional with default
                        GestureDetector(
                          onTap: getImage,
                          child: Center(
                            child: selectedImage != null 
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      selectedImage!,
                                      height: 180,
                                      width: 180, 
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 2.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "images/Place_one.jpeg",
                                        height: 180,
                                        width: 180, 
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Center(
                          child: Text(
                            selectedImage != null ? "Custom image selected" : "Default image (tap to change)",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Place Name ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 178, 152, 249),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: placeNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter place name ",
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "City Name",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 178, 152, 249),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: cityNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter city name ",
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Caption ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.only(left: 20.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 178, 152, 249),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: captionNameController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter caption ",
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),

                        GestureDetector(
                          onTap: () async {
                            if (placeNameController.text != "" && 
                                cityNameController.text != "" && 
                                captionNameController.text != "") {
                              
                              String addId = randomAlpha(10);
                              String defaultUserImage = "images/profile.jpeg";
                              String defaultPostImage = "images/Place_one.jpeg";
                              
                              // Determine which image to use
                              String postImageToUse;
                              if (selectedImage != null) {
                                // If user selected an image, we need to upload it to storage
                                // For now, we'll store a placeholder since we don't have storage setup
                                postImageToUse = "custom_image"; // You can change this later
                                // Note: You'll need Firebase Storage to actually upload the image
                              } else {
                                // Use default image
                                postImageToUse = defaultPostImage;
                              }
                              
                              Map<String, dynamic> addPost = {
                                "PlaceName": placeNameController.text,
                                "CityName": cityNameController.text,
                                "Caption": captionNameController.text,
                                "Username": name ?? "Anonymous",
                                "userimage": image ?? defaultUserImage,
                                "postImage": postImageToUse,
                                "createdAt": FieldValue.serverTimestamp(),
                                "hasCustomImage": selectedImage != null, // Flag to indicate custom image
                                "Like": [],
                              };
                              
                              try {
                                await FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(addId)
                                    .set(addPost);
                                    
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Posted successfully",
                                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                                    ),
                                  )
                                );
                                
                                // Clear form and navigate back
                                placeNameController.clear();
                                cityNameController.clear();
                                captionNameController.clear();
                                setState(() {
                                  selectedImage = null;
                                });
                                
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                                
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Error posting: $e",
                                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                                    ),
                                  )
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.orange,
                                  content: Text(
                                    "Please fill all text fields",
                                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                                  ),
                                )
                              );
                            }
                          },
                          child: Center(
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Post",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}