import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD0RRzcBJ9Q8MhWQ-XkgeOFH9IuoZquotM",
            authDomain: "mortgage-chat-40152.firebaseapp.com",
            projectId: "mortgage-chat-40152",
            storageBucket: "mortgage-chat-40152.appspot.com",
            messagingSenderId: "1006383313110",
            appId: "1:1006383313110:web:f77f14acf4409217239977"));
  } else {
    await Firebase.initializeApp();
  }
}
