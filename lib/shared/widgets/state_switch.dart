import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';

class StateSwitch extends StatefulWidget {
  final void Function(String) onSwitchChanged;

  const StateSwitch({
    super.key,
    required this.onSwitchChanged,
  });

  @override
  State<StateSwitch> createState() => _StateSwitchState();
}

class _StateSwitchState extends State<StateSwitch> {
  String _isActive = 'In Progress';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegment(
            label: 'المكتملة',
            isActive: _isActive == 'Finished',
            onTap: () {
              setState(() {
                _isActive = 'Finished';
                widget.onSwitchChanged(_isActive);
              });
            },
          ),
          _buildSegment(
            label: 'النشطة',
            isActive: _isActive == 'In Progress',
            onTap: () {
              setState(() {
                _isActive = 'In Progress';
                widget.onSwitchChanged(_isActive);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isActive ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
