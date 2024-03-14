
import 'package:ecommerce_vendor/vendors/views/auth/widgets/vendor_register_account_screen.dart';
import 'package:ecommerce_vendor/vendors/views/auth/widgets/vendor_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/landing_screen.dart';

class VendorAuthScreen  extends StatelessWidget {
  const VendorAuthScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const VendorSignIn();
          }
          return const LandingScreen();
        },
      ),
    );
  }
}
