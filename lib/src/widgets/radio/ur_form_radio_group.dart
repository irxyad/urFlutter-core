import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:urflutter_core/src/extensions/context_extension.dart';
import 'package:urflutter_core/src/styles/colors.dart';
import 'package:urflutter_core/src/utils/app_dimension.dart';

import 'models/radio_option.dart';

class UrFormRadioGroup<T> extends StatelessWidget {
  const UrFormRadioGroup({
    required this.name,
    required this.options,
    super.key,
    this.label,
    this.initialValue,
    this.enabled = true,
    this.isRequired = true,
    this.showRequiredAsterisk = true,
    this.requiredErrorText,
    this.axis = Axis.horizontal,
    this.spacing,
    this.gapTitle,
    this.labelStyle,
    this.labelColor,
    this.errorColor,
    this.borderRadius,
    this.onChanged,
    this.validators = const [],
    this.valueTransformer,
    this.focusNode,
  });

  final String name;
  final List<UrRadioOption<T>> options;
  final String? label;
  final T? initialValue;

  final bool enabled;
  final bool isRequired;
  final bool showRequiredAsterisk;
  final String? requiredErrorText;

  final Axis axis;
  final double? spacing;
  final double? gapTitle;

  final TextStyle? labelStyle;
  final Color? labelColor;
  final Color? errorColor;
  final BorderRadius? borderRadius;

  final ValueChanged<T?>? onChanged;
  final List<FormFieldValidator<T>> validators;
  final ValueTransformer<T?>? valueTransformer;
  final FocusNode? focusNode;

  FormFieldValidator<T> get _validator => (value) {
    if (isRequired && value == null) {
      return requiredErrorText ?? 'Required';
    }

    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }

    return null;
  };

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? UrDimension.spacing;
    final errorClr = errorColor ?? UrColors.red;

    return FormBuilderFieldDecoration<T>(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      focusNode: focusNode,
      onChanged: onChanged,
      valueTransformer: valueTransformer,
      validator: _validator,
      builder: (field) {
        final cards = [
          for (final option in options)
            _UrRadioCard<T>(
              option: option,
              selected: option.value == field.value,
              enabled: enabled,
              hasError: field.hasError,
              errorColor: errorClr,
              borderRadius: borderRadius ?? BorderRadius.circular(14),
              onTap: () => field.didChange(option.value),
            ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: gapTitle ?? UrDimension.spacing / 3,
          children: [
            if (label != null)
              _Label(
                label!,
                isRequired && showRequiredAsterisk,
                enabled ? labelColor : UrColors.darkGray,
                labelStyle,
              ),
            if (axis == Axis.vertical)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: gap,
                children: cards,
              )
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: gap,
                  children: [for (final card in cards) Expanded(child: card)],
                ),
              ),
            if (field.hasError)
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: Row(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error, color: errorClr, size: 16),
                    Expanded(
                      child: Text(
                        field.errorText ?? '',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: errorClr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _UrRadioCard<T> extends StatelessWidget {
  const _UrRadioCard({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.hasError,
    required this.errorColor,
    required this.borderRadius,
    required this.onTap,
  });

  final UrRadioOption<T> option;
  final bool selected;
  final bool enabled;
  final bool hasError;
  final Color errorColor;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    final borderColor = hasError && !selected
        ? errorColor
        : selected
        ? scheme.primary
        : scheme.outlineVariant;

    final fgColor = selected ? scheme.primary : scheme.onSurfaceVariant;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      label: option.label,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: 0.08)
                : scheme.surface,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: selected ? 1.6 : 1),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: enabled ? onTap : null,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UrDimension.spacing / 1.5,
                  vertical: UrDimension.spacing / 1.5,
                ),
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: 22,
                        color: option.iconColor ?? fgColor,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        option.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: selected ? scheme.primary : scheme.onSurface,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: selected
                          ? Icon(
                              Icons.check_circle_rounded,
                              key: const ValueKey('on'),
                              size: 22,
                              color: scheme.primary,
                            )
                          : Icon(
                              Icons.radio_button_unchecked_rounded,
                              key: const ValueKey('off'),
                              size: 22,
                              color: scheme.outline,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
