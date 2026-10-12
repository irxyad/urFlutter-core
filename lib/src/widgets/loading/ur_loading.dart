import 'package:flutter/material.dart';

import 'managers/loading_manager.dart';
import 'models/loading_config.dart';

class UrLoading {
  const UrLoading._();

  static Future<void> show({LoadingConfig? config}) =>
      LoadingManager.instance.show(config: config);

  static Future<void> hide() => LoadingManager.instance.hide();

  static Future<void> toggle({bool show = true, LoadingConfig? config}) =>
      LoadingManager.instance.toggle(show: show, config: config);

  static Future<T> withLoading<T>({
    required Future<T> Function() function,
    LoadingConfig? config,
  }) => LoadingManager.instance.withLoading(function: function, config: config);

  static Future<void> showCircular({String? message}) =>
      LoadingManager.instance.showCircular(message: message);

  static Future<void> showDots({String? message}) =>
      LoadingManager.instance.showDots(message: message);

  static Future<void> showPulse({String? message}) =>
      LoadingManager.instance.showPulse(message: message);

  static Future<void> showCustom({
    required Widget widget,
    bool dismissible = false,
  }) => LoadingManager.instance.showCustom(
    widget: widget,
    dismissible: dismissible,
  );

  static bool get isShowing => LoadingManager.instance.isShowing;

  static void initialize(
    GlobalKey<NavigatorState> navigatorKey, {
    LoadingConfig? config,
  }) => LoadingManager.instance.initialize(navigatorKey, config);
}
