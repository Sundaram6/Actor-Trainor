import 'package:flutter/material.dart';

class BreathingGuide extends StatefulWidget {
  final int? durationSeconds;
  final bool isPaused;

  const BreathingGuide({
    super.key,
    this.durationSeconds,
    this.isPaused = false,
  });

  @override
  State<BreathingGuide> createState() => _BreathingGuideState();
}

class _BreathingGuideState extends State<BreathingGuide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    if (!widget.isPaused) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant BreathingGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final reduceMotion = mediaQuery.disableAnimations;

    if (reduceMotion) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
              border: Border.all(color: const Color(0xFFD4AF37), width: 2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'BREATHE',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Let the circle guide your breath',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        double sizeRatio;
        String label;

        if (t < 0.3333) {
          // Inhale (0.0 to 0.3333 -> 4 seconds)
          sizeRatio = t / 0.3333;
          label = 'INHALE';
        } else if (t < 0.5000) {
          // Hold at max (0.3333 to 0.5000 -> 2 seconds)
          sizeRatio = 1.0;
          label = 'HOLD';
        } else if (t < 0.8333) {
          // Exhale (0.5000 to 0.8333 -> 4 seconds)
          sizeRatio = 1.0 - ((t - 0.5000) / 0.3333);
          label = 'EXHALE';
        } else {
          // Hold at min (0.8333 to 1.0000 -> 2 seconds)
          sizeRatio = 0.0;
          label = 'HOLD';
        }

        final currentSize = 120.0 + (sizeRatio * 100.0); // 120px to 220px

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 230,
              width: 230,
              child: Center(
                child: Container(
                  width: currentSize,
                  height: currentSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD4AF37).withValues(
                      alpha: 0.08 + (sizeRatio * 0.14),
                    ),
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withValues(
                          alpha: 0.25 * sizeRatio,
                        ),
                        blurRadius: 24 * sizeRatio,
                        spreadRadius: 4 * sizeRatio,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Let the circle guide your breath',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
