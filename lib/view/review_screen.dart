import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopby/resources/colors.dart';

class ReviewScreen extends StatefulWidget {
  final int productId;
  const ReviewScreen({super.key, required this.productId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  /// Format timestamp into readable form
  String formatTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) return "Just now";
      if (difference.inMinutes < 60) return "${difference.inMinutes} min ago";
      if (difference.inHours < 24) return "${difference.inHours} hrs ago";
      if (difference.inDays < 7) return "${difference.inDays} days ago";
      return DateFormat("dd MMM yyyy").format(dateTime);
    } catch (e) {
      return isoString.split("T").first;
    }
  }

  /// Recursively flatten Firebase reviews
  Map<String, dynamic> flatten(dynamic data) {
    final result = <String, dynamic>{};

    if (data is Map) {
      data.forEach((key, value) {
        if (value is Map) {
          if (value.containsKey("review")) {
            result[key.toString()] = value;
          } else {
            result.addAll(flatten(value));
          }
        }
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: const Text(
          "Reviews",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("reviews")
            .child(widget.productId.toString())
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(
              child: Text(
                "No reviews yet. Be the first one!",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            );
          }

          final rawData = snapshot.data!.snapshot.value;
          final data = flatten(rawData);

          final reviews =
              data.values.map((r) => Map<String, dynamic>.from(r)).toList()
                ..sort(
                  (a, b) => DateTime.parse(
                    b["timestamp"],
                  ).compareTo(DateTime.parse(a["timestamp"])),
                );

          final limitedReviews = reviews.take(5).toList(); // show max 5

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: limitedReviews.length,
            itemBuilder: (context, index) {
              final review = limitedReviews[index];

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
                            review["userImage"].toString().startsWith("http")
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review["username"] ?? "Anonymous",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  formatTime(review["timestamp"] ?? ""),
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
            },
          );
        },
      ),
    );
  }
}
