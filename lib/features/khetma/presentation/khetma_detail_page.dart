import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/khetma/models/khetma_part.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/features/khetma/models/khetma_log.dart';
import 'package:khetmti/features/quran/models/quran_data.dart';
import 'package:khetmti/shared/widgets/friend_tile.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class KhetmaDetailPage extends ConsumerStatefulWidget {
  final String khetmaId;
  const KhetmaDetailPage({super.key, required this.khetmaId});

  @override
  ConsumerState<KhetmaDetailPage> createState() => _KhetmaDetailPageState();
}

class _KhetmaDetailPageState extends ConsumerState<KhetmaDetailPage> {
  String? updatingPartName;

  void _updatePartStatus(String partName, String newStatus) async {
    setState(() {
      updatingPartName = partName;
    });
    try {
      await ref.read(khetmaRepositoryProvider).updatePartStatus(
            khetmaId: widget.khetmaId,
            partName: partName,
            newStatus: newStatus,
          );
    } catch (e) {
      debugPrint("Error updating part status: $e");
      showErrorToast("حدث خطأ أثناء تحديث الحالة");
    } finally {
      if (mounted) {
        setState(() {
          updatingPartName = null;
        });
      }
    }
  }

  void _showDeleteKhetmaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الختمة', textAlign: TextAlign.right),
        content: const Text(
          'هل أنت متأكد من حذف هذه الختمة؟ سيتم حذف جميع البيانات المتعلقة بها.',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              try {
                showLoadingDialog(ctx);
                await ref
                    .read(khetmaRepositoryProvider)
                    .deleteKhetma(widget.khetmaId);

                if (ctx.mounted) {
                  dismissLoadingDialog(ctx);
                  Navigator.pop(ctx); // Close dialog
                }
                if (context.mounted) {
                  context.pop(); // Go back to Home
                }
                showSuccessToast("تم حذف الختمة بنجاح");
              } catch (e) {
                if (ctx.mounted) dismissLoadingDialog(ctx);
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
    final khetmaAsync = ref.watch(khetmaProvider(widget.khetmaId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.valueOrNull?.id;

    return khetmaAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _buildErrorScaffold(),
      data: (khetma) {
        final isCreator = khetma.creatorId == currentUserId;
        final sortedKeys = khetma.splitType == 'sura'
            ? sourasWithAyahs.keys.toList()
            : juzusList;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: Column(
              children: [
                KhetmtiHeader(
                  title: 'ختمـتي',
                  showProfile: false,
                  showBackButton: true,
                  onBackTap: () => context.pop(),
                  onNotificationTap: () => context.push('/notifications'),
                  suffixActions: [
                    if (isCreator)
                      KhetmtiHeader.buildHeaderIcon(
                        Icons.delete_outline,
                        onTap: () => _showDeleteKhetmaDialog(context),
                      ),
                  ],
                ),
                TabBar(
                  tabs: const [
                    Tab(
                        child: Text("المحتوى",
                            style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold))),
                    Tab(
                        child: Text("المشاركون",
                            style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold))),
                    Tab(
                        child: Text("السجل",
                            style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold))),
                  ],
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondary,
                  indicatorColor: AppTheme.primaryColor,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildContentTab(khetma, sortedKeys, currentUserId),
                      _buildParticipantsTab(khetma.parts),
                      _buildLogsList(khetma.logs),
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

  Widget _buildErrorScaffold() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.do_not_disturb_alt,
                    size: 60, color: Colors.red),
              ),
              const SizedBox(height: 30),
              const Text(
                "الختمة غير موجودة",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                "يبدو أن هذه الختمة قد تم حذفها من قبل المنشئ أو لم تعد متوفرة.",
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => context.pop(),
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

  Widget _buildContentTab(
      Khetma khetma, List<String> sortedKeys, String? currentUserId) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          khetma.name,
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
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        _detailsBox(khetma),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              khetma.splitType == 'sura' ? "السور" : "الأجزاء",
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
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
              final partName = sortedKeys[index];
              final part = khetma.parts[partName];

              return _partBox(
                name: partName,
                part: part ?? const KhetmaPart(status: 'available'),
                splitType: khetma.splitType,
                currentUserId: currentUserId,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsTab(Map<String, KhetmaPart> parts) {
    final Map<String, String> participants = {};
    parts.forEach((key, value) {
      if (value.uid != null && value.username != null) {
        participants[value.uid!] = value.username!;
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
          level: 1,
        );
      },
    );
  }

  Widget _buildLogsList(List<KhetmaLog> logs) {
    if (logs.isEmpty) {
      return const Center(
          child: Text("لا توجد نشاطات مسجلة بعد",
              style: TextStyle(fontFamily: 'Amiri')));
    }

    final sortedLogs = List<KhetmaLog>.from(logs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: sortedLogs.length,
      itemBuilder: (context, index) {
        final log = sortedLogs[index];
        final date = log.timestamp;
        final String timeStr =
            "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle),
                child: const Icon(Icons.history,
                    color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    style: const TextStyle(
                        fontFamily: 'Amiri',
                        color: AppTheme.textPrimary,
                        fontSize: 16),
                    children: [
                      TextSpan(
                          text: log.username,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " ${log.action} "),
                      TextSpan(
                          text: log.part,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor)),
                    ],
                  ),
                ),
              ),
              Text(
                timeStr,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _partBox({
    required String name,
    required KhetmaPart part,
    required String splitType,
    required String? currentUserId,
  }) {
    final status = part.status;
    final readerUid = part.uid;
    final readerName = part.username;

    final prefix = splitType == 'sura' ? "سورة " : "";

    final readerText = status == 'available'
        ? "غيـــر محجـوزة"
        : (status == 'finished'
            ? (readerUid == currentUserId
                ? "أتممت قراءتها"
                : "أتم قراءتها: $readerName")
            : (readerUid == currentUserId
                ? "محجوزة من قبلك"
                : "محجوزة من قبل: $readerName"));

    void navigateToQuran() {
      final id = splitType == 'sura'
          ? sourasWithAyahs.keys.toList().indexOf(name) + 1
          : juzusList.indexOf(name) + 1;
      final type = splitType == 'sura' ? 'surah' : 'juz';
      context.push(
        '/quran/$type/$id?title=${Uri.encodeComponent("$prefix$name")}&khatmaId=${widget.khetmaId}',
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 6,
                color: status == 'finished'
                    ? Colors.green
                    : (status == 'reserved'
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: navigateToQuran,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (status == 'finished')
                              const Icon(Icons.verified,
                                  color: Colors.green, size: 20),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          readerText,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 14,
                            color: status == 'finished'
                                ? Colors.green
                                : (readerUid == currentUserId
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AnimatedSwitcher(
                  duration: const Duration(
                      milliseconds: 350), // Controls animation speed
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: updatingPartName == name
                      ? const SizedBox(
                          key: ValueKey(
                              'loading'), // Required so AnimatedSwitcher knows it's a new widget
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppTheme.primaryColor,
                          ),
                        )
                      : Row(
                          key: ValueKey(
                              'actions_${status}_$readerUid'), // Key changes when actions change
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (status == 'available')
                              _actionButton(
                                icon: Icons.bookmark_add_outlined,
                                color: AppTheme.primaryColor,
                                onTap: () =>
                                    _updatePartStatus(name, 'reserved'),
                              )
                            else if (status == 'reserved' &&
                                readerUid == currentUserId) ...[
                              _actionButton(
                                icon: Icons.check_circle_outline,
                                color: Colors.green,
                                onTap: () =>
                                    _updatePartStatus(name, 'finished'),
                              ),
                              const SizedBox(width: 8),
                              _actionButton(
                                icon: Icons.bookmark_remove_outlined,
                                color: Colors.red,
                                onTap: () =>
                                    _updatePartStatus(name, 'available'),
                              ),
                            ] else if (status == 'finished' &&
                                readerUid == currentUserId)
                              _actionButton(
                                icon: Icons.undo,
                                color: Colors.orange,
                                onTap: () =>
                                    _updatePartStatus(name, 'reserved'),
                              ),
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _detailsBox(Khetma khetma) {
    final partLabel = khetma.splitType == 'sura' ? 'السور' : 'الأجزاء';

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
            _detailRow(key: 'رمـز الانضمام', value: khetma.code),
            _detailRow(
                key: 'المشاركين', value: khetma.currentParticipantsNumber),
            _detailRow(key: 'الحد الأقصى', value: khetma.maxParticipantsNumber),
            _detailRow(
              key: 'الإكمال',
              value: "${(khetma.completionPercent * 100).toStringAsFixed(1)}%",
            ),
            _detailRow(
                key: 'المكتمل ($partLabel)', value: khetma.finishedParts),
            _detailRow(key: 'المجموع ($partLabel)', value: khetma.totalParts),
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
              style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
