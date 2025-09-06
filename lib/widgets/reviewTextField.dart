import 'package:flutter/material.dart';
import 'package:shopby/resources/colors.dart';

Widget reviewTextField({
  required TextEditingController controller,
  required Function(String) onSubmit,
  String hintText = 'Write your review.....',
  int maxLines = 3,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.multiline,
    maxLines: maxLines,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your review';
      }
      return null;
    },
    onFieldSubmitted: onSubmit,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.grey100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.textFieldColor, width: 2),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.send),
        color: AppColors.red,
        onPressed: () => onSubmit(controller.text),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.grey),
    ),
  );
}
