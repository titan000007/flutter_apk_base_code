import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_color.dart';

class CommonNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColor.greyShade300,
        highlightColor: AppColor.greyShade200,
        child: Container(
          width: width,
          height: height,
          color: AppColor.greyShade300,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Color(0xFFF4F4F4),
        alignment: Alignment.center,
        child: Icon(
          Icons.error_outline_outlined,
          color: AppColor.c272727,
          size: 20,
        ),
      ),
    );
  }
}

