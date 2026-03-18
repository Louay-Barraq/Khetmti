import 'package:flutter/material.dart';
import '../../components/khetmti_header.dart';
import '../../themes/main_theme.dart';

class RankingsPage extends StatefulWidget {
  const RankingsPage({super.key});

  @override
  State<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  int _timeframeIndex = 1; // Default to Week
  bool _isGlobal = true;

  final List<Map<String, dynamic>> _mockRankings = [
    {'name': 'أحمد محمد', 'xp': 1250, 'rank': 1, 'isMe': false},
    {'name': 'سارة خالد', 'xp': 1100, 'rank': 2, 'isMe': false},
    {'name': 'لؤي البراق', 'xp': 950, 'rank': 3, 'isMe': true},
    {'name': 'عمر حسن', 'xp': 800, 'rank': 4, 'isMe': false},
    {'name': 'فاطمة علي', 'xp': 750, 'rank': 5, 'isMe': false},
    {'name': 'يوسف إبراهيم', 'xp': 600, 'rank': 6, 'isMe': false},
    {'name': 'ليلى محمود', 'xp': 550, 'rank': 7, 'isMe': false},
    {'name': 'خالد وليد', 'xp': 400, 'rank': 8, 'isMe': false},
    {'name': 'نورا فهد', 'xp': 350, 'rank': 9, 'isMe': false},
    {'name': 'حمد جاسم', 'xp': 300, 'rank': 10, 'isMe': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
          children: [
            // Fixed Header and Toggles
            KhetmtiHeader(
              title: 'لوحة المتصدرين',
              showProfile: false,
              showBackButton: true,
              bottom: Column(
                children: [
                  // Timeframe Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _buildTab('اليوم', 0, isTimeframe: true),
                          _buildTab('الأسبوع', 1, isTimeframe: true),
                          _buildTab('الكل', 2, isTimeframe: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Scope Selector
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTab('العالمي', 0, isTimeframe: false),
                          const SizedBox(width: 8),
                          _buildTab('الأصدقاء', 1, isTimeframe: false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                itemCount: _mockRankings.length,
                itemBuilder: (context, index) {
                  final user = _mockRankings[index];
                  // Header spacer for the first item
                  if (index == 0) {
                    return Column(
                      children: [
                        const SizedBox(height: 10), // Small space on top of first tile
                        _buildRankingRow(user),
                      ],
                    );
                  }
                  return _buildRankingRow(user);
                },
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildTab(String label, int index, {required bool isTimeframe}) {
    bool isSelected = isTimeframe ? (_timeframeIndex == index) : (_isGlobal == (index == 0));
    
    return isTimeframe 
      ? Expanded(child: _buildTabButton(label, isSelected, () => setState(() => _timeframeIndex = index)))
      : _buildTabButton(label, isSelected, () => setState(() => _isGlobal = (index == 0)), horizontalPadding: 25);
  }

  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap, {double horizontalPadding = 0}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isSelected ? MainTheme.primaryColor : Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildRankingRow(Map<String, dynamic> user) {
    int rank = user['rank'];
    bool isMe = user['isMe'];

    Color rankColor = Colors.grey[600]!;
    if (rank == 1) rankColor = const Color(0xFFFFD700);
    if (rank == 2) rankColor = const Color(0xFFC0C0C0);
    if (rank == 3) rankColor = const Color(0xFFCD7F32);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? MainTheme.primaryColor.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isMe ? Border.all(color: MainTheme.primaryColor.withValues(alpha: 0.3), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          // Rank Badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: rank <= 3 ? rankColor.withValues(alpha: 0.15) : MainTheme.greyishColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: rank <= 3
                  ? Icon(Icons.emoji_events, color: rankColor, size: 18)
                  : Text(
                      rank.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: MainTheme.greyishColor,
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          // Name and Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      user['name'],
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
                        color: MainTheme.textPrimary,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: MainTheme.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'أنا',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // XP Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user['xp']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: MainTheme.primaryColor,
                  fontSize: 18,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
