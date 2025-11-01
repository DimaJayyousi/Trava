import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Pages/home.dart';
import 'package:travel_app/pages/signup.dart';
import 'package:travel_app/services/database.dart';
import 'package:travel_app/services/shared_pref.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "", myid = "", myname = "", myimage = "";
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserEmail(email);

      myname = "${querySnapshot.docs[0]["Name"]}";
      myid = "${querySnapshot.docs[0]["Id"]}";
      myimage = "${querySnapshot.docs[0]["Image"]}";

      await SharedPreferencesHelper().saveUserImage(myimage);
      await SharedPreferencesHelper().saveUserDisplayName(myname);
      await SharedPreferencesHelper().saveUserId(myid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No user found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Wrong password provided by user",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(164, 13, 164, 239),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(70),
                bottomLeft: Radius.circular(70),
              ),
              child: Image.asset(
                'images/login.jpeg',
                height: 370,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "LogIn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15.0),
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
                  color: const Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                cursorColor: Colors.black,

                controller: mailController,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
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
                  color: const Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                cursorColor: Colors.black,

                controller: passwordController,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text(
                    "Forget your Password?",
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
            GestureDetector(
              onTap: () {
                if (mailController.text != "" &&
                    passwordController.text != "") {
                  setState(() {
                    email = mailController.text;
                    password = passwordController.text;
                  });
                  userLogin();
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
                    "LogIn",
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
                "Don't have an account?",
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
                  MaterialPageRoute(builder: (context) => const Signup()),
                );
              },
              child: const Center(
                child: Text(
                  "Sign up",
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
