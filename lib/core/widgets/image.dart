import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import 'package:pokedex/gen/assets.gen.dart';

/// simple wrapper around CachedNetworkImage that provides any boilerplate we need for images on the app
class HostedImage extends StatelessWidget {
  const HostedImage(
    this.url, {
    Key? key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  }) : super(key: key);
  final String url;
  final double? height, width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      height: height,
      width: width,
      progressIndicatorBuilder: (_, s, i) =>
          CupertinoActivityIndicator.partiallyRevealed(
        progress: i.progress ?? 1,
      ),
      errorWidget: (_, s, ___) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: LocalImage(
          Assets.images.appIcon.path,
        ),
      ),
      fadeInDuration: const Duration(milliseconds: 1000),
    );
  }
}

class LocalImage extends StatelessWidget {
  const LocalImage(this.image,
      {Key? key, this.height, this.width, this.fit = BoxFit.contain})
      : super(key: key);
  final String image;
  final double? height, width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: fit,
      height: height,
      width: width,
    );
  }
}
