import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopby/components/profile_screen/signin_form.dart';
import 'package:shopby/components/profile_screen/signup_form.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/view/user_profile_screen.dart';
import 'package:shopby/view_model/profile_screen_notifier.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileScreenProvider);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 24),
                if (user == null)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            _buildToggleButton("SignUp", 0),
                            _buildToggleButton("SignIn", 1),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      state.selectedIndex == 0
                          ? const SignupForm()
                          : const SigninForm(),
                    ],
                  )
                else
                  const UserProfileTab(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(String text, int index) {
    final state = ref.watch(profileScreenProvider);
    final isSelected = state.selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(profileScreenProvider.notifier).setSelectedIndex(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.red : AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.black,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
