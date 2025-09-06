import 'package:flutter/material.dart';
import 'package:shopby/resources/colors.dart';

class AddToCartButton extends StatelessWidget {
  final String title;
  final double horizontal;
  final double vertical;
  final VoidCallback onPressed;

  const AddToCartButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.horizontal = 0,
    this.vertical = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        backgroundColor: AppColors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title == "Add to Cart"
              ? Icon(Icons.add_shopping_cart, color: AppColors.white, size: 20)
              : Icon(
                  Icons.remove_shopping_cart,
                  color: AppColors.white,
                  size: 20,
                ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
