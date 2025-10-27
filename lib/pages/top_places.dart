import 'package:flutter/material.dart';

class TopPlaces extends StatefulWidget {
  const TopPlaces({super.key});

  @override
  State<TopPlaces> createState() => _TopPlaces();
}

class _TopPlaces extends State<TopPlaces> {
  // List of places using the same image names from your code
  final List<Map<String, String>> places = [
     {'image': "images/Cappadocia_Turkey.jpeg", 'name': "Turkey"},
    {'image': "images/Venice_Italy.jpeg", 'name': "Italy"},
    {'image': "images/London.jpeg", 'name': "London"},
    {'image': "images/Colosseum_Rome.jpeg", 'name': "Rome"},
    {'image': "images/q.jpeg", 'name': "Paris"},
    {'image': "images/u.jpeg", 'name': "Paris"},
    {'image': "images/r.jpeg", 'name': "Paris"},
    {'image': "images/t.jpeg", 'name': "Paris"},
    {'image': "images/u.jpeg", 'name': "Paris"},
    {'image': "images/w.jpeg", 'name': "Paris"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white54),
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 4),
                  Text(
                    "Top Places ",
                    style: TextStyle(
                      color: const Color(0xFF28126A),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Expanded(
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
                    top: 30.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 15, // Space between columns
                      mainAxisSpacing: 20, // Space between rows
                      childAspectRatio: 0.8, // Width/Height ratio
                    ),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return _buildPlaceCard(
                        places[index]['image']!,
                        places[index]['name']!,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(String imagePath, String placeName) {
    return Stack(
      children: [
        Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              height: 250,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                placeName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}