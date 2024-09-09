import 'package:flutter/material.dart';
import 'package:khetmti/themes/main_theme.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: selectedIndex == 0
              ? Image.asset("assets/icons/Home-Filled.png",
                  width: 30, height: 30)
              : Image.asset("assets/icons/Home-Outlined.png",
                  width: 30, height: 30),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: selectedIndex == 1
              ? Image.asset("assets/icons/Menu-Filled.png",
                  width: 30, height: 30)
              : Image.asset("assets/icons/Menu-Outlined.png",
                  width: 30, height: 30),
          label: 'القائمة',
        ),
        BottomNavigationBarItem(
          icon: selectedIndex == 2
              ? Image.asset("assets/icons/Settings-Filled-2.png",
                  width: 25, height: 25)
              : Image.asset("assets/icons/Settings-Outlined-1.png",
                  width: 30, height: 30),
          label: 'الإعدادات',
        ),
        BottomNavigationBarItem(
          icon: selectedIndex == 3
              ? Image.asset("assets/icons/Profile-Filled.png",
                  width: 30, height: 30)
              : Image.asset("assets/icons/Profile-Outlined.png",
                  width: 30, height: 30),
          label: 'الحساب',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Color(0xFF00BB4E),
      unselectedItemColor: Color(0xFF9DB2CE),
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(color: Color(0xFF00BB4E)),
      unselectedLabelStyle: TextStyle(color: Color(0xFF9DB2CE)),
      onTap: onItemTapped,
    );
  }
}

class MyDraggableSheet extends StatefulWidget {
  final Widget child;

  const MyDraggableSheet({super.key, required this.child});

  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onChanged);
  }

  void onChanged() {
    final currentSize = controller.size;
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);

  void anchor() => animateSheet(getSheet.snapSizes!.last);

  void expand() => animateSheet(getSheet.maxChildSize);

  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size) {
    controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  DraggableScrollableSheet get getSheet =>
      (sheet.currentWidget as DraggableScrollableSheet);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      key: sheet,
      initialChildSize: 0.04,
      maxChildSize: 0.65,
      minChildSize: 0.04,
      expand: true,
      controller: controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 9,
                spreadRadius: 0,
                offset: Offset(0, -3),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: MainTheme.greyishColor,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomSheetDummyUI extends StatelessWidget {
  const BottomSheetDummyUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  color: Colors.black12,
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      color: Colors.black12,
                      height: 20,
                      width: 220,
                    ),
                  ),
                  SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      color: Colors.black12,
                      height: 20,
                      width: 180,
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
