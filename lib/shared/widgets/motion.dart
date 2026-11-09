import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';

/// Shrinks its child slightly while pressed, so taps feel physical.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool down) {
    if (widget.onTap != null && down != _down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1,
        duration: AppTheme.fast,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Fades and slides its child in once, when it first appears. Pass [index]
/// to stagger items of a list; only the first few are delayed so long lists
/// do not make the user wait.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int index;
  final double offset;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.offset = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final delay = 40 * index.clamp(0, 8);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + delay),
      curve: Interval(delay / (380 + delay), 1, curve: AppTheme.curve),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, offset * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// Cross-fades (with a small vertical shift) between children whenever the
/// child's key changes: loading → content, one tab → another, etc.
class SmoothSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const SmoothSwitcher({
    super.key,
    required this.child,
    this.duration = AppTheme.medium,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: AppTheme.curve,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [...previous, if (current != null) current],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.02), end: Offset.zero)
              .animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
