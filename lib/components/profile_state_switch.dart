import 'package:flutter/material.dart';
import '../themes/main_theme.dart';

class ProfileStateSwitch extends StatefulWidget {
  final void Function(String) onSwitchChanged;

  const ProfileStateSwitch({required this.onSwitchChanged, super.key});

  @override
  State<ProfileStateSwitch> createState() => _ProfileStateSwitchState();
}

class _ProfileStateSwitchState extends State<ProfileStateSwitch> {
  String _isActive = 'Your Friends';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegment(
              label: 'الإحصائيات',
              isActive: _isActive == 'Statistics',
              onTap: () {
                setState(() {
                  _isActive = 'Statistics';
                  widget.onSwitchChanged(_isActive);
                });
              },
            ),
          ),
          Expanded(
            child: _buildSegment(
              label: 'ختماتك',
              isActive: _isActive == 'Your Khatms',
              onTap: () {
                setState(() {
                  _isActive = 'Your Khatms';
                  widget.onSwitchChanged(_isActive);
                });
              },
            ),
          ),
          Expanded(
            child: _buildSegment(
              label: 'أصدقائك',
              isActive: _isActive == 'Your Friends',
              onTap: () {
                setState(() {
                  _isActive = 'Your Friends';
                  widget.onSwitchChanged(_isActive);
                });
              },
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? MainTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isActive ? Colors.white : MainTheme.secondaryColor,
          ),
        ),
      ),
    );
  }
}
