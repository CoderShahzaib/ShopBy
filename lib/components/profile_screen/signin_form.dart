import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopby/components/checkout/button.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/utils/routes/routes_name.dart';
import 'package:shopby/utils/utils.dart';
import 'package:shopby/view_model/profile_screen_notifier.dart';
import 'package:shopby/widgets/buildtextfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninForm extends ConsumerStatefulWidget {
  const SigninForm({super.key});

  @override
  ConsumerState<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends ConsumerState<SigninForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      final authentication = googleUser.authentication;
      final String? idToken = authentication.idToken;

      if (idToken == null) {
        if (!mounted) return;
        Utils.showToast("Missing Google ID Token");
        return;
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCred = await _auth.signInWithCredential(credential);

      if (!mounted) return;
      Utils.showToast("Signed in as ${userCred.user!.displayName}");
    } catch (e) {
      if (!mounted) return;
      Utils.showToast("Google Sign-In failed: $e");
    }
  }

  @override
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
                }
                return null;
              },
              obscureText: !ref.watch(profileScreenProvider).toggleVisibility,
              onToggleVisibility: () {
                ref.read(profileScreenProvider.notifier).toggleVisibility();
              },
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.forgotPassword);
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.06),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Button(
                onContinue: () {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    _auth
                        .signInWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        )
                        .then((value) {
                          Utils.showToast("Sign In Successfully");
                          _emailController.clear();
                          _passwordController.clear();
                        })
                        .onError((error, stackTrace) {
                          Utils.showToast(error.toString());
                        });
                  }
                },
                text: "Sign In",
                color: AppColors.red,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Button(
                onContinue: () {
                  _signInWithGoogle();
                },
                text: "Continue With Google",
                color: AppColors.grey100,
                image: 'assets/google.png',
                borderColor: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
