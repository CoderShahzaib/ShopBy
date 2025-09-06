import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/utils/routes/routes_name.dart';
import 'package:shopby/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopby/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(PersistentShoppingCartItemAdapter());

  await Hive.openBox<PersistentShoppingCartItem>('cartBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ShopBy",

        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.black),
            titleTextStyle: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
