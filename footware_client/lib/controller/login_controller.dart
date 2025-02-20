import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footware_client/models/user_model/user.dart';
import 'package:footware_client/pages/home_page.dart';
import 'package:footware_client/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';

import 'package:otp_text_field_v2/otp_field_v2.dart';

class LoginController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  // Controllers for managing text input fields.
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController loginPhoneNumberController = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpVisible = false;
  int? otpCode;
  int? otpEnter;

  User? loginUser;

  GetStorage getStorage = GetStorage();
  @override
  void onReady() {
    var user = getStorage.read("loginUser");
    print(user);
    if(user != null){
      loginUser = User.fromJson(user);
      Get.to(HomePage());
    }else{
      Get.to(LoginPage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection("users");
    super.onInit();
  }

  addUser() {
    try {
      if (nameController.text.isEmpty || phoneNumberController.text.isEmpty) {
        // show msg
        Get.snackbar(
          'Error',
          "Please fill the field!",
          colorText: Colors.red,
        );
        return;
      }
      if (otpCode != otpEnter) {
        // show msg
        Get.snackbar(
          'Error',
          "OTP is incorrect",
          colorText: Colors.red,
        );
      } else {
        // Creates a Firestore document reference.
        DocumentReference documentReference = userCollection.doc();
        // Creates a Product object with user input.
        User user = User(
          id: documentReference.id,
          name: nameController.text,
          phoneNumber: int.tryParse(phoneNumberController.text),
        );
        // Converts Product into JSON
        final userJson = user.toJson();
        // stores it in Firestore
        documentReference.set(userJson);
        // show msg
        Get.snackbar(
          'Success',
          "Register successfully!",
          colorText: Colors.green,
        );
        Get.to(LoginPage());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.red,
      );
    }
  }

  sendingOTP() {
    if (nameController.text.isEmpty || phoneNumberController.text.isEmpty) {
      // show msg
      Get.snackbar(
        'Error',
        "Please fill the field!",
        colorText: Colors.red,
      );
      return;
    }
    final random = Random();
    int otp = 1000 + random.nextInt(9000);
    print(otp);
    otpVisible = true;
    otpCode = otp;
    // show msg
    Get.snackbar(
      'Success',
      "Sent OTP successfully!",
      colorText: Colors.green,
    );
    update();
  }

  loginWithPhoneNumber() async {
    try {
      int? phoneNumber = int.tryParse(loginPhoneNumberController.text);
      if (phoneNumber != null) {
        var querySnapshot = await userCollection
            .where('phoneNumber', isEqualTo: phoneNumber)
            .limit(1).get();
        if(querySnapshot.docs.isNotEmpty){
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String,dynamic>;
          getStorage.write("loginUser", userData);
          // show msg
          Get.snackbar(
            'Success',
            "Login successfully!",
            colorText: Colors.green,
          );
          loginPhoneNumberController.clear();
          Get.to(HomePage());
        }else{
          // show msg
          Get.snackbar(
            'Error',
            "User Not Found!",
            colorText: Colors.red,
          );
        }
      }else{
        // show msg
        Get.snackbar(
          'Error',
          "Please Enter Phone Number",
          colorText: Colors.red,
        );
      }
    } catch (e) {
      print(e);
      // show msg
      Get.snackbar(
        'Error',
        "Failed to login",
        colorText: Colors.red,
      );
    }
  }
}
