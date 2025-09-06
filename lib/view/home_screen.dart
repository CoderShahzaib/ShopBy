import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopby/components/home/home_components.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/utils/routes/routes_name.dart';
import 'package:shopby/view_model/cart_notifier.dart';
import 'package:shopby/view_model/home_categories_view_model.dart';
import 'package:shopby/view_model/home_view_model.dart';
import 'package:shopby/data/response/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/category_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).fetchProducts();
      ref.read(categoriesViewModelProvider.notifier).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final cartItem = ref.watch(cartNotifier);
    final homeCategoriesState = ref.watch(categoriesViewModelProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HeaderSection(),
              ),
              const SizedBox(height: 14),

              /// 🔹 Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchSection(
                  onSearch: (query) {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .fetchProducts(title: query);
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// 🔹 Banner (full width)
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.asset(
                  "assets/sale.jpg",
                  height: screenHeight * 0.28,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              /// 🔹 Categories Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.seeAllScreen);
                      },
                      child: const Text(
                        "See all",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              /// 🔹 Categories List
              SizedBox(
                height: screenHeight * 0.1,
                child: Builder(
                  builder: (_) {
                    switch (homeCategoriesState.status) {
                      case Status.loading:
                        return Shimmer.fromColors(
                          baseColor: AppColors.textFieldColor,
                          highlightColor: Colors.white,
                          period: const Duration(seconds: 2),
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) => Container(
                              height: screenHeight * 0.1,
                              width: screenWidth * 0.3,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        );

                      case Status.completed:
                        final categories = homeCategoriesState.data ?? [];
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length > 5
                              ? 5
                              : categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: CategoriesItem(
                                title: categories[index].name.toString(),
                                onTap: () {
                                  ref
                                      .watch(
                                        categoryModelProvider(
                                          categories[index].slug.toString(),
                                        ).notifier,
                                      )
                                      .fetchProducts(
                                        slug: categories[index].slug.toString(),
                                      );
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.categoryScreen,
                                    arguments: {
                                      "categoryTitle": categories[index].name
                                          .toString(),
                                      "slug": categories[index].slug.toString(),
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );

                      case Status.error:
                        return Center(
                          child: Text(homeCategoriesState.message.toString()),
                        );

                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              /// 🔹 Products Grid (full width, no outer padding)
              Builder(
                builder: (_) {
                  switch (homeState.status) {
                    case Status.loading:
                      return Shimmer.fromColors(
                        baseColor: AppColors.textFieldColor,
                        highlightColor: Colors.white,
                        period: const Duration(seconds: 2),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.68,
                              ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                        ),
                      );

                    case Status.completed:
                      final products = homeState.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.68,
                            ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: products[index]);
                        },
                      );

                    case Status.error:
                      return Center(
                        child: Text(
                          homeState.message ?? "An error occurred",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );

                    default:
                      return const Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      );
                  }
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
