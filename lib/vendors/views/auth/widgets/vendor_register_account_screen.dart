import 'package:ecommerce_vendor/utils/show_snackbar.dart';
import 'package:ecommerce_vendor/vendors/views/auth/widgets/textfield_custom.dart';
import 'package:ecommerce_vendor/vendors/views/auth/widgets/vendor_registration_screen.dart';
import 'package:ecommerce_vendor/vendors/views/auth/widgets/vendor_sign_in.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/vendor_controller.dart';

class VendorRegisterAccount extends StatefulWidget {
  const VendorRegisterAccount({super.key});

  @override
  State<VendorRegisterAccount> createState() => _VendorRegisterAccountState();
}

class _VendorRegisterAccountState extends State<VendorRegisterAccount> {
  @override
  Widget build(BuildContext context) {
    final VendorController controller = VendorController();
    String email = '';
    String pass = '';
    final GlobalKey<FormState> keySignUp = GlobalKey<FormState>();

    signUpVendor(String email, String pass) async {
      String res = await controller.vendorSignUp(email, pass);
      if (res == "Register Success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VendorRegistrationScreen(email: email,),
          ),
        );
        return showSnackBar(context, "Register account Success");
      } else {
        return showSnackBar(context, "Register account Fail");

      }
      // if (keySignUp.currentState!.validate()) {
      //   String res = await controller.vendorSignUp(email, pass);
      //   if (res == "Register Success") {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => VendorRegistrationScreen(email: email,),
      //       ),
      //     );
      //     return showSnackBar(context, "Register account Success");
      //   } else {
      //     return showSnackBar(context, "Register account Fail");
      //
      //   }
      // }
    }

    return Scaffold(
      body: Form(
        //key: keySignUp,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VENDOR SIGN UP',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Already have Account?',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VendorSignIn(),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18, color: Colors.yellow.shade900),
                    ),
                  ),
                ],
              ),
              TextFieldCustom(
                validator: (value) =>
                    value!.isEmpty ? "Field Cannot Empty" : null,
                hintText: 'Email',
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldCustom(
                isPass: true,
                validator: (value) =>
                    value!.isEmpty ? "Field Cannot Empty" : null,
                hintText: 'Password',
                onChanged: (value) {
                  pass = value;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  onPressed: () {
                    signUpVendor(email, pass);
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
