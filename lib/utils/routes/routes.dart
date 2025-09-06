import 'package:flutter/material.dart';
import 'package:shopby/components/home/bottom_nav.dart';
import 'package:shopby/components/profile_screen/forgot_password.dart';
import 'package:shopby/components/profile_screen/signin_form.dart';
import 'package:shopby/components/profile_screen/signup_form.dart';
import 'package:shopby/model/products_model.dart';
import 'package:shopby/utils/routes/routes_name.dart';
import 'package:shopby/view/cart_view.dart';
import 'package:shopby/view/category_view.dart';
import 'package:shopby/view/product_details_screen.dart';
import 'package:shopby/view/review_screen.dart';
import 'package:shopby/view/see_all_screen.dart';
import 'package:shopby/view/splash_screen.dart';
import 'package:shopby/view/profile_screen.dart';
import 'package:shopby/view/user_profile_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return _defaultRoute(const SplashScreen());

      case RoutesName.home:
        return _defaultRoute(BottomNav());

      case RoutesName.categoryScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final String categoryTitle = args['categoryTitle'];
        final String slug = args['slug'];
        return _slideFromRightRoute(
          CategoryView(categoryTitle: categoryTitle, slug: slug),
        );
      case RoutesName.seeAllScreen:
        return _slideFromRightRoute(SeeAllScreen());
      case RoutesName.productDetailsScreen:
        final product = settings.arguments as Products;
        return _slideFromRightRoute(ProductDetailsScreen(product: product));
      case RoutesName.cartScreen:
        return _slideFromRightRoute(CartView());
      case RoutesName.profileScreen:
        return _defaultRoute(ProfileScreen());
      case RoutesName.forgotPassword:
        return _defaultRoute(ForgotPassword());
      case RoutesName.signIn:
        return _defaultRoute(SigninForm());
      case RoutesName.signUp:
        return _defaultRoute(SignupForm());
      case RoutesName.userProfile:
        return _slideFromRightRoute(UserProfileTab());
      case RoutesName.reviewScreen:
        final productId = settings.arguments as int;
        return _slideFromRightRoute(ReviewScreen(productId: productId));
      default:
        return _defaultRoute(
          const Scaffold(
            body: Center(
              child: Text(
                "No Route Found",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
    }
  }

  static Route _defaultRoute(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  static Route _slideFromRightRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
