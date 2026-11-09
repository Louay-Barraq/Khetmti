import 'package:flutter/material.dart';
import 'package:khetmti/shared/widgets/sliding_segments.dart';

class StateSwitch extends StatefulWidget {
  final void Function(String) onSwitchChanged;

  const StateSwitch({super.key, required this.onSwitchChanged});

  @override
  State<StateSwitch> createState() => _StateSwitchState();
}

class _StateSwitchState extends State<StateSwitch> {
  static const _values = ['In Progress', 'Finished'];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SlidingSegments(
      labels: const ['النشطة', 'المكتملة'],
      selected: _index,
      dark: true,
      segmentWidth: 104,
      onChanged: (i) {
        if (i == _index) return;
        setState(() => _index = i);
        widget.onSwitchChanged(_values[i]);
      },
    );
  }
}
