import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:urflutter_core/src/extensions/context_extension.dart';
import 'package:urflutter_core/src/styles/colors.dart';
import 'package:urflutter_core/src/utils/app_dimension.dart';
import 'package:urflutter_core/src/utils/regex_validation.dart';
import 'package:urflutter_core/src/widgets/textfield/enums/show_border_type.dart';

class UrFormTextField extends StatefulWidget {
  const UrFormTextField({
    required this.name,
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.isRequired = true,
    this.isLoading = false,
    this.errorTextValidator,
    this.hintMaxLines = 1,
    this.showBorder = ShowBorderType.none,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.labelStyle,
    this.gapTitle,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.fillColor,
    this.borderRadius,
    this.onTap,
    this.onChanged,
    this.onEditingCompleted,
    this.validators = const [],
    this.valueTransformer,
    this.inputFormatters,
    this.errorColor,
    this.labelColor,
    this.decoration,
    this.showRequiredAsterisk = true,
    this.filled = true,
    this.onTapOutside,
    this.contentMargin,
    this.contentPadding,
  });

  final String name;
  final String? label;
  final String? hintText;
  final String? errorTextValidator;
  final int hintMaxLines;

  final bool enabled;
  final bool readOnly;
  final bool isRequired;
  final bool showRequiredAsterisk;
  final bool filled;
  final bool isLoading;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final int maxLines;
  final double? gapTitle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final ShowBorderType showBorder;
  final TextStyle? labelStyle;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;

  final Color? fillColor;
  final Color? errorColor;
  final Color? labelColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? contentMargin;

  final VoidCallback? onTap;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onEditingCompleted;
  final void Function(PointerDownEvent event)? onTapOutside;

  final List<FormFieldValidator<String>> validators;
  final ValueTransformer<String?>? valueTransformer;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<UrFormTextField> createState() => _UrFormTextFieldState();
}

class _UrFormTextFieldState extends State<UrFormTextField> {
  bool _obscureText = true;

  InputDecoration get decoration =>
      widget.showBorder.getDecoration(widget.borderRadius);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: widget.gapTitle ?? UrDimension.spacing / 3,
      children: [
        if (widget.label != null)
          _Label(
            widget.label!,
            widget.isRequired && widget.showRequiredAsterisk,
            widget.enabled ? widget.labelColor : UrColors.darkGray,
            widget.labelStyle,
          ),
        FormBuilderTextField(
          name: widget.name,
          controller: widget.controller,
          obscureText:
              widget.keyboardType == TextInputType.visiblePassword &&
              _obscureText,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          errorBuilder: (context, errorText) => Container(
            // decoration: BoxDecoration(
            //   color: widget.errorColor ?? UrColors.red,
            //   borderRadius: BorderRadius.circular(999),
            // ),
            margin: const EdgeInsets.only(top: 8),
            // padding:
            //     widget.contentPadding ??
            //     const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            child: Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error,
                  color: widget.errorColor ?? UrColors.red,
                  size: 16,
                ),
                Expanded(
                  child: Text(
                    errorText,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: UrColors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: widget.isLoading ? null : widget.onTap,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingCompleted,
          onTapOutside: (v) {
            FocusManager.instance.primaryFocus?.unfocus();

            widget.onTapOutside?.call(v);
          },
          valueTransformer: widget.valueTransformer,
          inputFormatters: _inputFormatters,
          validator: _validator(context, errorText: widget.errorTextValidator),
          decoration: _decoration(context),
        ),
      ],
    );
  }

  List<TextInputFormatter>? get _inputFormatters {
    if (widget.keyboardType == TextInputType.number) {
      return [
        FilteringTextInputFormatter.digitsOnly,
        ...?widget.inputFormatters,
      ];
    }
    return widget.inputFormatters;
  }

  FormFieldValidator<String> _validator(
    BuildContext context, {
    String? errorText,
  }) {
    return FormBuilderValidators.compose([
      if (widget.isRequired)
        FormBuilderValidators.required(errorText: 'Required'),

      if (widget.isRequired && widget.keyboardType == TextInputType.number)
        (value) {
          if (value != null &&
              value.isNotEmpty &&
              !RegexValidation.isValidNumber(value)) {
            return errorText ?? 'Invalid number';
          }
          return null;
        },

      if (widget.keyboardType == TextInputType.phone)
        (value) {
          if (value != null &&
              value.isNotEmpty &&
              !RegexValidation.isValidPhoneNumber(value)) {
            return errorText ??
                'Phone number should start with 62 and have 10-13 digits';
          }

          return null;
        },

      ...widget.validators,
    ]);
  }

  Widget? _suffix() {
    if (widget.keyboardType == TextInputType.visiblePassword) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              _obscureText ? IconsaxPlusBold.eye : IconsaxPlusBold.eye_slash,
              color: !_obscureText
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return widget.suffixIcon == null
        ? null
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: widget.suffixIcon,
          );
  }

  InputDecoration _decoration(BuildContext context) {
    return (widget.decoration ?? InputDecoration()).copyWith(
      filled: widget.filled,
      fillColor: widget.enabled ? widget.fillColor : UrColors.softGray,
      prefixIcon: widget.prefixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: widget.prefixIcon,
            ),
      suffixIconConstraints: widget.isLoading
          ? BoxConstraints(
              minWidth: 50,
              minHeight: 20,
              maxWidth: 60,
              maxHeight: 20,
            )
          : widget.suffixIconConstraints,
      suffixIcon: widget.isLoading
          ? const FittedBox(child: CircularProgressIndicator())
          : _suffix(),
      hintText: widget.hintText,
      border: decoration.border,
      enabledBorder: decoration.enabledBorder,
      focusedBorder: decoration.focusedBorder,
      disabledBorder: decoration.disabledBorder,
      errorBorder: decoration.errorBorder,
      errorMaxLines: 2,
      focusedErrorBorder: decoration.focusedErrorBorder,
      hintMaxLines: widget.hintMaxLines,
      isDense: true,
      contentPadding:
          widget.contentPadding ??
          EdgeInsets.symmetric(
            horizontal: UrDimension.spacing / 1.5,
            vertical: UrDimension.spacing / 1.5,
          ),
      hintStyle: context.textTheme.bodyMedium?.copyWith(
        color: widget.enabled ? UrColors.darkGray : UrColors.gray,
      ),
      errorStyle: context.textTheme.bodySmall?.copyWith(
        color: widget.errorColor ?? Colors.red,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, this.isRequired, this.color, this.textStyle);

  final String text;
  final bool isRequired;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style:
              textStyle ?? context.textTheme.bodyMedium?.copyWith(color: color),
        ),
        if (isRequired)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              '*',
              style: (textStyle ?? context.textTheme.bodyMedium)?.copyWith(
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
