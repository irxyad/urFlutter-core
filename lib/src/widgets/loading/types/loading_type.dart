enum LoadingType {
  circular,
  linear,
  threeDots,
  newtonCradle,
  waveDots,
  pulse,
  spinner,
  bouncingBall;

  double get defaultSize {
    switch (this) {
      case LoadingType.circular:
      case LoadingType.pulse:
        return 24.0;
      case LoadingType.linear:
        return 4.0;
      case LoadingType.newtonCradle:
      case LoadingType.waveDots:
        return 40.0;
      case LoadingType.threeDots:
      case LoadingType.spinner:
      case LoadingType.bouncingBall:
        return 32.0;
    }
  }
}

enum LoadingPosition { center, top, bottom }

enum LoadingMode { overlay, dialog, inline }
