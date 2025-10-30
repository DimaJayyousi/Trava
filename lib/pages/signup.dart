import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Pages/home.dart';
import 'package:travel_app/pages/login.dart';
import 'package:random_string/random_string.dart';
import 'package:travel_app/services/database.dart';
import 'package:travel_app/services/shared_pref.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  registration() async {
    if (passwordcontroller.text.isNotEmpty &&
        namecontroller.text.isNotEmpty &&
        mailcontroller.text.isNotEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: mailcontroller.text,
              password: passwordcontroller.text,
            );

        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Image": "",
          "Id": id,
        };

        // Save user data to SharedPreferences
        await SharedPreferencesHelper().saveUserDisplayName(namecontroller.text);
        await SharedPreferencesHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferencesHelper().saveUserId(id);

        // Add user to database
        await DatabaseMethods().addUserDetaols(userInfoMap, id);

        print("✅ User registered: $userInfoMap");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Signup Successful!",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already Exists",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      } catch (e) {
        // Handle other errors (database, shared preferences, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registration Failed ❌",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
        print("Registration error: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Please fill all the fields",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(164, 13, 164, 239),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(70),
                bottomLeft: Radius.circular(70),
              ),
              child: Image.asset(
                'images/Signup.jpeg',
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "SignUp",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15.0),

            // 🔹 USERNAME FIELD
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "User name ",
                style: TextStyle(
                  color: Color.fromARGB(174, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.only(left: 30.0),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(197, 255, 255, 255)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: namecontroller,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(height: 15.0),

            // 🔹 EMAIL FIELD
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Email",
                style: TextStyle(
                  color: Color.fromARGB(174, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.only(left: 30.0),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(197, 255, 255, 255)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: mailcontroller,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(height: 15.0),

            // 🔹 PASSWORD FIELD
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Password",
                style: TextStyle(
                  color: Color.fromARGB(174, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.only(left: 30.0),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(197, 255, 255, 255)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: passwordcontroller,
                obscureText: true,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(height: 15.0),

            // 🔘 SIGNUP BUTTON
            GestureDetector(
              onTap: () {
                if (passwordcontroller.text.isNotEmpty && 
                    namecontroller.text.isNotEmpty && 
                    mailcontroller.text.isNotEmpty) {
                  setState(() {
                    name = namecontroller.text;
                    password = passwordcontroller.text;
                    email = mailcontroller.text;
                  });
                  registration();
                }
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(69, 1, 25, 66),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "SignUp",
                    style: TextStyle(
                      color: Color.fromARGB(226, 255, 255, 255),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15.0),
            const Center(
              child: Text(
                "Already have an account?",
                style: TextStyle(
                  color: Color.fromARGB(174, 255, 255, 255),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Center(
                child: Text(
                  "LogIn",
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 24, 65),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}