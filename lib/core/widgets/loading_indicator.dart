import 'dart:math' show pi;
import 'package:pokedex/core/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/gen/assets.gen.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: controller.value * 2 * pi,
            child: child,
          );
        },
        child: LocalImage(
          Assets.images.appIcon.path,
          height: 36,
        ),
      ),
    );
  }
}
