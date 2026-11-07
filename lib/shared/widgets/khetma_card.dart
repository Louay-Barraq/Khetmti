import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:khetmti/core/theme/app_theme.dart';

class KhetmaComponent extends StatelessWidget {
  final String title;
  final int participantsCount;
  final double progress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final VoidCallback? onTap;

  const KhetmaComponent({
    required this.title,
    required this.participantsCount,
    required this.progress,
    this.createdAt,
    this.updatedAt,
    this.onTap,
    super.key,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return "غير معروف";
    return intl.DateFormat('yyyy/MM/dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    bool isFinished = progress >= 1.0;
    String dateLabel = isFinished ? "تاريخ الإكمال: " : "تاريخ البدء: ";
    String dateValue = _formatDate(isFinished ? updatedAt : createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                // Circular Progress Indicator
                CircularPercentIndicator(
                  radius: 35.0,
                  lineWidth: 6.0,
                  percent: progress,
                  center: Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: const Color(0xFFF1F5F9),
                  progressColor: progress >= 1.0 ? Colors.green : AppTheme.primaryColor,
                ),
                const SizedBox(width: 20),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        "ختمة لفائدة $title",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            // Participants Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "$participantsCount مشاركين",
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Amiri',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Date
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$dateLabel$dateValue",
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                                fontFamily: 'Amiri',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
