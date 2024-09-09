import 'package:flutter/material.dart';
import 'package:khetmti/components/profile_page_logo.dart';
import '../themes/main_theme.dart';

class ProfileTopPageBox extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final bool isLoading;

  const ProfileTopPageBox({
    super.key,
    this.userData,
    this.isLoading = false,
  });

  double _calculateFontSize(String text, double maxWidth) {
    // Calculate a reasonable font size based on the length of the text
    double baseFontSize = 40;
    double textWidth = (text.length / 10) * baseFontSize; // Rough approximation
    return (textWidth > maxWidth)
        ? (baseFontSize * maxWidth / textWidth)
        : baseFontSize;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      width: screenWidth,
      height: 180,
      decoration: BoxDecoration(
        color: MainTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 14,
            spreadRadius: 10,
            color: Color(0x3F000000),
          ),
        ],
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0), // Add padding around the logo
                  child: ProfilePageLogo(),
                ),
                SizedBox(width: 20),
                CircularProgressIndicator(color: Colors.white),
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                if (userData == null) {
                  return Center(child: Text("No data available"));
                }
                String username = userData!['username'] ?? 'إسم المستخدم';
                double maxTextWidth = constraints.maxWidth * 0.5;

                double fontSize = _calculateFontSize(username, maxTextWidth);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: ProfilePageLogo(),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 5),
                                child: Text(
                                  username,
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 2.5,
                                          color: Color(0x3F000000)),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userData!['level']?.toString() ?? '0',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 3,
                                            color: Color(0x3F000000),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      ' : المــستـوى',
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 3,
                                            color: Color(0x3F000000),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }
}
