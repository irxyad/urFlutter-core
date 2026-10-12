part of '../urbutton.dart';

class _Text extends StatelessWidget {
  const _Text({required this.props});

  final PropsButton props;

  @override
  Widget build(BuildContext context) {
    final foreground =
        props.foregroundColor ?? props.type.getStyle(context).foregroundColor;

    return SizedBox(
      height: props.height == 0
          ? null
          : props.height ?? UrDimension.buttonHeight,
      width: props.width,
      child: DecoratedBox(
        decoration: _decoration,
        child: _safeArea(
          child: TextButton(
            onPressed: props.enabled ? props.onPressed : null,
            style: _buttonStyle(context, foreground),
            child: Text(
              props.label ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: props.labelStyle,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration get _decoration => BoxDecoration(
    borderRadius: props.borderRadius ?? UrDimension.borderRadius,
    border: props.gradient != null
        ? Border.all(
            color: props.shadowColor ?? UrFlutterConfig.appColors.appPrimary,
            width: .5,
          )
        : null,
    boxShadow: [
      if (props.elevation != null)
        BoxShadow(
          color: props.shadowColor ?? UrColors.gray,
          blurRadius: props.elevation ?? 0,
          offset: const Offset(0, 4),
        ),
    ],
    gradient: props.gradient,
  );

  ButtonStyle _buttonStyle(BuildContext context, Color foreground) {
    return TextButton.styleFrom(
      foregroundColor: foreground,
      backgroundColor: props.gradient != null
          ? Colors.transparent
          : props.backgroundColor ??
                props.type.getStyle(context).backgroundColor,
      // backgroundBuilder: (context, states, child) {
      //   if (!props.useGradient) return child!;
      //   return Container(
      //     decoration: BoxDecoration(
      //       gradient:
      //           props.gradient ??
      //           AppGradients.getGradient(
      //             indexColor: 0,
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //           ),
      //     ),
      //     child: child,
      //   );
      // },
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
      disabledBackgroundColor: UrColors.softGray,
      disabledForegroundColor: UrColors.gray,
    );
  }

  Widget _safeArea({required Widget child}) =>
      props.useSafeArea ? SafeArea(child: child) : child;
}
