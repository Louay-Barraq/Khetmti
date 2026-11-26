import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/l10n/l10n.dart';

class FriendComponent extends StatelessWidget {
  final String username;
  final int level;
  final DateTime? lastSeen;
  final Widget? trailing;

  /// Replaces the "last seen" line when given.
  final String? subtitle;

  const FriendComponent({
    required this.username,
    required this.level,
    this.lastSeen,
    this.trailing,
    this.subtitle,
    super.key,
  });

  String _formatLastSeen(DateTime? date) {
    if (date == null) return tr.unknown;

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return tr.onlineNow;
    } else if (difference.inMinutes < 60) {
      return tr.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return tr.hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return tr.daysAgo(difference.inDays);
    } else {
      return DateFormat('yyyy/MM/dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Friend Avatar
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF1F5F9),
                  ),
                  child: Center(
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : "U",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTheme.font,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle ?? tr.lastSeen(_formatLastSeen(lastSeen)),
                        style: TextStyle(
                          fontFamily: AppTheme.font,
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Level Badge or Trailing
                if (trailing != null)
                  trailing!
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tr.levelShort('$level'),
                      style: TextStyle(
                        fontFamily: AppTheme.font,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
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
