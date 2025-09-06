import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopby/resources/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/splash_services.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final splashState = ref.read(splashServicesProvider);
    splashState.animationInitializer(context, this);
  }

  @override
  void dispose() {
    super.dispose();
    final splashState = ref.read(splashServicesProvider);
    splashState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final splashState = ref.watch(splashServicesProvider);
    return Scaffold(
      body: Container(
        height: screenHeight * 1,
        width: screenWidth * 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9FAFC), Color(0xFFFF7F24), Color(0xFFFF2D75)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: splashState.scaleAnimation,
              child: FadeTransition(
                opacity: splashState.fadeAnimation,
                child: Container(
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            SlideTransition(
              position: splashState.slideAnimation,
              child: const Text(
                'ShopBy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  fontFamily: 'Poppins',
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black26,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            FadeTransition(
              opacity: splashState.fadeAnimation,
              child: const Text(
                "Your Ultimate Shopping Destination!",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            const SpinKitWave(color: AppColors.black, size: 40.0),
          ],
        ),
      ),
    );
  }
}
