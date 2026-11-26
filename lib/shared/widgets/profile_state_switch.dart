import 'package:flutter/material.dart';
import 'package:khetmti/shared/widgets/sliding_segments.dart';
import 'package:khetmti/l10n/l10n.dart';

class ProfileStateSwitch extends StatefulWidget {
  final void Function(String) onSwitchChanged;

  const ProfileStateSwitch({super.key, required this.onSwitchChanged});

  @override
  State<ProfileStateSwitch> createState() => _ProfileStateSwitchState();
}

class _ProfileStateSwitchState extends State<ProfileStateSwitch> {
  static const _values = ['Your Friends', 'Your Khatms', 'Statistics'];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SlidingSegments(
        labels: [tr.yourFriends, tr.yourKhatmas, tr.stats],
        selected: _index,
        onChanged: (i) {
          if (i == _index) return;
          setState(() => _index = i);
          widget.onSwitchChanged(_values[i]);
        },
      ),
    );
  }
}
