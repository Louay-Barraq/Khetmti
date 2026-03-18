import 'package:flutter/material.dart';
import '../themes/main_theme.dart';

class StatisticsToggle extends StatefulWidget {
  final void Function(String) onValuesChanged;

  const StatisticsToggle({required this.onValuesChanged, super.key});

  @override
  State<StatisticsToggle> createState() => _StatisticsToggleState();
}

class _StatisticsToggleState extends State<StatisticsToggle> {
  String _activeView = 'Surahs';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: MainTheme.greyishColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegment(
            label: 'الأجزاء',
            isActive: _activeView == 'Juzus',
            onTap: () {
              setState(() {
                _activeView = 'Juzus';
                widget.onValuesChanged(_activeView);
              });
            },
          ),
          _buildSegment(
            label: 'السور',
            isActive: _activeView == 'Surahs',
            onTap: () {
              setState(() {
                _activeView = 'Surahs';
                widget.onValuesChanged(_activeView);
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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? MainTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isActive ? Colors.white : MainTheme.secondaryColor,
          ),
        ),
      ),
    );
  }
}
