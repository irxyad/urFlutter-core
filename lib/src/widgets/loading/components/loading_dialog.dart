import 'package:flutter/material.dart';

import '../models/loading_config.dart';
import '../types/loading_type.dart';
import 'loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  final LoadingConfig config;

  const LoadingDialog({super.key, required this.config});

  EdgeInsetsGeometry get padding => config.isCompact
      ? EdgeInsets.symmetric(horizontal: 20, vertical: 10)
      : EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  static Future<T?> show<T>(BuildContext context, {LoadingConfig? config}) {
    final loadingConfig =
        config ??
        const LoadingConfig(
          type: LoadingType.newtonCradle,
          message: 'Loading...',
        );

    return showDialog<T>(
      context: context,
      barrierDismissible: loadingConfig.dismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => LoadingDialog(config: loadingConfig),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: config.dismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        constraints: config.isCompact ? BoxConstraints.tightFor() : null,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (config.customWidget != null) {
      return config.customWidget!;
    }

    return Container(
      padding: config.padding ?? padding,
      decoration: BoxDecoration(
        color: config.backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(config.borderRadius ?? 12),
      ),
      child: config.isCompact
          ? _compactMode(context)
          : Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                _loadingIndicator(context),
                if (config.showMessage && config.message != null) ...[
                  _message(context),
                ],
              ],
            ),
    );
  }

  Text _message(BuildContext context) {
    return Text(
      config.message!,
      style:
          config.messageStyle ??
          TextStyle(
            color: config.textColor ?? Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
      textAlign: TextAlign.center,
    );
  }

  LoadingIndicator _loadingIndicator(
    BuildContext context, {
    bool isCompact = false,
  }) {
    final compactSize = 25.0;

    return LoadingIndicator(
      type: config.type,
      color: config.indicatorColor ?? Theme.of(context).colorScheme.primary,
      size: isCompact ? compactSize : config.size,
      customIndicator: config.customIndicator != null
          ? ConstrainedBox(
              constraints: isCompact
                  ? BoxConstraints(
                      maxHeight: compactSize,
                      maxWidth: compactSize,
                    )
                  : const BoxConstraints(),
              child: config.customIndicator,
            )
          : null,
    );
  }

  Widget _compactMode(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        _loadingIndicator(context, isCompact: true),
        if (config.showMessage && config.message != null) ...[
          _message(context),
        ],
      ],
    );
  }
}
