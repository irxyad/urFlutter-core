import 'package:flutter/material.dart';
import 'package:urflutter_core/src/extensions/context_extension.dart';
import 'package:urflutter_core/src/utils/app_dimension.dart';
import 'package:urflutter_core/src/widgets/textfield/enums/show_border_type.dart';

class UrTextField extends StatelessWidget {
  const UrTextField({
    super.key,
    this.label,
    this.hintText,
    this.showBorder = ShowBorderType.none,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.maxLines,
    this.minLines,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.borderRadius,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    this.labelColor,
    this.onEditingComplete,
    this.autoFocus = false,
    this.expands = false,
    this.enabled = true,
    this.filled = true,
    this.isUnfocusTapOutside = true,
    this.labelStyle,
    this.scrollController,
  });

  final String? label;
  final String? hintText;

  final ShowBorderType showBorder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;

  final bool enabled;
  final bool filled;
  final bool isUnfocusTapOutside;
  final bool autoFocus;
  final bool expands;

  final Color? fillColor;
  final Color? labelColor;
  final Color? textColor;
  final Color? hintColor;

  final TextStyle? labelStyle;

  final BorderRadius? borderRadius;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  final ScrollController? scrollController;

  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final decoration = showBorder.getDecoration(borderRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: UrDimension.spacing / 4,
      children: [
        if (label != null)
          _Label(
            label!,
            false,
            labelColor ?? context.colorScheme.onSurface,
            textStyle: labelStyle ?? context.textTheme.titleMedium,
          ),
        TextField(
          controller: controller,
          expands: expands,
          maxLines: maxLines,
          autofocus: autoFocus,
          minLines: minLines ?? 1,
          enabled: enabled,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          scrollController: scrollController,
          onEditingComplete: onEditingComplete,
          scrollPhysics: const BouncingScrollPhysics(),
          onTapOutside: (_) {
            if (isUnfocusTapOutside) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          decoration: InputDecoration(
            filled: filled,
            fillColor: enabled ? fillColor : Colors.transparent,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: decoration.border,
            enabledBorder: decoration.enabledBorder,
            focusedBorder: decoration.focusedBorder,
            disabledBorder: decoration.disabledBorder,
            errorBorder: decoration.errorBorder,
            errorMaxLines: 2,
            focusedErrorBorder: decoration.focusedErrorBorder,
            hintText: hintText,
            hintMaxLines: 1,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: UrDimension.spacing / 1.5,
              vertical: UrDimension.spacing / 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, this.isRequired, this.color, {this.textStyle});

  final String text;
  final bool isRequired;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ?? context.textTheme.bodyMedium!.copyWith(color: color);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: style),
        if (isRequired)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text('*', style: style.copyWith(color: Colors.red)),
          ),
      ],
    );
  }
}
