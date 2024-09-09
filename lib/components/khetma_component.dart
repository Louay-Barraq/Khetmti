import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../themes/main_theme.dart';

class KhetmaComponent extends StatefulWidget {
  final String title;
  final int participantsCount;
  final double progress;

  const KhetmaComponent({
    required this.title,
    required this.participantsCount,
    required this.progress,
    super.key,
  });

  @override
  State<KhetmaComponent> createState() => _KhetmaComponentState();
}

class _KhetmaComponentState extends State<KhetmaComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      height: 90,
      decoration: BoxDecoration(
        color: MainTheme.greyishColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x3F000000),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.,
                  children: [
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "${widget.participantsCount}",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 45),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "عدد المشاركين",
                        style: TextStyle(
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VerticalDivider(
            thickness: 1,
            color: Color(0x33000000),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircularPercentIndicator(
              radius: 40,
              percent: widget.progress,
              backgroundColor: Colors.transparent,
              progressColor: MainTheme.tertiaryColor,
              circularStrokeCap: CircularStrokeCap.round,
              center: Container(
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 15,
                      spreadRadius: 4,
                      color: Color(0x3F000000),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "${(widget.progress * 100).toInt()}",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
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
