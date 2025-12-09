import 'package:flutter/material.dart';

class PingingRedDotIcon extends StatefulWidget {
  const PingingRedDotIcon({super.key});

  @override
  State<PingingRedDotIcon> createState() => _PingingRedDotIconState();
}

class _PingingRedDotIconState extends State<PingingRedDotIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const double _maxPingSize = 20.0;
  static const double _dotSize = 8.0;

  static const Color _pingColor = Colors.red;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double value = _animation.value;

        final double pingSize = _dotSize + (_maxPingSize - _dotSize) * value;

        final double opacity = 0.8 - (0.8 * value);

        return SizedBox(
          width: 20,
          height: 20,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ------------------------------------
                // 1. THE EXPANDING PING CIRCLE
                // ------------------------------------
                Opacity(
                  opacity: opacity,
                  child: Container(
                    width: pingSize,
                    height: pingSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Use the primary color with a high transparency for the pulse
                      color: _pingColor.withOpacity(0.5),
                    ),
                  ),
                ),

                // ------------------------------------
                // 2. THE FIXED RED DOT MARKER
                // ------------------------------------
                Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _pingColor, // Solid red marker
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
