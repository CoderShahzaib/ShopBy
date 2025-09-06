import 'package:flutter/material.dart';
import 'package:shopby/components/checkout/button.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/utils/utils.dart';
import 'package:shopby/view_model/profile_screen_notifier.dart';
import 'package:shopby/widgets/buildtextfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildTextField(
              "Enter your Name",
              TextInputType.text,
              _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            buildTextField(
              "Enter your Email",
              TextInputType.emailAddress,
              _emailController,
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
            SizedBox(height: screenHeight * 0.03),
            buildTextField(
              "Enter your Password",
              TextInputType.visiblePassword,
              _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !ref.watch(profileScreenProvider).toggleVisibility,
              onToggleVisibility: () {
                ref.read(profileScreenProvider.notifier).toggleVisibility();
              },
            ),
            SizedBox(height: screenHeight * 0.06),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Button(
                onContinue: () {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    auth
                        .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        )
                        .then((userCredential) async {
                          User? user = userCredential.user;
                          if (user != null) {
                            await user.updateDisplayName(
                              _nameController.text.trim(),
                            );
                            await user.reload();

                            _nameController.clear();
                            _emailController.clear();
                            _passwordController.clear();

                            Utils.showToast("Account created successfully");
                          }
                        })
                        .onError((error, stackTrace) {
                          Utils.showToast(error.toString());
                        });
                  }
                },

                text: "Sign Up",
                color: AppColors.red,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
