import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataReference {

  userData(){
    CollectionReference user = FirebaseFirestore.instance.collection("users");
    return user;
  }
}