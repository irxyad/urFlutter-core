import 'package:flutter/material.dart';

import 'models/radio_option.dart';

class UrRadioGroup<T> extends StatelessWidget {
  const UrRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.axis = Axis.horizontal,
    this.spacing = 12,
    this.enabled = true,
  });

  final List<UrRadioOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final Axis axis;
  final double spacing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final children = options
        .map(
          (option) => _UrRadioCard<T>(
            option: option,
            selected: option.value == value,
            enabled: enabled,
            onTap: () => onChanged(option.value),
          ),
        )
        .toList();

    if (axis == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i != 0) SizedBox(height: spacing),
            children[i],
          ],
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i != 0) SizedBox(width: spacing),
            Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }
}

class _UrRadioCard<T> extends StatelessWidget {
  const _UrRadioCard({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final UrRadioOption<T> option;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final borderColor = selected ? scheme.primary : scheme.outlineVariant;
    final bgColor = selected
        ? scheme.primary.withValues(alpha: 0.08)
        : scheme.surface;
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
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 1.6 : 1),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: enabled ? onTap : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
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
                        style: theme.textTheme.bodyMedium?.copyWith(
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
