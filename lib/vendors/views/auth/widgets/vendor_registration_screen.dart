import 'dart:typed_data';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:ecommerce_vendor/vendors/views/auth/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../controllers/vendor_controller.dart';
import '../../../../utils/show_snackbar.dart';
import '../../screens/landing_screen.dart';

class VendorRegistrationScreen extends StatefulWidget {
  final String email;

  const VendorRegistrationScreen({super.key, required this.email});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final VendorController vendorController = VendorController();
  String cityValue = '';
  String countryValue = '';
  String stateValue = '';
  String businessName = '';
  String email = '';
  String phoneNumber = '';
  String taxNumber = "1";

  File? _image;
  final List<String> _taxOption = ['Yes', 'No'];
  String? _taxStatus;

  _selectGalleryImage() async {
    final im = await vendorController.pickStoreImage(ImageSource.gallery);
    if (im != null) {
      setState(() {
        _image = File(im.path);
      });
    }
  }

  _selectCameraImage() async {
    final im = await vendorController.pickStoreImage(ImageSource.camera);
    if (im != null) {
      setState(() {
        _image = File(im.path);
      });
    }
  }

  _registerStoreVendor() async {
    EasyLoading.show(status: "PLEASE WAIT");
    String res = await vendorController
        .registerVendor(businessName, widget.email, phoneNumber, countryValue,
            stateValue, cityValue, taxNumber, _taxStatus!, _image)
        .whenComplete(() {
      EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingScreen(),
        ),
      );
    });
    if (res == "Success") {
      return showSnackBar(context, "Register store Success");
    } else {
      return showSnackBar(context, "Register store Fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue,
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, constrain) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.yellow.shade900, Colors.yellow],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: _image != null
                            ? Image.memory(
                                _image?.readAsBytesSync() as Uint8List,
                                fit: BoxFit.cover,
                              )
                            : IconButton(
                                icon: const Icon(Icons.image),
                                onPressed: () {
                                  _selectCameraImage();
                                },
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFieldCustom(
                    onChanged: (value) {
                      businessName = value;
                    },
                    hintText: 'Business Name',
                    type: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // TextFieldCustom(
                  //   onChanged: (value) {
                  //     email = value;
                  //   },
                  //   hintText: 'Email Address',
                  //   type: TextInputType.emailAddress,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  TextFieldCustom(
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                    hintText: 'Phone Number',
                    type: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tax Registered?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: SizedBox(
                          width: 150,
                          child: DropdownButtonFormField<String>(
                            hint: const Text('Select'),
                            items: _taxOption
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _taxStatus = value;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  _taxStatus == 'Yes'
                      ? TextFieldCustom(
                          onChanged: (value) {
                            taxNumber = value;
                          },
                          hintText: 'Tax Number',
                        )
                      : Container(),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        _registerStoreVendor();
                        //FirebaseAuth.instance.signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
