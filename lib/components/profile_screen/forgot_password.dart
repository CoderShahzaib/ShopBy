import 'package:flutter/material.dart';
import 'package:shopby/components/checkout/button.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/utils/utils.dart';
import 'package:shopby/widgets/buildtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.white),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.08),
                const Center(
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                const Center(
                  child: Text(
                    "Enter your email and we will send you a password reset link",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                buildTextField(
                  "Email",
                  TextInputType.emailAddress,
                  emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        color: AppColors.grey,
                        onContinue: () {
                          Navigator.pop(context);
                        },
                        text: "Cancel",
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Button(
                        color: AppColors.red,
                        onContinue: () {
                          if (formKey.currentState!.validate()) {
                            auth
                                .sendPasswordResetEmail(
                                  email: emailController.text.trim(),
                                )
                                .then((_) {
                                  Utils.showToast(
                                    "Password reset link sent to your email.",
                                  );
                                  Navigator.pop(context);
                                })
                                .catchError((error) {
                                  Utils.showToast(error.toString());
                                });
                          }
                        },
                        text: "Reset Password",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
