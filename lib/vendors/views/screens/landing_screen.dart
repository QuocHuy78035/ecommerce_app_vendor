import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_vendor/models/vendor_model.dart';
import 'package:ecommerce_vendor/vendors/views/screens/main_vendor_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/widgets/vendor_registration_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot?>(
        future: FirebaseAuth.instance.authStateChanges().first.then(
          (user) {
            if (user == null) {
              throw Exception("User is not authenticated");
            } else {
              return FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(user.uid)
                  .get();
            }
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == null) {
            return const Text("Vendor data not found");
          } else {
            VendorUserModel vendorModel = VendorUserModel.fromJson(
                snapshot.data?.data() as Map<String, dynamic>);
            if (!snapshot.data!.exists) {
              return const VendorRegistrationScreen(
                email: "",
              );
            }
            if (vendorModel.approved == true) {
              return const MainVendorScreen();
            } else {
              return Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        vendorModel.storeImage.toString(),
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      vendorModel.businessName.toString(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Your application has been sent to admin\n Admin will get back to you soon",
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text("Log out"),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
