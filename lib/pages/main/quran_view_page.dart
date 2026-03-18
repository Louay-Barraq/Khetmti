import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/quran_api_service.dart';
import '../../themes/main_theme.dart';
import '../../components/khetmti_header.dart';

class QuranViewPage extends StatefulWidget {
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
  State<QuranViewPage> createState() => _QuranViewPageState();
}

class _QuranViewPageState extends State<QuranViewPage> {
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
    final key = _getStopsKey();

    if (widget.khatmaId != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('khatms')
            .doc(widget.khatmaId)
            .collection('progress')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          final List<dynamic>? stopsList = data[key];
          if (stopsList != null) {
            setState(() {
              _stops = stopsList.map((e) => e as int).toSet();
            });
            return;
          }
        }
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final stopsList = prefs.getStringList(key) ?? [];
    setState(() {
      _stops = stopsList.map((e) => int.parse(e)).toSet();
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
    
    final key = _getStopsKey();

    if (widget.khatmaId != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('khatms')
            .doc(widget.khatmaId)
            .collection('progress')
            .doc(user.uid)
            .set({
          key: _stops.toList(),
          'lastReadPart': widget.title,
          'lastReadTime': Timestamp.now(),
        }, SetOptions(merge: true));
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      _stops.map((e) => e.toString()).toList(),
    );
  }

  String _getStopsKey() {
    return widget.isSurah ? 'stops_surah_${widget.id}' : 'stops_juz_${widget.id}';
  }

  // Convert English numerals to Arabic numerals
  String _toArabicNumerals(int number) {
    const englishToArabicNumerals = {
      '0': '٠', '1': '١', '2': '٢', '3': '٣', '4': '٤',
      '5': '٥', '6': '٦', '7': '٧', '8': '٨', '9': '٩',
    };
    return number.toString().split('').map((digit) => englishToArabicNumerals[digit] ?? digit).join();
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'حفظ التقدم',
            style: TextStyle(fontFamily: 'Amiri', color: MainTheme.primaryColor),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'عند النقر على الآية، يتم حفظها كعلامة توقف. في المرة القادمة التي تدخل فيها إلى هذا الجزء من خلال الختمة، سينتقل التطبيق تلقائياً إلى آخر آية قمت بحفظها لإكمال القراءة بكل سهولة.',
            style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: MainTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('حسناً', style: TextStyle(fontFamily: 'Amiri', color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
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
                  transitionBuilder: (Widget child, Animation<double> animation) {
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(color: MainTheme.primaryColor),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        key: const ValueKey('error'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 50, color: Colors.red),
                            const SizedBox(height: 16),
                            const Text(
                              'عذراً، حدث خطأ أثناء جلب البيانات',
                              style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchData,
                              child: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Amiri')),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        key: ValueKey('no_data'),
                        child: Text('لا توجد بيانات'),
                      );
                    }

                    final data = snapshot.data!;
                    final List<dynamic> ayahs = data['ayahs'] ?? [];

                    // Trigger scroll after build if needed
                    if (!_hasAutoScrolled && _stops.isNotEmpty && widget.khatmaId != null) {
                      int maxStop = _stops.reduce((a, b) => a > b ? a : b);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_ayahKeys.containsKey(maxStop) && _ayahKeys[maxStop]!.currentContext != null) {
                          Scrollable.ensureVisible(
                            _ayahKeys[maxStop]!.currentContext!,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                          _hasAutoScrolled = true;
                        }
                      });
                    }

                    return Container(
                      key: const ValueKey('content'),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        /*borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],*/
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          child: Column(
                            children: [
                              ..._buildQuranContent(ayahs),
                              const SizedBox(height: 60),
                              const Text(
                                "صَدَقَ اللهُ العَظِيم",
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 22,
                                  color: MainTheme.primaryColor,
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
      int surahId = widget.isSurah ? widget.id : (ayah['surah'] != null ? ayah['surah']['number'] : widget.id);
      String surahName = ayah['surah'] != null ? ayah['surah']['name'] : '';

      if (surahId != currentSurahId) {
        flushWrap();

        if (currentSurahId != null) {
          // It's a split between surahs in a Juz
          content.add(const SizedBox(height: 30));
          content.add(Divider(color: MainTheme.primaryColor.withValues(alpha: 0.2), thickness: 1));
          content.add(const SizedBox(height: 20));
          content.add(
            Text(
              surahName,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 26,
                color: MainTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
          content.add(const SizedBox(height: 20));
        } else if (!widget.isSurah && surahName.isNotEmpty) {
          // Very first surah shown in this Juz
          content.add(
            Text(
              surahName,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 26,
                color: MainTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
          content.add(const SizedBox(height: 20));
        }

        // Add Basmalah if it's the start
        bool isStartOfSurah = ayah['numberInSurah'] == 1;
        bool showBismillah = isStartOfSurah && surahId != 1 && surahId != 9;
        
        // Also if we are viewing a single complete Surah from the beginning
        if (widget.isSurah && currentSurahId == null && surahId != 1 && surahId != 9) {
          showBismillah = true;
        }

        if (showBismillah) {
          content.add(
            const Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                color: MainTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
          content.add(const SizedBox(height: 20));
          content.add(Divider(color: MainTheme.primaryColor.withValues(alpha: 0.2), thickness: 1));
          content.add(const SizedBox(height: 20));
        }

        currentSurahId = surahId;
      }

      String ayahText = ayah['text'];
      String cleanedText = ayahText.replaceAll('\ufeff', ''); // remove zero width space
      
      if (surahId != 1 && surahId != 9 && ayah['numberInSurah'] == 1) {
        const String b1 = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
        const String b2 = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
        const String b3 = 'بسم الله الرحمن الرحيم';
        if (cleanedText.startsWith(b1)) {
          cleanedText = cleanedText.substring(b1.length).trim();
        } else if (cleanedText.startsWith(b2)) {
          cleanedText = cleanedText.substring(b2.length).trim();
        } else if (cleanedText.startsWith(b3)) {
          cleanedText = cleanedText.substring(b3.length).trim();
        }
      }
      ayahText = cleanedText;

      final int ayahNum = ayah['numberInSurah'];
      final bool isStop = _stops.contains(ayahNum);

      currentWrapChildren.add(_buildAyah(ayahText, ayahNum, isStop));
    }

    flushWrap();

    return content;
  }

  Widget _buildAyah(String text, int number, bool isStop) {
    if (!_ayahKeys.containsKey(number)) {
      _ayahKeys[number] = GlobalKey();
    }
    return GestureDetector(
      key: _ayahKeys[number],
      onTap: () => _toggleStop(number),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isStop ? MainTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
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
                  color: MainTheme.textPrimary,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/ayah_end.png'), // Will add a placeholder gracefully if not found
                      fit: BoxFit.contain,
                    ),
                    color: isStop ? MainTheme.primaryColor.withValues(alpha: 0.2) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _toArabicNumerals(number),
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: isStop ? MainTheme.primaryColor : MainTheme.textSecondary,
                        fontWeight: isStop ? FontWeight.bold : FontWeight.normal,
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
