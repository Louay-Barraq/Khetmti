import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/quran/data/quran_api_service.dart';
import 'package:khetmti/features/quran/providers/quran_provider.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/l10n/l10n.dart';

class QuranViewPage extends ConsumerStatefulWidget {
  final int id;
  final bool isSurah;
  final String title;
  final String? khatmaId;

  const QuranViewPage({
    super.key,
    required this.id,
    required this.isSurah,
    required this.title,
    this.khatmaId,
  });

  @override
  ConsumerState<QuranViewPage> createState() => _QuranViewPageState();
}

class _QuranViewPageState extends ConsumerState<QuranViewPage> {
  Future<Map<String, dynamic>>? _quranDataFuture;
  Set<int> _stops = {};
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _ayahKeys = {};
  bool _hasAutoScrolled = false;

  @override
  void initState() {
    super.initState();
    _loadStops();
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      _quranDataFuture = widget.isSurah
          ? QuranApiService.fetchSurah(widget.id)
          : QuranApiService.fetchJuz(widget.id);
    });
  }

  Future<void> _loadStops() async {
    final stopsKey = _getStopsKey();
    final stops = await ref.read(quranRepositoryProvider).loadStops(
          stopsKey: stopsKey,
        );
    if (!mounted) return;
    setState(() {
      _stops = stops;
    });
  }

  Future<void> _toggleStop(int ayahNumber) async {
    setState(() {
      if (_stops.contains(ayahNumber)) {
        _stops.remove(ayahNumber);
      } else {
        _stops.add(ayahNumber);
      }
    });

    final stopsKey = _getStopsKey();
    await ref.read(quranRepositoryProvider).saveStops(
          stopsKey: stopsKey,
          stops: _stops,
        );
  }

  String _getStopsKey() {
    return widget.isSurah
        ? 'stops_surah_${widget.id}'
        : 'stops_juz_${widget.id}';
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(
            tr.saveProgress,
            style: TextStyle(
                fontFamily: AppTheme.font, color: AppTheme.primaryColor),
            textAlign: TextAlign.center,
          ),
          content: Text(
            tr.saveProgressBody,
            style: TextStyle(fontFamily: AppTheme.font, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(tr.ok,
                  style: TextStyle(
                      fontFamily: AppTheme.font, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: widget.title,
            showBackButton: true,
            showNotification: false,
            showProfile: false,
            suffixActions: [
              KhetmtiHeader.buildHeaderIcon(
                Icons.info_outline,
                onTap: () => _showInfoDialog(context),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _quranDataFuture,
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        )),
                        child: child,
                      ),
                    );
                  },
                  child: () {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(
                            color: AppTheme.primaryColor),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        key: const ValueKey('error'),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 50, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              tr.fetchError,
                              style: TextStyle(
                                  fontFamily: AppTheme.font,
                                  fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchData,
                              child: Text(tr.retry,
                                  style: TextStyle(
                                      fontFamily: AppTheme.font)),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data == null) {
                      return Center(
                        key: ValueKey('no_data'),
                        child: Text(tr.noData),
                      );
                    }

                    final data = snapshot.data!;
                    final List<dynamic> ayahs =
                        data['ayahs'] ?? [];

                    if (!_hasAutoScrolled &&
                        _stops.isNotEmpty &&
                        widget.khatmaId != null) {
                      int maxStop = _stops.reduce(
                          (a, b) => a > b ? a : b);
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) {
                        if (_ayahKeys.containsKey(maxStop) &&
                            _ayahKeys[maxStop]!.currentContext !=
                                null) {
                          Scrollable.ensureVisible(
                            _ayahKeys[maxStop]!.currentContext!,
                            duration: const Duration(
                                milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                          _hasAutoScrolled = true;
                        }
                      });
                    }

                    return Container(
                      key: const ValueKey('content'),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Column(
                            children: [
                              ..._buildQuranContent(ayahs),
                              const SizedBox(height: 60),
                              const Text(
                                "صَدَقَ اللهُ العَظِيم",
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 22,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    );
                  }(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuranContent(List<dynamic> ayahs) {
    List<Widget> content = [];
    int? currentSurahId;
    List<Widget> currentWrapChildren = [];

    void flushWrap() {
      if (currentWrapChildren.isNotEmpty) {
        content.add(
          Wrap(
            alignment: WrapAlignment.center,
            textDirection: TextDirection.rtl,
            spacing: 8,
            runSpacing: 16,
            children: List.from(currentWrapChildren),
          ),
        );
        currentWrapChildren.clear();
      }
    }

    for (var ayah in ayahs) {
      int surahId = widget.isSurah
          ? widget.id
          : (ayah['surah'] != null
              ? ayah['surah']['number']
              : widget.id);
      String surahName =
          ayah['surah'] != null ? ayah['surah']['name'] : '';

      if (surahId != currentSurahId) {
        flushWrap();

        if (currentSurahId != null) {
          content.add(const SizedBox(height: 30));
          content.add(Divider(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              thickness: 1));
          content.add(const SizedBox(height: 20));
          content.add(
            Text(
              surahName,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 26,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
          content.add(const SizedBox(height: 20));
        } else if (!widget.isSurah && surahName.isNotEmpty) {
          content.add(
            Text(
              surahName,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 26,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
          content.add(const SizedBox(height: 20));
        }

        bool isStartOfSurah = ayah['numberInSurah'] == 1;
        bool showBismillah =
            isStartOfSurah && surahId != 1 && surahId != 9;

        if (widget.isSurah &&
            currentSurahId == null &&
            surahId != 1 &&
            surahId != 9) {
          showBismillah = true;
        }

        if (showBismillah) {
          content.add(
            const Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
          content.add(const SizedBox(height: 20));
          content.add(Divider(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              thickness: 1));
          content.add(const SizedBox(height: 20));
        }

        currentSurahId = surahId;
      }

      String ayahText = ayah['text'];
      String cleanedText = ayahText.replaceAll('﻿', '');

      if (surahId != 1 &&
          surahId != 9 &&
          ayah['numberInSurah'] == 1) {
        cleanedText = stripBasmala(cleanedText);
      }
      ayahText = cleanedText;

      final int ayahNum = ayah['numberInSurah'];
      // A juz holds several suras, so "ayah 1" can appear more than once:
      // there the Quran-wide number identifies the ayah.
      final int stopId = widget.isSurah ? ayahNum : ayah['number'];

      currentWrapChildren.add(
          _buildAyah(ayahText, ayahNum, stopId, _stops.contains(stopId)));
    }

    flushWrap();

    return content;
  }

  Widget _buildAyah(String text, int number, int stopId, bool isStop) {
    return GestureDetector(
      key: _ayahKeys.putIfAbsent(stopId, GlobalKey.new),
      onTap: () => _toggleStop(stopId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isStop
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: RichText(
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$text ',
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  height: 2.2,
                  color: AppTheme.textPrimary,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/images/ayah_end.png'),
                      fit: BoxFit.contain,
                    ),
                    color: isStop
                        ? AppTheme.primaryColor
                            .withValues(alpha: 0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      toArabicDigits(number),
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: isStop
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                        fontWeight: isStop
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
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
}

/// Removes the basmala that opens the first ayah of a surah (shown as a header instead).
/// Compared without harakat: the bundled text orders shadda and fatha differently from
/// typed Arabic, so an exact match never succeeds.
String stripBasmala(String text) {
  String bare(String w) =>
      w.replaceAll(RegExp('[\u064B-\u0655\u0670\uFEFF]'), '').replaceAll('\u0671', '\u0627');
  final words = text.split(' ');
  if (words.length > 4 && words.take(4).map(bare).join(' ') == 'بسم الله الرحمن الرحيم') {
    return words.skip(4).join(' ').trim();
  }
  return text;
}
