import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetaols(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future addPost(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Post")
        .doc(id)
        .set(userInfoMap);
  }

  Stream<QuerySnapshot> getposts() {
    return FirebaseFirestore.instance.collection("posts").snapshots();
  }

  Future addLike(String id , String userid)async{
    return await FirebaseFirestore.instance.collection("posts").doc(id).update({'Like': FieldValue.arrayUnion([userid])});
  }

 static Future addComment(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("posts")
        .doc(id).collection("comment")
        .add(userInfoMap);
  }

    Future<Stream<QuerySnapshot>> getcomments(String id) async{
    return FirebaseFirestore.instance.collection("posts").doc(id).collection("comment").snapshots();
  }

}
