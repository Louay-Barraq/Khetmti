import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/shared/widgets/motion.dart';

/// The green pill button of the app. While [loading] it shows a spinner and
/// ignores taps, so an action cannot be sent twice.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Pressable(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: AppTheme.fast,
        height: 56,
        decoration: BoxDecoration(
          color: enabled ? color : color.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: enabled ? 0.35 : 0.15),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: AppTheme.fast,
            child: loading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    key: const ValueKey('label'),
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
