import 'package:flutter/material.dart';

import '../models/loading_config.dart';
import '../types/loading_type.dart';
import 'overlay_manager.dart';

class LoadingManager {
  LoadingManager._();

  static LoadingManager get instance => _instance;
  static final LoadingManager _instance = LoadingManager._();

  final OverlayManager _overlayManager = OverlayManager();

  DateTime? _showTime;
  LoadingConfig? _currentConfig;

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _overlayManager.initialize(navigatorKey);
  }

  Future<void> show({LoadingConfig? config, BuildContext? context}) async {
    final loadingConfig = config ?? _getDefaultConfig(context);
    _currentConfig = loadingConfig;
    _showTime = DateTime.now();

    _overlayManager.show(config: loadingConfig);
  }

  Future<void> hide() async {
    if (_currentConfig?.minDuration != null && _showTime != null) {
      final elapsed = DateTime.now().difference(_showTime!);
      final remaining = _currentConfig!.minDuration! - elapsed;

      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    }

    _overlayManager.hide();
    _showTime = null;
    _currentConfig = null;
  }

  Future<void> toggle({bool show = true, LoadingConfig? config}) async {
    if (show) {
      await this.show(config: config);
    } else {
      await hide();
    }
  }

  bool get isShowing => _overlayManager.isShowing;

  Future<T> withLoading<T>({
    required Future<T> Function() function,
    LoadingConfig? config,
  }) async {
    try {
      await show(config: config);
      return await function();
    } finally {
      await hide();
    }
  }

  LoadingConfig _getDefaultConfig(BuildContext? context) {
    return LoadingConfig(
      type: LoadingType.newtonCradle,
      message: 'Loading...',
      showMessage: true,
      minDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> showCircular({String? message}) => show(
    config: LoadingConfig(
      type: LoadingType.circular,
      message: message,
      showMessage: message != null,
    ),
  );

  Future<void> showDots({String? message}) => show(
    config: LoadingConfig(
      type: LoadingType.threeDots,
      message: message,
      showMessage: message != null,
    ),
  );

  Future<void> showPulse({String? message}) => show(
    config: LoadingConfig(
      type: LoadingType.pulse,
      message: message,
      showMessage: message != null,
    ),
  );

  Future<void> showCustom({required Widget widget, bool dismissible = false}) =>
      show(
        config: LoadingConfig(customWidget: widget, dismissible: dismissible),
      );

  void reset() {
    _overlayManager.hide();
    _showTime = null;
    _currentConfig = null;
  }
}
