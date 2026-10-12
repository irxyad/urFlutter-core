import 'package:flutter/material.dart';
import 'package:urflutter_core/src/widgets/loading/loading.dart';

class LoadingBackGuard extends StatelessWidget {
  const LoadingBackGuard({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: OverlayManager.isLoading,
      child: child,
      builder: (_, isLoading, child) =>
          PopScope(canPop: !isLoading, child: child!),
    );
  }
}
