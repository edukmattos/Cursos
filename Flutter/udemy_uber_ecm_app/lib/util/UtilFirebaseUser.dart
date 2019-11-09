import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_uber_app/model/User.dart';

class UtilFirebaseUser {
  static Future<FirebaseUser> getUserLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.currentUser();
  }

  static Future<User> getUserLoggedData() async {
    FirebaseUser firebaseUser = await getUserLogged();
    String userId = firebaseUser.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("users").document((userId)).get();

    Map<String, dynamic> data = snapshot.data;
    String userType = data["type"];
    String userEmail = data["email"];
    String userName = data["name"];

    User user = User();
    user.userId = userId;
    user.userType = userType;
    user.userEmail = userEmail;
    user.userName = userName;

    return user;
  }
}