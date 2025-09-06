import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopby/components/cart/loading_widget.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final double iconSize;
  final BoxFit fit;
  final Alignment alignment;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.iconSize = 24,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUrl =
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith("http://") || imageUrl.startsWith("https://"));

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: isValidUrl
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              imageBuilder: (context, imageProvider) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                    alignment: alignment,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width: width,
                height: height,
                color: Colors.grey.shade300,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: LoadingWidget(),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: width,
                height: height,
                color: Colors.grey,
                child: Icon(
                  Icons.broken_image,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              width: width,
              height: height,
              color: Colors.grey,
              child: Icon(
                Icons.broken_image,
                size: iconSize,
                color: Colors.white,
              ),
            ),
    );
  }
}
