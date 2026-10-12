import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

enum TransitionType {
  slideRight,
  scaleAndFade,
  slideUp,
  rotateAndFade,
  sharedAxis,
  fadeThrough,
  parallaxSlide,
  elasticScale,
  blurFade,
  platformDefault,
}

class RouteTransitions {
  RouteTransitions._();

  // Slide dari kanan (seperti navigasi iOS)
  static CustomTransitionPage<T> slideRight<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  // Scale dengan fade (smooth dan modern)
  static CustomTransitionPage<T> scaleAndFade<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        const curve = Curves.easeInOutCubic;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1).animate(curvedAnimation),
          child: FadeTransition(opacity: curvedAnimation, child: child),
        );
      },
    );
  }

  // Slide dari bawah (seperti modal)
  static CustomTransitionPage<T> slideUp<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  // Rotation dengan fade (unik dan halus)
  static CustomTransitionPage<T> rotateAndFade<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, _, child) {
        const curve = Curves.easeInOutCubic;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: RotationTransition(
            turns: Tween<double>(begin: -0.02, end: 0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  // Shared axis transition (Material Design 3)
  static CustomTransitionPage<T> sharedAxis<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const curve = Curves.fastEaseInToSlowEaseOut;
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: curve)),
            child: child,
          ),
        );
      },
    );
  }

  // Fade through (Material Design 3 - halaman lama fade out dulu, baru halaman baru fade in)
  static CustomTransitionPage<T> fadeThrough<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final fadeIn = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1, curve: Curves.easeOut),
        );
        final fadeOut = CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0, 0.3, curve: Curves.easeIn),
        );
        final scaleIn = Tween<double>(
          begin: 0.92,
          end: 1,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(fadeOut),
          child: FadeTransition(
            opacity: fadeIn,
            child: ScaleTransition(scale: scaleIn, child: child),
          ),
        );
      },
    );
  }

  // Parallax slide (halaman baru masuk penuh, halaman lama bergeser pelan di belakang)
  static CustomTransitionPage<T> parallaxSlide<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        final incoming = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve));
        final outgoing = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.25, 0),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: curve));
        return SlideTransition(
          position: outgoing,
          child: SlideTransition(
            position: incoming,
            child: DecoratedBoxTransition(
              decoration: DecorationTween(
                begin: const BoxDecoration(boxShadow: []),
                end: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Color(0x33000000), blurRadius: 24),
                  ],
                ),
              ).animate(animation),
              child: child,
            ),
          ),
        );
      },
    );
  }

  // Elastic scale (masuk dengan sedikit overshoot, terasa hidup tanpa berlebihan)
  static CustomTransitionPage<T> elasticScale<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, _, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 0.6, curve: Curves.easeOut),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  // Blur fade (halaman baru masuk dari blur ke fokus, terasa premium)
  static CustomTransitionPage<T> blurFade<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, _, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: (1 - curvedAnimation.value) * 8,
              sigmaY: (1 - curvedAnimation.value) * 8,
            ),
            child: child,
          ),
        );
      },
    );
  }

  // Adaptive - pilih transisi berdasarkan type
  static Page<T> adaptive<T>({
    required GoRouterState state,
    required Widget child,
    TransitionType type = TransitionType.elasticScale,
  }) {
    switch (type) {
      case TransitionType.slideRight:
        return slideRight(state: state, child: child);
      case TransitionType.scaleAndFade:
        return scaleAndFade(state: state, child: child);
      case TransitionType.slideUp:
        return slideUp(state: state, child: child);
      case TransitionType.rotateAndFade:
        return rotateAndFade(state: state, child: child);
      case TransitionType.sharedAxis:
        return sharedAxis(state: state, child: child);
      case TransitionType.fadeThrough:
        return fadeThrough(state: state, child: child);
      case TransitionType.parallaxSlide:
        return parallaxSlide(state: state, child: child);
      case TransitionType.elasticScale:
        return elasticScale(state: state, child: child);
      case TransitionType.blurFade:
        return blurFade(state: state, child: child);
      case TransitionType.platformDefault:
        // iOS menggunakan CupertinoPage, Android menggunakan sharedAxis
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          return CupertinoPage<T>(key: state.pageKey, child: child);
        }
        return sharedAxis(state: state, child: child);
    }
  }
}
