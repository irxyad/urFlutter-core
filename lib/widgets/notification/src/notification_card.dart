import 'package:flutter/material.dart';

import '../../../core/extensions/animations/animation_widget.dart';

class NotificationCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onClose;
  final double offsetY;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double iconSize;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const NotificationCard({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.message,
    required this.onClose,
    this.offsetY = 0,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.iconSize = 16,
    this.titleStyle,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Padding(
        padding: padding,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [_buildTitleChip(context), _buildCloseButton()],
                    ),
                    const SizedBox(height: 8),
                    _buildMessage(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleChip(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ).copyWith(left: 7),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, color: backgroundColor, size: iconSize).animationPulse,
          const SizedBox(width: 5),
          Text(
            title,
            style:
                titleStyle ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: backgroundColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(Icons.close, color: backgroundColor, size: 20),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      message,
      style:
          messageStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
    );
  }
}
