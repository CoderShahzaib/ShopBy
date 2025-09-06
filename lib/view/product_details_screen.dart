import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopby/components/cart/add_to_cart_button.dart';
import 'package:shopby/components/home/home_components.dart';
import 'package:shopby/model/products_model.dart';
import 'package:shopby/resources/colors.dart';
import 'package:shopby/utils/routes/routes_name.dart';
import 'package:shopby/utils/utils.dart';
import 'package:shopby/view_model/product_details_notifier.dart';
import 'package:shopby/repository/similar_products_repository.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:persistent_shopping_cart/controller/cart_controller.dart';
import 'package:shopby/widgets/reviewTextField.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Products product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productDetailsProvider.notifier)
          .setSelectedImage(widget.product.images.first);
    });
  }

  @override
  void dispose() {
    ref.invalidate(productDetailsProvider);
    reviewController.dispose();
    super.dispose();
  }

  void showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final selectedImage = ref.watch(productDetailsProvider).selectedImage;
    final screenWidth = MediaQuery.of(context).size.width;
    final similarState = ref.watch(
      similarProductsProvider((
        widget.product.category!.id!,
        widget.product.id!,
      )),
    );
    Future<void> submitReview() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Utils.showToast("Please sign in to submit a review.");
        return;
      }
      if (reviewController.text.isEmpty) {
        Utils.showToast("Please write a review.");
        return;
      }
      final reviewRef = FirebaseDatabase.instance
          .ref("reviews")
          .child(widget.product.id.toString());

      await reviewRef.push().set({
        'userId': user.uid,
        'username': user.displayName ?? 'Anonymous',
        'userEmail': user.email ?? 'Anonymous',
        'review': reviewController.text.trim(),
        "timestamp": DateTime.now().toIso8601String(),
        "userImage": user.photoURL ?? 'assets/user_avatar.png',
      });
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.4,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: ValueListenableBuilder(
          valueListenable: CartController().cartListenable,
          builder: (_, __, ___) {
            final inCart = CartController().isItemExistsInCart(
              widget.product.id.toString(),
            );
            return AddToCartButton(
              title: inCart ? "Remove from Cart" : "Add to Cart",
              horizontal: 0,
              vertical: 16,
              onPressed: () async {
                if (user != null) {
                  final cart = PersistentShoppingCart();
                  if (inCart) {
                    await cart.removeFromCart(widget.product.id.toString());
                  } else {
                    await cart.addToCart(
                      PersistentShoppingCartItem(
                        productId: widget.product.id.toString(),
                        productName: widget.product.title ?? '',
                        unitPrice: widget.product.price!.toDouble(),
                        quantity: 1,
                        productImages: widget.product.images,
                      ),
                    );
                  }
                } else {
                  Utils.showToast("Please login first");
                }
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product main image
            GestureDetector(
              onTap: () => showFullImage(selectedImage),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: CachedNetworkImage(
                    key: ValueKey(selectedImage),
                    imageUrl: selectedImage,
                    height: screenWidth * 0.6,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: screenWidth * 0.6,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Image thumbnails
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final image = widget.product.images[index];
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(productDetailsProvider.notifier)
                          .setSelectedImage(image);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedImage == image
                              ? AppColors.red
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Title + Price
            Text(
              widget.product.title ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${widget.product.price!.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.red,
              ),
            ),
            const SizedBox(height: 16),

            ReadMoreText(
              widget.product.description ?? '',
              trimLines: 4,
              trimMode: TrimMode.Line,
              colorClickableText: AppColors.red,
              trimCollapsedText: ' Read more',
              trimExpandedText: ' Show less',
              moreStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
              lessStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Product Reviews",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutesName.reviewScreen,
                      arguments: widget.product.id,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.red,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: reviewTextField(
                      controller: reviewController,
                      maxLines: 8,
                      onSubmit: (_) async {
                        await submitReview().then(
                          (_) => reviewController.clear(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref("reviews")
                  .child(widget.product.id.toString())
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Text(
                    "No reviews yet. Be the first one!",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  );
                }

                final rawData = snapshot.data!.snapshot.value;
                Map<String, dynamic> data = {};

                if (rawData is Map) {
                  // Flatten nested maps
                  rawData.forEach((key, value) {
                    if (value is Map) {
                      if (value.containsKey("review")) {
                        data[key.toString()] = value;
                      } else {
                        value.forEach((k, v) {
                          if (v is Map && v.containsKey("review")) {
                            data[k.toString()] = v;
                          }
                        });
                      }
                    }
                  });
                }

                final reviews =
                    data.values
                        .map((r) => Map<String, dynamic>.from(r))
                        .toList()
                      ..sort(
                        (a, b) => DateTime.parse(
                          b["timestamp"],
                        ).compareTo(DateTime.parse(a["timestamp"])),
                      );

                final limitedReviews = reviews.take(5).toList(); // max 5

                return Column(
                  children: limitedReviews.map((review) {
                    return Card(
                      color: AppColors.grey100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  review["userImage"].toString().startsWith(
                                    "http",
                                  )
                                  ? NetworkImage(review["userImage"])
                                  : const AssetImage("assets/user_avatar.png")
                                        as ImageProvider,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        review["username"] ?? "Anonymous",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        DateTime.tryParse(
                                                  review["timestamp"] ?? "",
                                                ) !=
                                                null
                                            ? DateFormat("dd MMM yyyy").format(
                                                DateTime.parse(
                                                  review["timestamp"],
                                                ),
                                              )
                                            : "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    review["review"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            SizedBox(height: 5),
            const Text(
              "Similar Products",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            similarState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text("No similar products found."),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final p = list[index];
                    return ProductCard(product: p);
                  },
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
