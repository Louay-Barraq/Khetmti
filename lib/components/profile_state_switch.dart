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
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenWidth - 60,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left Part of the switch
          GestureDetector(
            onTap: () {
              setState(() {
                _isActive = 'Your Khatms';
                widget.onSwitchChanged(_isActive);
              });
            },
            child: Container(
              width: ((screenWidth - 60) / 2) - 10,
              height: 35,
              decoration: BoxDecoration(
                color: _isActive == 'Your Khatms'
                    ? MainTheme.secondaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  'ختمــاتك',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: _isActive == 'Your Khatms'
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isActive = 'Your Friends';
                widget.onSwitchChanged(_isActive);
              });
            },
            child: Container(
              width: ((screenWidth - 60) / 2) - 10,
              height: 35,
              decoration: BoxDecoration(
                color: _isActive == 'Your Friends'
                    ? MainTheme.secondaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  'أصدقائك',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: _isActive == 'Your Friends'
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
