import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/khetma/models/khetma_log.dart';
import 'package:khetmti/features/khetma/models/khetma_part.dart';
import 'package:khetmti/features/khetma/models/part_state.dart';
import 'package:khetmti/features/khetma/presentation/widgets/part_tile.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/features/quran/models/quran_data.dart';
import 'package:khetmti/shared/widgets/friend_tile.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/motion.dart';

enum _Filter { all, available, mine, finished }

class KhetmaDetailPage extends ConsumerStatefulWidget {
  final String khetmaId;
  const KhetmaDetailPage({super.key, required this.khetmaId});

  @override
  ConsumerState<KhetmaDetailPage> createState() => _KhetmaDetailPageState();
}

class _KhetmaDetailPageState extends ConsumerState<KhetmaDetailPage> {
  final Set<String> _busyParts = {};
  _Filter _filter = _Filter.all;

  Future<void> _setStatus(String partName, String newStatus) async {
    HapticFeedback.selectionClick();
    setState(() => _busyParts.add(partName));
    try {
      await ref.read(khetmaRepositoryProvider).updatePartStatus(
            khetmaId: widget.khetmaId,
            partName: partName,
            newStatus: newStatus,
          );
      if (newStatus == 'finished') {
        HapticFeedback.mediumImpact();
        showSuccessToast('بارك الله فيك! أتممت قراءة $partName');
      }
    } catch (e) {
      showErrorToast(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busyParts.remove(partName));
    }
  }

