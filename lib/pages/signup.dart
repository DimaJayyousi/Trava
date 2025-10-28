import 'package:flutter/material.dart';
import 'package:travel_app/pages/login.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(164, 13, 164, 239),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
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
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "SignUp",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

              SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "User name ",
                style: TextStyle(
                  color: const Color.fromARGB(174, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),

            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Email",
                style: TextStyle(
                  color: const Color.fromARGB(174, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),

            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Password",
                style: TextStyle(
                  color: const Color.fromARGB(174, 255, 255, 255),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(197, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),

            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    " Forget your Password ? ",
                    style: TextStyle(
                      color: const Color.fromARGB(174, 255, 255, 255),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),

            Container(
              height: 60,
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(69, 1, 25, 66),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  " SignUp",
                  style: TextStyle(
                    color: const Color.fromARGB(226, 255, 255, 255),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 15.0),
            Center(
              child: Text(
                " Already have an account?",
                style: TextStyle(
                  color: const Color.fromARGB(174, 255, 255, 255),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            GestureDetector(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()))
              },
              child: Center(
                child: Text(
                  "LogIn",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 1, 24, 65),
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
