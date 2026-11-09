import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';

/// A segmented switch whose green pill slides to the chosen segment.
/// [labels] are listed right to left. [dark] is the navy version used on the
/// green header; the light version sits on the page background.
class SlidingSegments extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final bool dark;

  /// Width of each segment; null makes the switch fill the available width.
  final double? segmentWidth;

  const SlidingSegments({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.dark = false,
    this.segmentWidth,
  });

  @override
  Widget build(BuildContext context) {
    final n = labels.length;
    final x = n == 1 ? 0.0 : 1 - 2 * selected / (n - 1);

    final body = Stack(
      children: [
        AnimatedAlign(
          alignment: Alignment(x, 0),
          duration: AppTheme.medium,
          curve: Curves.easeOutBack,
          child: FractionallySizedBox(
            widthFactor: 1 / n,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(dark ? 20 : 15),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            for (var i = 0; i < n; i++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(i),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: AppTheme.fast,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: dark ? 16 : 17,
                        color: i == selected
                            ? (dark ? Colors.black : Colors.white)
                            : (dark ? Colors.white : AppTheme.secondaryColor),
                      ),
                      child: Text(labels[i], maxLines: 1),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );

    return Container(
      height: dark ? 50 : 52,
      width: segmentWidth == null ? null : segmentWidth! * n + 10,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: dark ? AppTheme.secondaryColor : Colors.white,
        borderRadius: BorderRadius.circular(dark ? 25 : 20),
        boxShadow: dark ? null : AppTheme.cardShadow,
      ),
      child: body,
    );
  }
}
