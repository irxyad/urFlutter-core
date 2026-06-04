import 'package:flutter/material.dart';

import '../components/loading_overlay.dart';
import '../models/loading_config.dart';

class OverlayManager {
  OverlayEntry? _currentOverlay;
  GlobalKey<NavigatorState>? _navigatorKey;

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  void show({
    required LoadingConfig config,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    final key = navigatorKey ?? _navigatorKey;

    if (key == null) {
      debugPrint('OverlayManager: Navigator key not set');
      return;
    }

    final navigatorState = key.currentState;
    if (navigatorState == null) {
      debugPrint('OverlayManager: Navigator state is null');
      return;
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

    navigatorState.overlay?.insert(_currentOverlay!);
  }

  void hide() {
    if (_currentOverlay != null) {
      _currentOverlay?.remove();
      _currentOverlay = null;
    }
  }

  bool get isShowing => _currentOverlay != null;

  void update(LoadingConfig config) {
    if (_currentOverlay != null) {
      _currentOverlay!.markNeedsBuild();
    }
  }
}
