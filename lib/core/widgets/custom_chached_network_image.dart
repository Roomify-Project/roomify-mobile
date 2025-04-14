import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const CustomCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius = 0.0,
    this.errorWidget,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl??"",
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => _buildLoadingWidget(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (loadingWidget != null) return loadingWidget!;

    return Shimmer.fromColors(
      baseColor: const Color(0xFF2D1B2E), // Your specified color
      highlightColor: const Color(0xFF2D1B2E).withOpacity(0.3), // Li
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 30,
        ),
      ),
    );
  }
}