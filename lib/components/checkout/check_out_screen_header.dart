import 'package:flutter/material.dart';
import 'package:shopby/resources/colors.dart';

class CheckOutScreenHeader extends StatelessWidget {
  final String text;
  final String image;
  final bool isActive;
  const CheckOutScreenHeader({
    super.key,
    required this.text,
    required this.image,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Image.asset(
          image,
          width: 30,
          height: 30,
          color: isActive ? AppColors.black : AppColors.grey,
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          text,
          style: TextStyle(
            color: isActive ? AppColors.black : AppColors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
