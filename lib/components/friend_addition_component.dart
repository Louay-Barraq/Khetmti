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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // Avatar
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F5F9),
              ),
              child: Center(
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : "U",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MainTheme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MainTheme.textPrimary,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: MainTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Actions
            _getStatusWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _getStatusWidget(BuildContext context) {
    switch (status) {
      case 'friends':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'أصدقاء',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri',
              fontSize: 14,
            ),
          ),
        );
      case 'pending':
        return ElevatedButton(
          onPressed: onRemove,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('إلغاء الطلب', style: TextStyle(fontFamily: 'Amiri', fontSize: 12)),
        );
      case 'received':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onAccept,
              icon: const Icon(Icons.check_circle, color: Colors.green),
            ),
            IconButton(
              onPressed: onDecline,
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
          ],
        );
      case 'none':
      default:
        return ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.person_add_alt_1, size: 16),
          label: const Text('إضافة', style: TextStyle(fontFamily: 'Amiri', fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: MainTheme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }
}
