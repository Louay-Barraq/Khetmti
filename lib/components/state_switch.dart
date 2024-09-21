import 'package:flutter/material.dart';
import '../themes/main_theme.dart';

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
          GestureDetector(
            onTap: () {
              setState(() {
                _isActive = 'In Progress';
                widget.onSwitchChanged(_isActive);
              });
            },
            child: Container(
              width: ((screenWidth - 60) / 2) - 10,
              height: 32,
              decoration: BoxDecoration(
                color: _isActive == 'In Progress'
                    ? MainTheme.greyishColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  'ختمـــاتك',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: _isActive == 'In Progress'
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
                _isActive = 'Finished';
                widget.onSwitchChanged(_isActive);
              });
            },
            child: Container(
              width: ((screenWidth - 60) / 2) - 10,
              height: 32,
              decoration: BoxDecoration(
                color: _isActive == 'Finished'
                    ? MainTheme.greyishColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  'ليــست ختمـــاتك',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color:
                        _isActive == 'Finished' ? Colors.black : Colors.white,
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
