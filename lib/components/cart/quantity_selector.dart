import 'package:flutter/material.dart';
import 'package:shopby/resources/colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback increment;
  final VoidCallback decrement;
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.increment,
    required this.decrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: AppColors.white,
        border: Border.all(color: AppColors.textFieldColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _circleButton(
            icon: Icons.remove,
            onPressed: decrement,
            color: AppColors.textFieldColor,
            iconColor: AppColors.black,
          ),
          const SizedBox(width: 8),
          Text(
            quantity.toString().padLeft(2, '0'),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(width: 8),
          _circleButton(
            icon: Icons.add,
            onPressed: increment,
            color: AppColors.red,
            iconColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}

Widget _circleButton({
  required IconData icon,
  required VoidCallback onPressed,
  required Color color,
  required Color iconColor,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Icon(icon, size: 16, color: iconColor),
    ),
  );
}
