import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/khetma/models/khetma_part.dart';
import 'package:khetmti/features/khetma/models/part_state.dart';
import 'package:khetmti/shared/widgets/motion.dart';

/// Color, icon and wording of each part state, shared by the tiles and the
/// filter chips so both always agree.
extension PartStateStyle on PartState {
  Color get color => switch (this) {
        PartState.available => AppTheme.availableColor,
        PartState.mine => AppTheme.reservedColor,
        PartState.taken => AppTheme.takenColor,
        PartState.finishedByMe || PartState.finished => AppTheme.finishedColor,
      };

  IconData get icon => switch (this) {
        PartState.available => Icons.bookmark_border_rounded,
        PartState.mine => Icons.bookmark_rounded,
        PartState.taken => Icons.lock_outline_rounded,
        PartState.finishedByMe || PartState.finished => Icons.check_circle_rounded,
      };

  String label(String? reader) => switch (this) {
        PartState.available => 'متاحة للحجز',
        PartState.mine => 'محجوزة لك',
        PartState.taken => 'محجوزة لـ ${reader ?? 'مشارك'}',
        PartState.finishedByMe => 'أتممتَ قراءتها',
        PartState.finished => 'قرأها ${reader ?? 'مشارك'}',
      };
}

/// One sura or juz of a khatma: what it is, who has it, and the one or two
/// things the user can do with it, written out in words.
class PartTile extends StatelessWidget {
  final int number;
  final String title;
  final String? detail;
  final KhetmaPart part;
  final PartState state;
  final bool busy;
  final VoidCallback onOpen;
  final VoidCallback onReserve;
  final VoidCallback onFinish;
  final VoidCallback onRelease;
  final VoidCallback onUndo;

  const PartTile({
    super.key,
    required this.number,
    required this.title,
    this.detail,
    required this.part,
    required this.state,
    required this.busy,
    required this.onOpen,
    required this.onReserve,
    required this.onFinish,
    required this.onRelease,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final color = state.color;
    final highlighted = state == PartState.mine;

    return Pressable(
      onTap: onOpen,
      pressedScale: 0.98,
      child: AnimatedContainer(
        duration: AppTheme.medium,
        curve: AppTheme.curve,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFF5F8FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: highlighted
                ? color.withValues(alpha: 0.35)
                : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            _NumberBadge(number: number, state: state),
            const SizedBox(width: 12),
            Expanded(child: _info(color)),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: AppTheme.fast,
              transitionBuilder: (child, a) =>
                  ScaleTransition(scale: a, child: FadeTransition(opacity: a, child: child)),
              child: busy
                  ? const SizedBox(
                      key: ValueKey('busy'),
                      width: 40,
                      height: 40,
                      child: Padding(
                        padding: EdgeInsets.all(9),
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                    )
                  : _actions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
            if (detail != null) ...[
              const SizedBox(width: 6),
              Text(
                detail!,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: AppTheme.fast,
          child: Row(
            key: ValueKey(state),
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Icon(state.icon, size: 15, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  state.label(part.username),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    return switch (state) {
      PartState.available => _ActionPill(
          key: const ValueKey('reserve'),
          label: 'احجز',
          icon: Icons.bookmark_add_outlined,
          color: AppTheme.primaryColor,
          onTap: onReserve,
        ),
      PartState.mine => Row(
          key: const ValueKey('mine'),
          mainAxisSize: MainAxisSize.min,
          children: [
            _RoundAction(
              icon: Icons.close_rounded,
              tooltip: 'إلغاء الحجز',
              color: AppTheme.redishColor,
              onTap: onRelease,
            ),
            const SizedBox(width: 6),
            _ActionPill(
              label: 'أتممت',
              icon: Icons.check_rounded,
              color: AppTheme.finishedColor,
              filled: true,
              onTap: onFinish,
            ),
          ],
        ),
      PartState.finishedByMe => _ActionPill(
          key: const ValueKey('undo'),
          label: 'تراجع',
          icon: Icons.undo_rounded,
          color: AppTheme.textSecondary,
          onTap: onUndo,
        ),
      PartState.taken || PartState.finished => const Icon(
          key: ValueKey('none'),
          Icons.chevron_left_rounded,
          color: AppTheme.textMuted,
        ),
    };
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  final PartState state;

  const _NumberBadge({required this.number, required this.state});

  @override
  Widget build(BuildContext context) {
    final color = state.color;
    return AnimatedContainer(
      duration: AppTheme.medium,
      curve: AppTheme.curve,
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: state.isFinished ? color : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: AppTheme.fast,
          transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
          child: state.isFinished
              ? const Icon(Icons.check_rounded,
                  key: ValueKey('done'), color: Colors.white, size: 26)
              : Text(
                  toArabicDigits(number),
                  key: const ValueKey('number'),
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1.2,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionPill({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : color;
    return Pressable(
      onTap: onTap,
      pressedScale: 0.92,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(19),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: fg,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _RoundAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Pressable(
        onTap: onTap,
        pressedScale: 0.9,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
