import 'package:flutter/material.dart';
import 'package:shopby/resources/colors.dart';

Widget buildTextField(
  String label,
  TextInputType textInputType,
  TextEditingController controller, {
  FormFieldValidator<String>? validator,
  bool obscureText = false,
  VoidCallback? onToggleVisibility,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType,
    obscureText: obscureText,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.black),
      filled: true,
      fillColor: AppColors.grey100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.textFieldColor, width: 2),
      ),
      suffixIcon: onToggleVisibility != null
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.black,
              ),
              onPressed: onToggleVisibility,
            )
          : null,
    ),
  );
}