  Future<void> _confirmUndo(String partName) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('التراجع عن الإتمام', textAlign: TextAlign.right),
        content: Text(
          'ستعود "$partName" محجوزة لك، وتُخصم النقاط التي حصلت عليها عند إتمامها.',
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تراجع'),
          ),
        ],
      ),
    );
    if (ok == true) _setStatus(partName, 'reserved');
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الختمة', textAlign: TextAlign.right),
        content: const Text(
          'هل أنت متأكد من حذف هذه الختمة؟ سيتم حذفها لجميع المشاركين ولا يمكن التراجع.',
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              context.pop();
              try {
                await ref
                    .read(khetmaRepositoryProvider)
                    .deleteKhetma(widget.khetmaId);
                showSuccessToast('تم حذف الختمة بنجاح');
              } catch (_) {
                showErrorToast('حدث خطأ أثناء حذف الختمة');
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openReader(Khetma khetma, String name) {
    final isSura = khetma.splitType == 'sura';
    final id = (isSura ? sourasWithAyahs.keys.toList() : juzusList).indexOf(name) + 1;
    final title = isSura ? 'سورة $name' : name;
    context.push(
      '/quran/${isSura ? 'surah' : 'juz'}/$id'
      '?title=${Uri.encodeComponent(title)}&khatmaId=${widget.khetmaId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final khetmaAsync = ref.watch(khetmaProvider(widget.khetmaId));
    final me = ref.watch(currentUserIdProvider);
    final khetma = khetmaAsync.valueOrNull;

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
                if (khetma != null && khetma.creatorId == me)
                  KhetmtiHeader.buildHeaderIcon(
                    Icons.delete_outline,
                    onTap: _confirmDelete,
                  ),
              ],
            ),
            Expanded(
              child: SmoothSwitcher(
                child: switch (khetmaAsync) {
                  AsyncValue(:final value?) => Column(
                      key: const ValueKey('content'),
                      children: [
                        const _Tabs(),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _contentTab(value, me),
                              _ParticipantsTab(khetma: value),
                              _LogsTab(logs: value.logs),
                            ],
                          ),
                        ),
                      ],
                    ),
                  AsyncError() => const _NotFound(key: ValueKey('error')),
                  _ => const Center(
                      key: ValueKey('loading'),
                      child: CircularProgressIndicator(),
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentTab(Khetma khetma, String? me) {
    final isSura = khetma.splitType == 'sura';
    final names = isSura ? sourasWithAyahs.keys.toList() : juzusList;
    final states = {
      for (final n in names)
        n: PartState.of(khetma.parts[n] ?? const KhetmaPart(), me),
    };
    bool matches(PartState s) => switch (_filter) {
          _Filter.all => true,
          _Filter.available => s == PartState.available,
          _Filter.mine => s == PartState.mine,
          _Filter.finished => s.isFinished,
        };
    final visible = [for (final n in names) if (matches(states[n]!)) n];
    int count(bool Function(PartState) test) => states.values.where(test).length;

    return CustomScrollView(
      key: const PageStorageKey('parts'),
      slivers: [
        SliverToBoxAdapter(
          child: FadeSlideIn(child: _SummaryCard(khetma: khetma)),
        ),
        SliverToBoxAdapter(
          child: _FilterBar(
            selected: _filter,
            onSelected: (f) => setState(() => _filter = f),
            counts: {
              _Filter.all: names.length,
              _Filter.available: count((s) => s == PartState.available),
              _Filter.mine: count((s) => s == PartState.mine),
              _Filter.finished: count((s) => s.isFinished),
            },
          ),
        ),
        if (visible.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyFilter(filter: _filter),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 24),
            sliver: SliverList.builder(
              itemCount: visible.length,
              itemBuilder: (context, i) {
                final name = visible[i];
                final part = khetma.parts[name] ?? const KhetmaPart();
                return FadeSlideIn(
                  key: ValueKey('$_filter-$name'),
                  index: i,
                  offset: 16,
                  child: PartTile(
                    number: names.indexOf(name) + 1,
                    title: isSura ? 'سورة $name' : name,
                    detail: isSura
                        ? '${toArabicDigits(sourasWithAyahs[name]!)} آية'
                        : null,
                    part: part,
                    state: states[name]!,
                    busy: _busyParts.contains(name),
                    onOpen: () => _openReader(khetma, name),
                    onReserve: () => _setStatus(name, 'reserved'),
                    onFinish: () => _setStatus(name, 'finished'),
                    onRelease: () => _setStatus(name, 'available'),
                    onUndo: () => _confirmUndo(name),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      tabs: [Tab(text: 'المحتوى'), Tab(text: 'المشاركون'), Tab(text: 'السجل')],
      labelColor: AppTheme.primaryColor,
      unselectedLabelColor: AppTheme.textSecondary,
      indicatorColor: AppTheme.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 3,
      dividerColor: AppTheme.borderColor,
      labelStyle: TextStyle(
        fontFamily: 'Amiri',
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }
}

/// Name, progress ring, numbers and the join code of the khatma.
class _SummaryCard extends StatelessWidget {
  final Khetma khetma;
  const _SummaryCard({required this.khetma});

  @override
  Widget build(BuildContext context) {
    final unit = khetma.splitType == 'sura' ? 'سورة' : 'جزء';
    final percent = khetma.completionPercent.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      'ختمة لفائدة',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      khetma.name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      textDirection: TextDirection.rtl,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Stat(
                          icon: Icons.group_rounded,
                          text:
                              '${khetma.currentParticipantsNumber} / ${khetma.maxParticipantsNumber} مشاركين',
                        ),
                        _Stat(
                          icon: Icons.menu_book_rounded,
                          text: '${khetma.finishedParts} / ${khetma.totalParts} $unit',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CircularPercentIndicator(
                radius: 44,
                lineWidth: 8,
                percent: percent,
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 700,
                curve: AppTheme.curve,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: const Color(0xFFF1F5F9),
                progressColor: AppTheme.primaryColor,
                center: Text(
                  '${(percent * 100).toStringAsFixed(percent < 0.1 ? 1 : 0)}%',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _JoinCode(code: khetma.code),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Stat({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.softGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, size: 15, color: AppTheme.primaryColor),
          const SizedBox(width: 5),
          Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// The 5-digit code friends use to join, with a copy button.
class _JoinCode extends StatelessWidget {
  final String code;
  const _JoinCode({required this.code});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        HapticFeedback.selectionClick();
        showSuccessToast('تم نسخ رمز الانضمام');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            const Icon(Icons.vpn_key_rounded, size: 18, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            const Text(
              'رمز الانضمام',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 15,
                color: AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              code,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.copy_rounded, size: 18, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
}

/// Filter chips; their colored dots double as the legend of the part states.
class _FilterBar extends StatelessWidget {
  final _Filter selected;
  final ValueChanged<_Filter> onSelected;
  final Map<_Filter, int> counts;

  const _FilterBar({
    required this.selected,
    required this.onSelected,
    required this.counts,
  });

  static const _labels = {
    _Filter.all: ('الكل', AppTheme.textPrimary),
    _Filter.available: ('المتاحة', AppTheme.availableColor),
    _Filter.mine: ('محجوزاتي', AppTheme.reservedColor),
    _Filter.finished: ('المكتملة', AppTheme.finishedColor),
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        children: [
          for (final f in _Filter.values) ...[
            _chip(f),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }

  Widget _chip(_Filter f) {
    final (label, color) = _labels[f]!;
    final isOn = f == selected;
    return Pressable(
      onTap: () => onSelected(f),
      child: AnimatedContainer(
        duration: AppTheme.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isOn ? color : Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: isOn ? color : AppTheme.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            if (f != _Filter.all) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOn ? Colors.white : color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              '$label ${counts[f] ?? 0}',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isOn ? Colors.white : AppTheme.textPrimary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFilter extends StatelessWidget {
  final _Filter filter;
  const _EmptyFilter({required this.filter});

  @override
  Widget build(BuildContext context) {
    final text = switch (filter) {
      _Filter.available => 'لم يبق شيء متاح للحجز',
      _Filter.mine => 'لم تحجز شيئاً بعد، اختر من المتاحة',
      _Filter.finished => 'لم يكتمل شيء بعد',
      _Filter.all => '',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 17,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ParticipantsTab extends ConsumerWidget {
  final Khetma khetma;
  const _ParticipantsTab({required this.khetma});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(khetmaParticipantsProvider(khetma.khetmaId));
    final unit = khetma.splitType == 'sura' ? 'سورة' : 'جزء';

    return SmoothSwitcher(
      child: participants.when(
        skipLoadingOnReload: true,
        loading: () => const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(),
        ),
        error: (_, __) => const Center(
          key: ValueKey('error'),
          child: Text('تعذّر تحميل المشاركين'),
        ),
        data: (users) => ListView.builder(
          key: const ValueKey('list'),
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: users.length,
          itemBuilder: (context, i) {
            final u = users[i];
            final mine = khetma.parts.values.where((p) => p.uid == u.uid);
            final done = mine.where((p) => p.isFinished).length;
            final reserved = mine.where((p) => p.isReserved).length;
            return FadeSlideIn(
              index: i,
              child: FriendComponent(
                username: u.username,
                level: u.level,
                subtitle: [
                  if (u.uid == khetma.creatorId) 'المنشئ',
                  'أتمّ $done $unit',
                  if (reserved > 0) 'يقرأ $reserved',
                ].join(' · '),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LogsTab extends StatelessWidget {
  final List<KhetmaLog> logs;
  const _LogsTab({required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد نشاطات مسجلة بعد',
          style: TextStyle(fontSize: 17, color: AppTheme.textSecondary),
        ),
      );
    }
    final sorted = [...logs]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final format = intl.DateFormat('HH:mm · yyyy/MM/dd');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, i) {
        final log = sorted[i];
        final finished = log.action.contains('أتم');
        final color = finished ? AppTheme.finishedColor : AppTheme.reservedColor;
        return FadeSlideIn(
          index: i,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    finished ? Icons.check_rounded : Icons.history_rounded,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: log.username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' ${log.action} '),
                          TextSpan(
                            text: log.part,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ]),
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 16,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        format.format(log.timestamp.toLocal()),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
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
}

class _NotFound extends StatelessWidget {
  const _NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.do_not_disturb_alt,
                  size: 56, color: Colors.red),
            ),
            const SizedBox(height: 24),
            const Text(
              'الختمة غير موجودة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'يبدو أن هذه الختمة قد حُذفت أو لم تعد متوفرة.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
