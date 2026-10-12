part of '../urbutton.dart';

class _TextIcon extends StatelessWidget {
  const _TextIcon({required this.props});

  final PropsIconButton props;

  @override
  Widget build(BuildContext context) {
    final foreground =
        props.foregroundColor ?? props.type.getStyle(context).foregroundColor;

    final content = props.isRow
        ? Row(
            spacing: props.spacing ?? 6,
            mainAxisSize: props.mainAxisSize,
            mainAxisAlignment:
                props.mainAxisAlignment ?? MainAxisAlignment.center,
            crossAxisAlignment:
                props.crossAxisAlignment ?? CrossAxisAlignment.center,
            children: _children(context, foreground),
          )
        : Column(
            spacing: props.spacing ?? 4,
            mainAxisSize: props.mainAxisSize,
            mainAxisAlignment:
                props.mainAxisAlignment ?? MainAxisAlignment.center,
            crossAxisAlignment:
                props.crossAxisAlignment ?? CrossAxisAlignment.center,
            children: _children(context, foreground),
          );

    return SizedBox(
      key: key,
      height: props.height,
      width: props.width,
      child: DecoratedBox(
        decoration: _decoration,
        child: _safeArea(
          child: TextButton(
            onPressed: props.enabled ? props.onPressed : null,
            style: _buttonStyle(context, foreground),
            child: content,
          ),
        ),
      ),
    );
  }

  List<Widget> _children(BuildContext context, Color foreground) {
    final items = <Widget>[
      _icon(foreground),
      if (props.label != null)
        Text(
          props.label!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              props.labelStyle ??
              context.textTheme.labelLarge!.copyWith(
                color: !props.enabled ? UrColors.darkGray : foreground,
              ),
        ),
    ];

    return props.isReversed ? items.reversed.toList() : items;
  }

  Widget _icon(Color foreground) {
    if (props.isLoading) {
      return SizedBox(
        height: props.iconSize ?? 20,
        width: props.iconSize ?? 20,
        child: const CircularProgressIndicator.adaptive(),
      );
    }

    if (props.iconWidget != null) return props.iconWidget!;

    if (props.iconSVG != null) {
      return SvgPicture.asset(
        props.iconSVG!,
        height: props.iconSize ?? 20,
        width: props.iconSize ?? 20,
        colorFilter: ColorFilter.mode(
          !props.enabled ? UrColors.darkGray : props.iconColor ?? foreground,
          BlendMode.srcIn,
        ),
      );
    }

    if (props.icon != null) {
      return Icon(
        props.icon,
        size: props.iconSize ?? 20,
        color: !props.enabled
            ? UrColors.darkGray
            : props.iconColor ?? foreground,
      );
    }

    return const SizedBox.shrink();
  }

  BoxDecoration get _decoration => BoxDecoration(
    gradient: props.gradient,
    borderRadius: props.borderRadius ?? UrDimension.borderRadius,
  );

  ButtonStyle _buttonStyle(BuildContext context, Color foreground) {
    return TextButton.styleFrom(
      foregroundColor: foreground,
      backgroundColor: props.gradient != null
          ? Colors.transparent
          : props.backgroundColor ??
                props.type.getStyle(context).backgroundColor,
      padding:
          props.padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      textStyle: props.labelStyle,
      shape: RoundedRectangleBorder(
        borderRadius: props.borderRadius ?? UrDimension.borderRadius,
        side: props.type == AppButtonType.outline
            ? BorderSide(color: foreground)
            : BorderSide.none,
      ),
      disabledBackgroundColor: UrColors.gray,
      disabledForegroundColor: UrColors.darkGray,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _safeArea({required Widget child}) =>
      props.useSafeArea ? SafeArea(child: child) : child;
}
