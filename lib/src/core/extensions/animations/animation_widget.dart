import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AnimationWidgetExt on Widget {
  // animationPulse
  Widget get animationPulse => animate(onPlay: (c) => c.repeat())
      .scale(
        begin: const Offset(0.88, 0.88),
        end: const Offset(1.06, 1.06),
        duration: 700.ms,
        curve: Curves.easeInOut,
      )
      .fade(begin: 0.7, end: 1.0, duration: 700.ms)
      .then()
      .scale(
        begin: const Offset(1.06, 1.06),
        end: const Offset(0.88, 0.88),
        duration: 700.ms,
        curve: Curves.easeInOut,
      )
      .fade(begin: 1.0, end: 0.7, duration: 700.ms);

  // animationPulseShimmer
  Widget get animationPulseShimmer => animate(onPlay: (c) => c.repeat())
      .shimmer(duration: 1800.ms, color: Colors.white54, angle: 0.3)
      .then(delay: 400.ms)
      .shake(
        hz: 1.5,
        offset: const Offset(2, 0),
        rotation: 0,
        duration: 500.ms,
        curve: Curves.easeInOut,
      );

  // animationFadeRotate
  Widget get animationFadeRotate => animate(onPlay: (c) => c.repeat())
      .fadeIn(duration: 900.ms, curve: Curves.easeOut)
      .rotate(
        begin: -0.015,
        end: 0.015,
        duration: 1800.ms,
        curve: Curves.easeInOut,
      )
      .then()
      .fadeOut(duration: 900.ms, curve: Curves.easeIn);

  // animationFloat
  Widget get animationFloat => animate(
    onPlay: (c) => c.repeat(reverse: true),
  ).moveY(begin: 0, end: -10, duration: 2000.ms, curve: Curves.easeInOut);

  // animationBreathe
  Widget get animationBreathe => animate(onPlay: (c) => c.repeat(reverse: true))
      .scale(
        begin: const Offset(0.96, 0.96),
        end: const Offset(1.04, 1.04),
        duration: 2800.ms,
        curve: Curves.easeInOut,
      )
      .fade(begin: 0.75, end: 1.0, duration: 2800.ms);

  // animationBounce
  Widget get animationBounce => animate(onPlay: (c) => c.repeat())
      .moveY(begin: 0, end: -14, duration: 350.ms, curve: Curves.easeOut)
      .then()
      .moveY(begin: -14, end: 0, duration: 350.ms, curve: Curves.bounceOut)
      .then(delay: 800.ms);

  // animationHeartbeat
  Widget get animationHeartbeat => animate(onPlay: (c) => c.repeat())
      .scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.22, 1.22),
        duration: 160.ms,
        curve: Curves.easeOut,
      )
      .then()
      .scale(
        begin: const Offset(1.22, 1.22),
        end: const Offset(0.96, 0.96),
        duration: 160.ms,
        curve: Curves.easeIn,
      )
      .then()
      .scale(
        begin: const Offset(0.96, 0.96),
        end: const Offset(1.14, 1.14),
        duration: 140.ms,
        curve: Curves.easeOut,
      )
      .then()
      .scale(
        begin: const Offset(1.14, 1.14),
        end: const Offset(1.0, 1.0),
        duration: 140.ms,
        curve: Curves.easeIn,
      )
      .then(delay: 700.ms);

  // animationRubberBand
  Widget get animationRubberBand => animate(onPlay: (c) => c.repeat())
      .scaleXY(begin: 1.0, end: 1.22, duration: 120.ms, curve: Curves.easeOut)
      .then()
      .scaleXY(
        begin: 0.88,
        end: 1.06,
        duration: 160.ms,
        curve: Curves.easeInOut,
      )
      .then()
      .scaleXY(
        begin: 1.06,
        end: 1.0,
        duration: 200.ms,
        curve: Curves.elasticOut,
      )
      .then(delay: 1200.ms);

  // animationSpin
  Widget get animationSpin => animate(
    onPlay: (c) => c.repeat(),
  ).rotate(begin: 0, end: 1, duration: 1200.ms, curve: Curves.linear);

  // animationSpinEase
  Widget get animationSpinEase => animate(
    onPlay: (c) => c.repeat(),
  ).rotate(begin: 0, end: 1, duration: 2000.ms, curve: Curves.easeInOut);

  // animationBlink
  Widget get animationBlink => animate(onPlay: (c) => c.repeat())
      .fadeOut(duration: 500.ms, curve: Curves.easeInOut)
      .then(delay: 200.ms)
      .fadeIn(duration: 500.ms, curve: Curves.easeInOut)
      .then(delay: 500.ms);

  // animationShakeError
  Widget get animationShakeError => animate(onPlay: (c) => c.repeat())
      .shake(
        hz: 4,
        offset: const Offset(6, 0),
        rotation: 0,
        duration: 600.ms,
        curve: Curves.easeInOut,
      )
      .then(delay: 2000.ms);

  // animationSlideUp
  Widget get animationSlideUp => animate()
      .moveY(begin: 24, end: 0, duration: 500.ms, curve: Curves.easeOutCubic)
      .fadeIn(duration: 400.ms, curve: Curves.easeOut);

  // animationMorph
  Widget get animationMorph => animate(onPlay: (c) => c.repeat(reverse: true))
      .scale(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1.05, 1.05),
        duration: 2200.ms,
        curve: Curves.easeInOut,
      )
      .rotate(
        begin: -0.03,
        end: 0.03,
        duration: 2200.ms,
        curve: Curves.easeInOut,
      );
}
