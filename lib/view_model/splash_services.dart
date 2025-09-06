import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/utils/routes/routes_name.dart';

class SplashState {
  late AnimationController fadeController;
  late AnimationController scaleController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;

  void animationInitializer(BuildContext context, TickerProvider vsync) {
    fadeController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    );
    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeInOut,
    );

    scaleController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 3),
    );
    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeInOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    fadeController.forward();
    scaleController.forward();

    fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        movetoHome(context);
      }
    });
  }

  void movetoHome(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      Navigator.pushReplacementNamed(context, RoutesName.home);
    });
  }

  void dispose() {
    fadeController.dispose();
    scaleController.dispose();
  }
}

final splashServicesProvider = Provider<SplashState>((ref) => SplashState());
