import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopby/components/home/home_components.dart';
import 'package:shopby/resources/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopby/view_model/category_view_model.dart';
import 'package:shopby/data/response/status.dart';

class CategoryView extends ConsumerStatefulWidget {
  final String categoryTitle;
  final String slug;
  const CategoryView({
    super.key,
    required this.categoryTitle,
    required this.slug,
  });

  @override
  ConsumerState<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final state = ref.watch(categoryModelProvider(widget.slug));
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        centerTitle: true,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SearchSection(
                  onSearch: (query) {
                    ref
                        .read(categoryModelProvider(widget.slug).notifier)
                        .fetchProducts(slug: widget.slug, title: query);
                  },
                ),
                SizedBox(height: screenHeight * 0.025),
                Builder(
                  builder: (_) {
                    switch (state.status) {
                      case Status.loading:
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Shimmer.fromColors(
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
                                      crossAxisSpacing: 16,
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
                            ),
                          ),
                        );

                      case Status.completed:
                        final products = state.data!;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          key: ValueKey(state.data?.length ?? 0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.68,
                                ),
                            itemBuilder: (context, index) {
                              return ProductCard(product: products[index]);
                            },
                          ),
                        );

                      case Status.error:
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              state.message ?? "An error occurred",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );

                      default:
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              "Something went wrong",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
