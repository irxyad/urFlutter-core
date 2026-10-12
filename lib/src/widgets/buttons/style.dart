part of 'urbutton.dart';

enum AppButtonType { primary, secondary, outline, plain }

class AppButtonStyle {
  const AppButtonStyle({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
}

extension AppButtonTypeExt on AppButtonType {
  AppButtonStyle getStyle(BuildContext context) {
    switch (this) {
      case AppButtonType.primary:
        return AppButtonStyle(
          foregroundColor: UrColors.white,
          backgroundColor: context.colorScheme.primary,
          borderColor: Colors.transparent,
        );
      case AppButtonType.secondary:
        return AppButtonStyle(
          foregroundColor: context.isDarkMode
              ? UrColors.white
              : context.colorScheme.primary,
          backgroundColor: context.colorScheme.surfaceContainerHighest,
          borderColor: Colors.transparent,
        );
      case AppButtonType.outline:
        return AppButtonStyle(
          foregroundColor: context.colorScheme.primary,
          backgroundColor: Colors.transparent,
          borderColor: context.colorScheme.primary,
        );
      case AppButtonType.plain:
        return AppButtonStyle(
          foregroundColor: context.colorScheme.primary,
          backgroundColor: Colors.transparent,
          borderColor: Colors.transparent,
        );
    }
  }
}
