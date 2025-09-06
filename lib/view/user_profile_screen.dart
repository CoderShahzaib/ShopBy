import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/components/checkout/button.dart';
import 'package:shopby/utils/utils.dart';

class UserProfileTab extends StatelessWidget {
  const UserProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: AppColors.grey100,
          backgroundImage: user.photoURL != null
              ? NetworkImage(user.photoURL!)
              : const AssetImage('assets/user_avatar.png') as ImageProvider,
        ),
        const SizedBox(height: 20),
        Text(
          user.displayName ?? 'Anonymous User',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.email ?? 'No Email Provided',
          style: const TextStyle(fontSize: 16, color: AppColors.grey),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: AppColors.red),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Your account is active. You can manage preferences, update details, or log out anytime.",
                  style: TextStyle(fontSize: 14, color: AppColors.black),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: Button(
            text: 'Logout',
            color: AppColors.red,
            onContinue: () async {
              await FirebaseAuth.instance.signOut();
              Utils.showToast("Signed out successfully");
            },
          ),
        ),
      ],
    );
  }
}
