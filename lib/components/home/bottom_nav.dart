import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/view/cart_view.dart';
import 'package:shopby/view/home_screen.dart';
import 'package:shopby/view/profile_screen.dart';
import 'package:shopby/view/user_profile_screen.dart';
import 'package:shopby/view_model/bottom_nav_state.notifier.dart';
import 'package:persistent_shopping_cart/controller/cart_controller.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(bottomNavProvider);
    final navNotifier = ref.read(bottomNavProvider.notifier);

    return Scaffold(
      body: IndexedStack(
        index: navState.currentIndex,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(child: HomeScreen()),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(child: CartView()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  return user != null
                      ? const UserProfileTab()
                      : const ProfileScreen();
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: CartController().cartListenable,
        builder: (context, cart, _) {
          final itemCount = cart.length;

          return BottomNavigationBar(
            currentIndex: navState.currentIndex,
            onTap: navNotifier.changeIndex,
            selectedItemColor: AppColors.red,
            unselectedItemColor: AppColors.black,
            backgroundColor: AppColors.white,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (itemCount > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: "Cart",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Account",
              ),
            ],
          );
        },
      ),
    );
  }
}
