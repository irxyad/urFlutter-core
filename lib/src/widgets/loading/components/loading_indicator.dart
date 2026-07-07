import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../types/loading_type.dart';

class LoadingIndicator extends StatelessWidget {
  final LoadingType type;
  final Color? color;
  final double? size;
  final Widget? customIndicator;

  const LoadingIndicator({
    super.key,
    this.type = LoadingType.circular,
    this.color,
    this.size,
    this.customIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).colorScheme.primary;
    final indicatorSize = size ?? type.defaultSize;

    if (customIndicator != null) return customIndicator!;

    switch (type) {
      case LoadingType.circular:
        return SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: indicatorColor,
          ),
        );

      case LoadingType.linear:
        return SizedBox(
          height: indicatorSize,
          child: LinearProgressIndicator(
            color: indicatorColor,
            backgroundColor: indicatorColor.withValues(alpha: 0.2),
          ),
        );

      case LoadingType.threeDots:
        return LoadingAnimationWidget.threeRotatingDots(
          color: indicatorColor,
          size: indicatorSize,
        );

      case LoadingType.newtonCradle:
        return LoadingAnimationWidget.newtonCradle(
          color: indicatorColor,
          size: indicatorSize,
        );

      case LoadingType.waveDots:
        return LoadingAnimationWidget.waveDots(
          color: indicatorColor,
          size: indicatorSize,
        );

      case LoadingType.pulse:
        return LoadingAnimationWidget.beat(
          color: indicatorColor,
          size: indicatorSize,
        );

      case LoadingType.spinner:
        return LoadingAnimationWidget.staggeredDotsWave(
          color: indicatorColor,
          size: indicatorSize,
        );

      case LoadingType.bouncingBall:
        return LoadingAnimationWidget.bouncingBall(
          color: indicatorColor,
          size: indicatorSize,
        );
    }
  }
}
