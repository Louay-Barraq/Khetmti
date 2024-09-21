import 'package:flutter/material.dart';
import '../themes/main_theme.dart';

class FriendAdditionComponent extends StatelessWidget {
  final String username;
  final String email;
  final String status;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FriendAdditionComponent({
    super.key,
    required this.username,
    required this.email,
    required this.status,
    required this.onAdd,
    required this.onRemove,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      height: 100,
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
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Ensure the column takes full width
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    username,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      email,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 7),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            color: Color(0x33000000),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 15,
                    spreadRadius: 4,
                    color: Color(0x3F000000),
                  ),
                ],
              ),
              child: _getStatusWidget(
                  status, onAdd, onRemove, onAccept, onDecline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStatusWidget(String status, VoidCallback onAdd,
      VoidCallback onRemove, VoidCallback onAccept, VoidCallback onDecline) {
    if (status == 'friends') {
      return Center(
        child: Text(
          'أصــــــدقاء',
          style: TextStyle(
            color: MainTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
            fontSize: 18
            ,
          ),
        ),
      );
    } else if (status == 'pending') {
      return Center(
        child: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.redAccent,
            size: 30,
          ),
          onPressed: onRemove,

        ),
      );
    } else if (status == 'received') {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.check,
                color: MainTheme.primaryColor,
                size: 30,
              ),
              onPressed: onAccept,
            ),
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.redAccent,
                size: 30,
              ),
              onPressed: onDecline,
            ),
          ],
        ),
      );
    } else if (status == 'none') {
      return Center(
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: MainTheme.primaryColor,
            size: 30,
          ),
          onPressed: onAdd,
        ),
      );
    } else {
      return Container();
    }
  }
}
