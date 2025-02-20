import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    required this.label,
    required this.hintText,
    this.showIcon = false,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon, suffixIcon;
  final int? maxLines;
  final String label, hintText;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: hintText,
        label: Text(label),
        prefixIcon: showIcon ? Icon(prefixIcon):null,
        suffixIcon: showIcon ? Icon(suffixIcon):null,
      ),
    );
  }
}
