import 'package:flutter/material.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField(
      {super.key,
      required this.otpController,
      required this.visible,
      this.onChanged, this.onCompleted});

  final OtpFieldControllerV2 otpController;
  final bool visible;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: OTPTextFieldV2(
        controller: otpController,
        length: 4,
        width: MediaQuery.of(context).size.width,
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldWidth: 45,
        fieldStyle: FieldStyle.box,
        outlineBorderRadius: 15,
        style: TextStyle(fontSize: 17),
        onChanged: onChanged,
        onCompleted: onCompleted
      ),
    );
  }
}
