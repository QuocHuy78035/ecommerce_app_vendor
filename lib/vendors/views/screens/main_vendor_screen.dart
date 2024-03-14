import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainVendorScreen extends StatelessWidget {
  const MainVendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("123"),
          ElevatedButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            child: Text("Log out"),
          ),
        ],
      )
    );
  }
}
