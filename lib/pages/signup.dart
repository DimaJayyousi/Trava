import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/login.dart';
import 'package:random_string/random_string.dart'; // ✅ for randomAlphaNumeric

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
                email: mailcontroller.text, password: passwordcontroller.text);
        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Image": "",
          "Id": id
        };

        // 🔹 You can print or save this to Firestore if needed
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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
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
      body: SingleChildScrollView( // ✅ prevents overflow when keyboard shows
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(70),
                bottomLeft: Radius.circular(70),
              ), // ✅ fixed BorderRadiusGeometry.only
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
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: namecontroller, // ✅ linked controller
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
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: mailcontroller, // ✅ linked controller
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
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: passwordcontroller, // ✅ linked controller
                obscureText: true,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text(
                    " Forget your Password ? ",
                    style: TextStyle(
                      color: Color.fromARGB(174, 255, 255, 255),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),

            // 🔘 SIGNUP BUTTON
            GestureDetector(
              onTap: registration, // ✅ now calls registration
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
                    " SignUp",
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
                " Already have an account?",
                style: TextStyle(
                  color: Color.fromARGB(174, 255, 255, 255),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                ),
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
