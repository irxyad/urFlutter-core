import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:urflutter_core/extensions.dart';
import 'package:urflutter_core/src/styles/colors.dart';
import 'package:urflutter_core/src/widgets/show_fullscreen_image.dart';
import 'package:urflutter_core/urflutter_config.dart';
import 'package:urflutter_core/utils.dart';

part 'style.dart';
part 'types/icon.dart';
part 'types/pick_image.dart';
part 'types/text.dart';
part 'types/text_icon.dart';

class PropsButton {
  PropsButton({
    this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.useSafeArea = false,
    this.borderRadius,
    this.height,
    this.width,
    this.enabled = true,
    this.type = AppButtonType.primary,
    this.labelStyle,
    this.padding,
    this.elevation,
    this.gradient,
    this.shadowColor,
    this.isLoading = false,
    this.mainAxisSize = MainAxisSize.min,
  });
  final Color? foregroundColor;
  final Color? overlayColor;
  final Color? backgroundColor;
  final Color? shadowColor;
  final bool useSafeArea;
  final bool enabled;
  final double? height;
  final double? width;
  final void Function()? onPressed;
  final String? label;
  final BorderRadius? borderRadius;
  final AppButtonType type;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final double? elevation;
  final bool isLoading;
  final MainAxisSize mainAxisSize;
}

class PropsIconButton extends PropsButton {
  PropsIconButton({
    required super.onPressed,
    super.label,
    super.foregroundColor,
    super.backgroundColor,
    super.borderRadius,
    super.height,
    super.width,
    super.useSafeArea,
    super.overlayColor,
    super.type,
    super.padding,
    super.labelStyle,
    super.elevation,
    super.enabled,
    super.isLoading,
    super.mainAxisSize,
    this.icon,
    this.iconSVG,
    this.iconColor,
    this.iconSize,
    this.iconWidget,
    this.spacing,
    this.size,
    this.isReversed = false,
    this.paddingIcon,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.isRow = true,
    this.tooltip,
  });
  final bool isReversed;
  final IconData? icon;
  final String? iconSVG;
  final Color? iconColor;
  final double? iconSize;
  final Widget? iconWidget;
  final double? spacing;
  final double? paddingIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? size;
  final bool isRow;
  final String? tooltip;
}

class PropsPickImgButton {
  const PropsPickImgButton({
    required this.hintPickImage,
    this.onChanged,
    this.label,
    this.titleCropper,
    this.backgroundColor,
    this.aspectRatio,
    this.selectedImage,
    this.prefixFilename,
    this.isRequired = false,
  });
  final void Function(File? image)? onChanged;
  final String hintPickImage;
  final String? label;
  final String? titleCropper;
  final Color? backgroundColor;
  final double? aspectRatio;
  final bool isRequired;
  final String? prefixFilename;
  final File? selectedImage;

  PropsPickImgButton copyWith({
    void Function(File? image)? onChanged,
    String? hintPickImage,
    String? label,
    String? titleCropper,
    Color? backgroundColor,
    double? aspectRatio,
    File? selectedImage,
  }) {
    return PropsPickImgButton(
      onChanged: onChanged ?? this.onChanged,
      hintPickImage: hintPickImage ?? this.hintPickImage,
      label: label ?? this.label,
      titleCropper: titleCropper ?? this.titleCropper,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}

abstract class UrButton {
  static Widget text({required PropsButton props}) => _Text(props: props);
  static Widget textIcon({required PropsIconButton props, Key? key}) =>
      _TextIcon(props: props);
  static Widget icon({required PropsIconButton props}) => _Icon(props: props);
  static Widget pickImage({required PropsPickImgButton props}) =>
      _PickImage(props: props);
}
