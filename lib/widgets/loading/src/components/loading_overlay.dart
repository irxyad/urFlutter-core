import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/loading_config.dart';
import '../types/loading_type.dart';
import 'loading_indicator.dart';

class LoadingOverlay extends StatelessWidget {
  final LoadingConfig config;
  final VoidCallback? onDismiss;

  const LoadingOverlay({super.key, required this.config, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getBackgroundColor(context),
      child: GestureDetector(
        onTap: config.dismissible ? onDismiss : null,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            if (config.blurBackground)
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: config.blurAmount,
                  sigmaY: config.blurAmount,
                ),
                child: Container(color: Colors.transparent),
              ),

            Align(
              alignment: _getAlignment(),
              child: _buildLoadingContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (config.backgroundColor != null) {
      return config.backgroundColor!;
    }

    return Colors.black.withValues(alpha: config.blurBackground ? 0.3 : 0.8);
  }

  Alignment _getAlignment() {
    switch (config.position) {
      case LoadingPosition.top:
        return Alignment.topCenter;
      case LoadingPosition.bottom:
        return Alignment.bottomCenter;
      case LoadingPosition.center:
        return Alignment.center;
    }
  }

  Widget _buildLoadingContent(BuildContext context) {
    if (config.customWidget != null) {
      return config.customWidget!;
    }

    return Container(
      padding:
          config.padding ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(config.borderRadius ?? 12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (config.showMessage && config.message != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingIndicator(
            type: config.type,
            color:
                config.indicatorColor ??
                Theme.of(context).colorScheme.onSurface,
            size: config.size,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              config.message!,
              style: TextStyle(
                color:
                    config.textColor ?? Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }

    return LoadingIndicator(
      type: config.type,
      color: config.indicatorColor ?? Theme.of(context).colorScheme.onSurface,
      size: config.size,
    );
  }
}
