import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:khetmti/components/friend_component.dart';
import 'package:khetmti/components/introductive_component.dart';
import 'package:khetmti/components/khetmti_header.dart';
import 'package:khetmti/data/quran_data.dart';
import '../../themes/main_theme.dart';
import '../../utils/helpers.dart';
import '../main/quran_view_page.dart';
import '../actions/notifications_page.dart';

class KhetmaPage extends StatefulWidget {
  final String khetmaUid;
  const KhetmaPage({super.key, required this.khetmaUid});

  @override
  State<KhetmaPage> createState() => _KhetmaPageState();
}

class _KhetmaPageState extends State<KhetmaPage> {
  User user = FirebaseAuth.instance.currentUser!;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addLogEntry(String partName, String action) async {
    final khetmaRef = FirebaseFirestore.instance.collection('khatms').doc(widget.khetmaUid);
    final log = {
      'username': user.displayName ?? 'Unknown',
      'uid': user.uid,
      'part': partName,
      'action': action, // 'reserved', 'freed', 'finished'
      'timestamp': Timestamp.now(),
    };
    
    await khetmaRef.update({
      'logs': FieldValue.arrayUnion([log])
    });
  }

  void _updatePartStatus(String name, String newStatus) async {
    try {
      final khetmaRef = FirebaseFirestore.instance.collection('khatms').doc(widget.khetmaUid);
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot khetmaSnapshot = await transaction.get(khetmaRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (!khetmaSnapshot.exists) return;

        Map<String, dynamic> data = khetmaSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> parts = Map<String, dynamic>.from(data['parts'] ?? {});
        
        if (!parts.containsKey(name)) return;

        Map<String, dynamic> part = Map<String, dynamic>.from(parts[name]);
        String oldStatus = part['status'] ?? 'available';
        String? partUid = part['uid'];

        // Validation logic
        if (newStatus == 'reserved' && oldStatus == 'available') {
          // OK
        } else if (newStatus == 'available' && oldStatus == 'reserved' && partUid == user.uid) {
          // OK
        } else if (newStatus == 'finished' && oldStatus == 'reserved' && partUid == user.uid) {
          // OK
        } else if (newStatus == 'reserved' && oldStatus == 'finished' && partUid == user.uid) {
          // Undo Finish: OK
        } else {
          return; // Invalid transition
        }

        // Update the part
        part['status'] = newStatus;
        part['uid'] = newStatus == 'available' ? null : user.uid;
        part['username'] = newStatus == 'available' ? null : user.displayName;
        parts[name] = part;

        // Counters
        int finishedParts = data['finishedParts'] ?? 0;
        if (newStatus == 'finished' && oldStatus != 'finished') finishedParts++;
        if (oldStatus == 'finished' && newStatus != 'finished') finishedParts--;

        double completionPercent = finishedParts / (data['totalParts'] ?? 1);

        transaction.update(khetmaRef, {
          'parts': parts,
          'finishedParts': finishedParts,
          'completionPercent': completionPercent,
          'updatedAt': Timestamp.now(),
        });

        // XP Calculation
        int xpReward = 0;
        String splitType = data['splitType'] ?? 'sura';

        if (oldStatus == 'available' && newStatus == 'reserved') {
          xpReward = 10;
        } else if (oldStatus == 'reserved' && newStatus == 'available') {
          xpReward = -10;
        } else if (oldStatus == 'reserved' && newStatus == 'finished') {
          if (splitType == 'sura') {
            int ayahs = sourasWithAyahs[name] ?? 0;
            xpReward = 50 + (ayahs * 2);
          } else {
            xpReward = 500;
          }
        } else if (oldStatus == 'finished' && newStatus == 'reserved') {
          if (splitType == 'sura') {
            int ayahs = sourasWithAyahs[name] ?? 0;
            xpReward = -(50 + (ayahs * 2));
          } else {
            xpReward = -500;
          }
        }

        // Update User XP, Level and Reading Stats
        Map<String, dynamic> userData = Map<String, dynamic>.from(userSnapshot.data() as Map<String, dynamic>? ?? {});
        int currentXP = userData['totalXP'] ?? 0;
        int newTotalXP = currentXP + xpReward;
        if (newTotalXP < 0) newTotalXP = 0;
        
        int newLevel = (math.log(newTotalXP / 5000 + 1) / math.log(1.2)).floor() + 1;

        Map<String, int> readingStats = Map<String, int>.from(userData['readingStats'] ?? {});
        if (newStatus == 'finished' && oldStatus != 'finished') {
          readingStats[name] = (readingStats[name] ?? 0) + 1;
        } else if (oldStatus == 'finished' && newStatus != 'finished') {
          readingStats[name] = (readingStats[name] ?? 0) - 1;
          if (readingStats[name]! < 0) readingStats[name] = 0;
        }

        transaction.update(userRef, {
          'totalXP': newTotalXP,
          'level': newLevel,
          'readingStats': readingStats,
        });

        // Add to logs
        String actionText = "";
        if (newStatus == 'reserved' && oldStatus == 'available') actionText = 'حجز';
        else if (newStatus == 'finished') actionText = 'أتم القراءة';
        else if (newStatus == 'available') actionText = 'ألغى الحجز';
        else if (newStatus == 'reserved' && oldStatus == 'finished') actionText = 'تراجع عن القراءة';

        final log = {
          'username': user.displayName ?? 'Unknown',
          'uid': user.uid,
          'part': name,
          'action': actionText,
          'timestamp': Timestamp.now(),
        };
        transaction.update(khetmaRef, {
          'logs': FieldValue.arrayUnion([log])
        });

        // Update participants list
        if (newStatus == 'reserved' && oldStatus == 'available') {
          transaction.update(khetmaRef, {
            'participants': FieldValue.arrayUnion([user.uid]),
          });
        }
        
        // Update user's records if they join for the first time
        List<String> joined = List<String>.from(userData['khatmsJoined'] ?? []);
        if (!joined.contains(widget.khetmaUid)) {
          joined.add(widget.khetmaUid);
          transaction.update(userRef, {'khatmsJoined': joined});
        }
      });
    } catch (e) {
      debugPrint("Error updating part status: $e");
      showErrorToast("حدث خطأ أثناء تحديث الحالة");
    }
  }

  void _showDeleteKhetmaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('حذف الختمة', textAlign: TextAlign.right),
            content: const Text(
              'هل أنت متأكد من حذف هذه الختمة؟ سيتم حذف جميع البيانات المتعلقة بها.',
              textAlign: TextAlign.right,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    showLoadingDialog(context);
                    await FirebaseFirestore.instance
                        .collection('khatms')
                        .doc(widget.khetmaUid)
                        .delete();

                    if (context.mounted) {
                      dismissLoadingDialog(context);
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to Home
                    }
                    showSuccessToast("تم حذف الختمة بنجاح");
                  } catch (e) {
                    if (context.mounted) dismissLoadingDialog(context);
                    showErrorToast("حدث خطأ أثناء حذف الختمة");
                  }
                },
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('khatms')
          .doc(widget.khetmaUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            backgroundColor: MainTheme.backgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.do_not_disturb_alt, size: 60, color: Colors.red),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "الختمة غير موجودة",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: MainTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "يبدو أن هذه الختمة قد تم حذفها من قبل المنشئ أو لم تعد متوفرة.",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: MainTheme.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "العودة للرئيسية",
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        Map<String, dynamic> khetmaData = snapshot.data!.data() as Map<String, dynamic>;
        Map<String, dynamic> parts = khetmaData['parts'] ?? {};
        String splitType = khetmaData['splitType'] ?? 'sura';
        bool isCreator = khetmaData['creatorId'] == user.uid;

        List<String> sortedKeys = parts.keys.toList();
        // Keep original order if possible (sourasWithAyahs or juzusList order)
        if (splitType == 'sura') {
          sortedKeys = sourasWithAyahs.keys.toList();
        } else {
          sortedKeys = juzusList;
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: MainTheme.backgroundColor,
            body: Column(
              children: [
                KhetmtiHeader(
                  title: 'ختمـتي',
                  showProfile: false,
                  showBackButton: true,
                  onBackTap: () => Navigator.pop(context),
                  onNotificationTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsPage()),
                  ),
                  suffixActions: [
                    if (isCreator)
                      KhetmtiHeader.buildHeaderIcon(
                        Icons.delete_outline,
                        onTap: () => _showDeleteKhetmaDialog(context),
                      ),
                  ],
                ),
                TabBar(
                  tabs: [
                    Tab(child: Text("المحتوى", style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold))),
                    Tab(child: Text("المشاركون", style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold))),
                    Tab(child: Text("السجل", style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold))),
                  ],
                  labelColor: MainTheme.primaryColor,
                  unselectedLabelColor: MainTheme.textSecondary,
                  indicatorColor: MainTheme.primaryColor,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Content Tab
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            khetmaData['name'],
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "معلومات الختمة",
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MainTheme.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          _detailsBox(khetmaData),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                splitType == 'sura' ? "السور" : "الأجزاء",
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MainTheme.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: sortedKeys.length,
                              itemBuilder: (context, index) {
                                String partName = sortedKeys[index];
                                Map<String, dynamic> partData = Map<String, dynamic>.from(parts[partName] ?? {});
                                
                                return _partBox(
                                  name: partName,
                                  partData: partData,
                                  splitType: splitType,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Participants Tab
                      _buildParticipantsTab(parts),
                      // Logs Tab
                      _buildLogsList(khetmaData['logs'] ?? []),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticipantsTab(Map<String, dynamic> parts) {
    // Extract unique participants (uid -> username)
    Map<String, String> participants = {};
    parts.forEach((key, value) {
      if (value['uid'] != null && value['username'] != null) {
        participants[value['uid']] = value['username'];
      }
    });

    if (participants.isEmpty) {
      return const Center(
        child: Text(
          "لا يوجد مشاركون بعد",
          style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
        ),
      );
    }

    final participantList = participants.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: participantList.length,
      itemBuilder: (context, index) {
        final entry = participantList[index];
        return FriendComponent(
          username: entry.value,
          level: 1, // We don't have level here easily, defaults to 1 or we could fetch it.
        );
      },
    );
  }

  Widget _buildLogsList(List<dynamic> logs) {
    if (logs.isEmpty) {
      return const Center(child: Text("لا توجد نشاطات مسجلة بعد", style: TextStyle(fontFamily: 'Amiri')));
    }
    
    final sortedLogs = List.from(logs)..sort((a, b) => (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: sortedLogs.length,
      itemBuilder: (context, index) {
        final log = sortedLogs[index];
        final DateTime date = (log['timestamp'] as Timestamp).toDate();
        final String timeStr = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: MainTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.history, color: MainTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    style: const TextStyle(fontFamily: 'Amiri', color: MainTheme.textPrimary, fontSize: 16),
                    children: [
                      TextSpan(text: log['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " ${log['action']} "),
                      TextSpan(text: log['part'], style: const TextStyle(fontWeight: FontWeight.bold, color: MainTheme.primaryColor)),
                    ],
                  ),
                ),
              ),
              Text(
                timeStr,
                style: const TextStyle(fontSize: 12, color: MainTheme.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _partBox({
    required String name,
    required Map<String, dynamic> partData,
    required String splitType,
  }) {
    String status = partData['status'] ?? 'available';
    String? readerUid = partData['uid'];
    String? readerName = partData['username'];
    
    String prefix = splitType == 'sura' ? "سورة " : "";
    
    String readerText = status == 'available'
        ? "غيـــر محجـوزة"
        : (status == 'finished' 
           ? (readerUid == user.uid ? "أتممت قراءتها" : "أتم قراءتها: $readerName")
           : (readerUid == user.uid ? "محجوزة من قبلك" : "محجوزة من قبل: $readerName"));

    return GestureDetector(
      onTap: () {
        int id = splitType == 'sura' 
            ? sourasWithAyahs.keys.toList().indexOf(name) + 1 
            : juzusList.indexOf(name) + 1;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuranViewPage(
              id: id,
              isSurah: splitType == 'sura',
              title: "$prefix$name",
              khatmaId: widget.khetmaUid,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              // Status Indicator Bar
              Container(
                width: 6,
                color: status == 'finished' ? Colors.green : (status == 'reserved' ? MainTheme.primaryColor : Colors.grey.shade300),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$prefix$name",
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: MainTheme.textPrimary,
                            ),
                          ),
                          if (status == 'finished')
                            const Icon(Icons.verified, color: Colors.green, size: 20),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          readerText,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 14,
                            color: status == 'finished' ? Colors.green : (readerUid == user.uid ? MainTheme.primaryColor : MainTheme.textSecondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Action Buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    if (status == 'available')
                      _actionButton(
                        icon: Icons.bookmark_add_outlined,
                        color: MainTheme.primaryColor,
                        onTap: () => _updatePartStatus(name, 'reserved'),
                      ),
                    if (status == 'reserved' && readerUid == user.uid) ...[
                      _actionButton(
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                        onTap: () => _updatePartStatus(name, 'finished'),
                      ),
                      const SizedBox(width: 8),
                      _actionButton(
                        icon: Icons.bookmark_remove_outlined,
                        color: Colors.red,
                        onTap: () => _updatePartStatus(name, 'available'),
                      ),
                    ],
                    if (status == 'finished' && readerUid == user.uid)
                      _actionButton(
                        icon: Icons.undo,
                        color: Colors.orange,
                        onTap: () => _updatePartStatus(name, 'reserved'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _actionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _detailsBox(Map<String, dynamic> khetmaData) {
    String splitType = khetmaData['splitType'] ?? 'sura';
    String partLabel = splitType == 'sura' ? 'السور' : 'الأجزاء';
    
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 2,
              spreadRadius: 2,
              color: Color(0x3F000000),
            )
          ],
        ),
        child: Column(
          children: [
            _detailRow(key: 'رمـز الانضمام', value: khetmaData['code'] ?? '-----'),
            _detailRow(key: 'المشاركين', value: khetmaData['currentParticipantsNumber']),
            _detailRow(key: 'الحد الأقصى', value: khetmaData['maxParticipantsNumber']),
            _detailRow(
              key: 'الإكمال',
              value: "${((khetmaData['completionPercent'] ?? 0.0) * 100).toStringAsFixed(1)}%"
            ),
            _detailRow(key: 'المكتمل ($partLabel)', value: khetmaData['finishedParts'] ?? 0),
            _detailRow(key: 'المجموع ($partLabel)', value: khetmaData['totalParts'] ?? (splitType == 'sura' ? 114 : 30)),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({required String key, required dynamic value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              key,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(color: MainTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: MainTheme.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}