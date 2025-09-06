import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopby/components/home/home_components.dart';
import 'package:shopby/data/response/status.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/utils/routes/routes_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/category_view_model.dart';
import 'package:shopby/view_model/home_categories_view_model.dart';

class SeeAllScreen extends ConsumerStatefulWidget {
  const SeeAllScreen({super.key});

  @override
  ConsumerState<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends ConsumerState<SeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final state = ref.watch(categoriesViewModelProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: screenHeight * 0.14,
              width: screenWidth * 0.95,
              decoration: const BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SUMMER SALES",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "UP TO 50% OFF",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: state.data!.length,
                itemBuilder: (context, index) {
                  switch (state.status) {
                    case Status.loading:
                      return Center(
                        child: Shimmer.fromColors(
                          baseColor: AppColors.textFieldColor,
                          highlightColor: Colors.white,
                          period: const Duration(seconds: 2),
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              height: screenHeight * 0.13,
                              width: screenWidth * 0.9,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      );
                    case Status.completed:
                      return CategoriesContainer(
                        title: state.data![index].name.toString(),
                        image: state.data![index].image.toString(),
                        onTap: () {
                          final categoryState = ref.watch(
                            categoryModelProvider(
                              state.data![index].slug.toString(),
                            ),
                          );
                          final categoryStateNotifier = ref.watch(
                            categoryModelProvider(
                              state.data![index].slug.toString(),
                            ).notifier,
                          );
                          categoryStateNotifier.fetchProducts(
                            slug: state.data![index].slug.toString(),
                          );
                          Navigator.pushNamed(
                            context,
                            RoutesName.categoryScreen,
                            arguments: {
                              "categoryTitle": state.data![index].name
                                  .toString(),
                              "slug": state.data![index].slug.toString(),
                            },
                          );
                        },
                      );
                    case Status.error:
                      return Center(child: Text(state.message.toString()));
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
