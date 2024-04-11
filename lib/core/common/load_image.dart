import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/utils.dart';
import 'loading_spinner.dart';

class LoadImage extends HookWidget {
  final String imageUrl;
  final String placholder;
  final Color? color;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final String? userName;

  const LoadImage({
    super.key,
    required this.imageUrl,
    required this.placholder,
    this.color,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == '' || imageUrl.isEmpty || imageUrl == 'https://'
        ? Image.asset(
            placholder,
            fit: fit ?? BoxFit.cover,
            color: color,
            height: height,
            width: width,
          )
        : imageUrl.toLowerCase().endsWith('.svg')
            ? SvgPicture.network(
                Utils.parseUrl(imageUrl.replaceAll(' ', '%20')),
              )
            : CachedNetworkImage(
                // maxHeightDiskCache: 30000,
                fit: BoxFit.cover,
                height: height,
                width: width,
                filterQuality: FilterQuality.high,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: LoadingSpinner(
                    color: color,
                    width: 20,
                    height: 20,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(placholder, fit: fit, color: color),
                imageUrl: Utils.parseUrl(imageUrl),
              );
  }
}
