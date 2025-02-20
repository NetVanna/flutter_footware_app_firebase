import 'package:flutter/material.dart';
import 'package:footware_client/controller/login_controller.dart';
import 'package:footware_client/pages/login_page.dart';
import 'package:get/get.dart';

import '../widgets/otp_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.blueGrey[50]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Your Account!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.person),
                    labelText: "Your Name",
                    hintText: "Enter your name"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(Icons.phone_android_outlined),
                    labelText: "Mobile Number",
                    hintText: "Enter your phone number"),
              ),
              SizedBox(height: 20),
              OtpTextField(
                otpController: controller.otpController,
                visible: controller.otpVisible,
                onCompleted: (otp) {
                  controller.otpEnter = int.tryParse(otp);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (controller.otpVisible == false) {
                    controller.sendingOTP();
                  } else {
                    controller.addUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text(controller.otpVisible ? "Register" : "Sent OTP"),
              ),
              TextButton(
                onPressed: () {
                  Get.to(LoginPage());
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
