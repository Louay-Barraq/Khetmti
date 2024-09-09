import 'package:flutter/material.dart';
import '../themes/main_theme.dart';


class StateSwitch extends StatefulWidget {
  const StateSwitch({super.key});

  @override
  State<StateSwitch> createState() => _StateSwitchState();
}

class _StateSwitchState extends State<StateSwitch> {
  String isActive = 'In Progress';

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
                isActive = 'In Progress';
              });
            },
            child: Container(
              width: ((screenWidth - 60) / 2) - 10,
              height: 32,
              decoration: BoxDecoration(
                color: isActive == 'In Progress'
                    ? MainTheme.greyishColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 25,
                    width: 45,
                    decoration: BoxDecoration(
                      color: isActive == 'In Progress'
                          ? MainTheme.primaryColor
                          : MainTheme.primaryColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                        child: Text(
                      '5',
                      style: TextStyle(
                          fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                    )),
                  ),
                  Text(
                    'في التقدم',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isActive == 'In Progress'
                          ? Colors.black
                          : Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isActive = 'Finished';
              });
            },
            child: Container(
              width: ((screenWidth - 60) / 2) - 10,
              height: 32,
              decoration: BoxDecoration(
                color: isActive == 'Finished'
                    ? MainTheme.greyishColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 25,
                    width: 45,
                    decoration: BoxDecoration(
                      color: isActive == 'Finished'
                          ? MainTheme.secondaryColor
                          : MainTheme.secondaryColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                            fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Text(
                    'منتهيــــــــة',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color:
                          isActive == 'Finished' ? Colors.black : Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
