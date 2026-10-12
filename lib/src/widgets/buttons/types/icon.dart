part of '../urbutton.dart';

class _Icon extends StatelessWidget {
  const _Icon({required this.props});

  final PropsIconButton props;

  @override
  Widget build(BuildContext context) {
    final foreground =
        props.foregroundColor ?? props.type.getStyle(context).foregroundColor;

    final background = props.gradient != null
        ? Colors.transparent
        : props.backgroundColor ?? props.type.getStyle(context).backgroundColor;

    final borderRadius = props.borderRadius ?? UrDimension.borderRadius;

    Widget button = IconButton(
      onPressed: props.enabled ? props.onPressed : null,
      iconSize: props.iconSize ?? 22,
      icon: _icon(props.iconColor ?? foreground),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(background),
        foregroundColor: WidgetStatePropertyAll(foreground),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        side: props.type == AppButtonType.outline
            ? WidgetStatePropertyAll(BorderSide(color: foreground))
            : null,
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? foreground.withValues(alpha: .12)
              : null,
        ),
        // visualDensity: VisualDensity.compact,
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    if (props.useSafeArea) {
      button = SafeArea(child: button);
    }

    Widget sizedBox({required Widget child}) => SizedBox(
      height: props.height == 0
          ? null
          : props.height ?? UrDimension.buttonHeight,
      width: props.width ?? UrDimension.buttonHeight,
      child: child,
    );

    Widget tooltip({required Widget child}) {
      final widget = sizedBox(child: child);

      return props.tooltip != null
          ? Tooltip(message: props.tooltip, child: widget)
          : widget;
    }

    return tooltip(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: props.gradient,
          borderRadius: borderRadius,
        ),
        child: button,
      ),
    );
  }

  Widget _icon(Color color) {
    if (props.iconWidget != null) {
      return props.iconWidget!;
    }

    if (props.icon != null) {
      return Icon(props.icon, color: color);
    }

    if (props.iconSVG != null) {
      return Padding(
        padding: EdgeInsets.all(props.paddingIcon ?? 0),
        child: SvgPicture.asset(
          props.iconSVG!,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          height: props.iconSize,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
