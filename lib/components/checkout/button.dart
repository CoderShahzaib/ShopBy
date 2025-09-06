import 'package:flutter/material.dart';
import 'package:shopby/resources/colors.dart';

class Button extends StatelessWidget {
  final Color color;
  final String text;
  final double height;
  final double width;
  final VoidCallback onContinue;
  final String? image;
  final Color textColor;
  final Color? borderColor;

  const Button({
    super.key,
    required this.color,
    this.image,
    required this.onContinue,
    required this.text,
    this.height = 55,
    this.width = double.infinity,
    this.textColor = AppColors.white,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 3,
          shadowColor: AppColors.grey100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        onPressed: onContinue,
        child: image != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(image!, height: 24, width: 24),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: image == '' ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
