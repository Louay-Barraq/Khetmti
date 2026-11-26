import 'package:flutter/material.dart';
import 'package:khetmti/shared/widgets/sliding_segments.dart';
import 'package:khetmti/l10n/l10n.dart';

class StatisticsToggle extends StatefulWidget {
  final void Function(String) onValuesChanged;

  const StatisticsToggle({super.key, required this.onValuesChanged});

  @override
  State<StatisticsToggle> createState() => _StatisticsToggleState();
}

class _StatisticsToggleState extends State<StatisticsToggle> {
  static const _values = ['Surahs', 'Juzus'];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SlidingSegments(
      labels: [tr.surahs, tr.juzs],
      selected: _index,
      segmentWidth: 110,
      onChanged: (i) {
        if (i == _index) return;
        setState(() => _index = i);
        widget.onValuesChanged(_values[i]);
      },
    );
  }
}
