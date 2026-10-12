import 'package:flutter/material.dart';

import '../components/loading_overlay.dart';
import '../models/loading_config.dart';

class OverlayManager {
  OverlayEntry? _currentOverlay;
  GlobalKey<NavigatorState>? _navigatorKey;

  static final isLoading = ValueNotifier<bool>(false);

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  void show({
    required LoadingConfig config,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    final key = navigatorKey ?? _navigatorKey;

    if (key == null) {
      throw Exception('OverlayManager: Navigator key not set');
    }

    final navigatorState = key.currentState;
    if (navigatorState == null) {
      throw Exception('OverlayManager: Navigator state is null');
    }

    if (_currentOverlay != null) {
      hide();
    }

    _currentOverlay = OverlayEntry(
      builder: (context) => LoadingOverlay(
        config: config,
        onDismiss: config.dismissible ? hide : null,
      ),
    );

    isLoading.value = true;
    navigatorState.overlay?.insert(_currentOverlay!);
  }

  void hide() {
    if (_currentOverlay != null) {
      _currentOverlay?.remove();
      _currentOverlay = null;
      isLoading.value = false;
    }
  }

  bool get isShowing => _currentOverlay != null;

  void update(LoadingConfig config) {
    if (_currentOverlay != null) {
      _currentOverlay!.markNeedsBuild();
    }
  }
}
