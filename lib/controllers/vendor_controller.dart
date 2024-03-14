import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';


class VendorController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  String res = "Something error";

  Future<String> vendorLogin(String email, String pass) async {
    try {
      final credential =
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> vendorSignUp(String email, String pass) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      res = "Register Success";
    }catch(e){
      print(e.toString());
    }
    return res;
  }

  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    final imagePick = await _imagePicker.pickImage(source: source);
    return imagePick;
  }

  uploadVendorPicToStorage(File? image) async {
    try {
      if (image != null) {
        Reference ref =
        _storage.ref().child('storeImage').child(_auth.currentUser?.uid ?? "");
        UploadTask uploadTask = ref.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downUrl = await snapshot.ref.getDownloadURL();
        return downUrl;
      }
    } catch (e) {
      print("Loi upload image to storage ${e.toString()}");
    }
  }

  Future<String> registerVendor(
      String businessName,
      String email,
      String phoneNumber,
      String countryValue,
      String stateValue,
      String cityValue,
      String taxNumber,
      String taxRegistered,
      File? image) async{
    try {
      print(businessName.isNotEmpty);
      print(email.isNotEmpty);
      print(phoneNumber.isNotEmpty);
      print(countryValue.isNotEmpty);
      print(stateValue.isNotEmpty);
      print(cityValue.isNotEmpty);
      print(taxRegistered.isNotEmpty);
      print(taxNumber.isNotEmpty);
      print(image != null);

      if(businessName.isNotEmpty && email.isNotEmpty
          && phoneNumber.isNotEmpty && countryValue.isNotEmpty
          && stateValue.isNotEmpty && cityValue.isNotEmpty && taxRegistered.isNotEmpty
          && taxNumber.isNotEmpty && image != null
      ){
        String storeImage = await uploadVendorPicToStorage(image);
        await _store.collection('vendors').doc(_auth.currentUser?.uid ?? "").set({
          "businessName" : businessName,
          "email" : email,
          "phoneNumber" : phoneNumber,
          "countryValue" : countryValue,
          "cityValue" : cityValue,
          "taxRegistered" : taxRegistered,
          "taxNumber" : taxNumber,
          "storeImage" : storeImage,
          "approved" : false,
          'stateValue' : stateValue,
          'vendorId' : _auth.currentUser?.uid ?? ""
        });
        res = "Success";
      }
    } catch (e) {
      res = "Loi register : ${e.toString()}";
    }
    return res;
  }
}
