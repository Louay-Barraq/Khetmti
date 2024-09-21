// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/introductive_component.dart';

import '../../themes/main_theme.dart';

class KhetmaPage extends StatefulWidget {
  final String khetmaUid;
  const KhetmaPage({super.key, required this.khetmaUid});

  @override
  State<KhetmaPage> createState() => _KhetmaPageState();
}

class _KhetmaPageState extends State<KhetmaPage> {
  User user = FirebaseAuth.instance.currentUser!;
  final _searchController = TextEditingController();
  Map<String, dynamic> allKhetmaInfos = {};
  Map<String, dynamic> allSourasInfos = {};
  bool isLoading = true;

  Map<String, dynamic> khetmaDetails = {
    'عــدد المشاركين الحاليين': null,
    'العــدد الأقــصى للمشاركين': null,
    'نسبــة إكتمــال الختمة': null,
    'عــدد السور المكتملة': null,
    'عــدد السور غير المكتملة': null,
  };

  void _bookSoura(String name) async {
    try {
      final khetmaRef =
          FirebaseFirestore.instance.collection('khatms').doc(widget.khetmaUid);
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot khetmaSnapshot = await transaction.get(khetmaRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (khetmaSnapshot.exists) {
          Map<String, dynamic>? data =
              khetmaSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            Map<String, dynamic> souras = data['souras'];
            if (souras[name] == null) {
              souras[name] = user.displayName!;

              transaction.update(khetmaRef, {
                'souras': souras,
                'finishedSouras': data['finishedSouras'] + 1,
                'unfinishedSouras': data['unfinishedSouras'] - 1,
                'finishedAyahs': data['finishedAyahs'] + sourasWithAyahs[name]!,
                'participants': FieldValue.arrayUnion([user.uid]),
                'updatedAt': Timestamp.now(),
              });

              double newCompletionPercent =
                  (data['finishedAyahs'] + sourasWithAyahs[name]!) / 6236;
              final usersSet = (data['souras'] as Map)
                  .values
                  .where((value) => value != null)
                  .toList()
                  .toSet();

              transaction.update(khetmaRef, {
                'completionPercent':
                    newCompletionPercent > 1 ? 1 : newCompletionPercent,
                'currentParticipantsNumber': usersSet.length,
              });

              Map<String, dynamic>? userData =
                  userSnapshot.data() as Map<String, dynamic>?;

              List<String> currentUserKhatms = userData != null
                  ? List.from(userData['khatmsJoined'] ?? [])
                  : [];
              if (!currentUserKhatms.contains(widget.khetmaUid)) {
                currentUserKhatms.add(widget.khetmaUid);
                transaction
                    .update(userRef, {'khatmsJoined': currentUserKhatms});
              }
            }
          }
        }
      });
    } catch (e) {
      print("Error booking soura: $e");
    }
  }

  void _removeSouraBooking(String name) async {
    try {
      final khetmaRef =
          FirebaseFirestore.instance.collection('khatms').doc(widget.khetmaUid);
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot khetmaSnapshot = await transaction.get(khetmaRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (khetmaSnapshot.exists) {
          Map<String, dynamic>? data =
              khetmaSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            Map<String, dynamic> souras = data['souras'];
            if (souras[name] == user.displayName) {
              souras[name] = null;

              transaction.update(khetmaRef, {
                'souras': souras,
                'finishedSouras': data['finishedSouras'] - 1,
                'unfinishedSouras': data['unfinishedSouras'] + 1,
                'finishedAyahs': data['finishedAyahs'] - sourasWithAyahs[name]!,
                'updatedAt': Timestamp.now(),
              });

              double newCompletionPercent =
                  (data['finishedAyahs'] - sourasWithAyahs[name]!) / 6236;

              final usersList = (data['souras'] as Map)
                  .values
                  .where((value) => value != null)
                  .toList();

              final usersSet = (data['souras'] as Map)
                  .values
                  .where((value) => value != null)
                  .toList()
                  .toSet();

              int userOccurencesCounter = 0;
              usersList.forEach((item) {
                if (item == user.displayName) {
                  userOccurencesCounter++;
                }
              });

              if ((usersSet.contains(user.uid)) &&
                  (user.uid == data['creatorId'])) {
                transaction.update(khetmaRef, {
                  'completionPercent':
                      newCompletionPercent < 0 ? 0 : newCompletionPercent,
                  'currentParticipantsNumber': usersSet.length,
                });
              } else if ((!usersSet.contains(user.uid)) &&
                  (user.uid == data['creatorId'])) {
                transaction.update(khetmaRef, {
                  'completionPercent':
                      newCompletionPercent < 0 ? 0 : newCompletionPercent,
                  'currentParticipantsNumber': usersSet.length + 1,
                });
              } else if (user.uid != data['creatorId']) {
                if (userOccurencesCounter >= 2) {
                  transaction.update(khetmaRef, {
                    'completionPercent':
                        newCompletionPercent < 0 ? 0 : newCompletionPercent,
                    'currentParticipantsNumber': usersSet.length,
                  });
                } else {
                  transaction.update(khetmaRef, {
                    'completionPercent':
                        newCompletionPercent < 0 ? 0 : newCompletionPercent,
                    'currentParticipantsNumber': usersSet.length,
                    'participants': FieldValue.arrayRemove([user.uid]),
                  });
                }
              }

              Map<String, dynamic>? userData =
                  userSnapshot.data() as Map<String, dynamic>?;

              List<String> currentUserKhatms = userSnapshot.data() != null
                  ? List.from(userData?['khatmsJoined'] ?? [])
                  : [];
              if (user.uid == data['creatorId']) {
                return;
              }

              if (userOccurencesCounter == 1) {
                if (currentUserKhatms.contains(widget.khetmaUid)) {
                  currentUserKhatms.remove(widget.khetmaUid);
                  transaction
                      .update(userRef, {'khatmsJoined': currentUserKhatms});
                }
              }
            }
          }
        }
      });
    } catch (e) {
      print("Error removing soura booking: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainTheme.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ختمتـــــــي",
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            shadows: const [
              Shadow(
                offset: Offset(0, 4),
                blurRadius: 2.5,
                color: Color(0x3F000000),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('khatms')
            .doc(widget.khetmaUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Error loading data."));
          }

          Map<String, dynamic> khetmaData =
              snapshot.data!.data() as Map<String, dynamic>;
          Map<String, dynamic> souras = khetmaData['souras'];

          return Column(
            children: [
              SizedBox(height: 20),
              IntroductiveComponent(text: " ختمة لفائدة ${khetmaData['name']}"),
              SizedBox(height: 20),
              _detailsBox(khetmaData),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: sourasWithAyahs.length,
                  itemBuilder: (context, index) {
                    String souraName = sourasWithAyahs.keys.toList()[index];
                    String? reader = souras[souraName];

                    return _souraBox(
                      name: souraName,
                      readerName: reader,
                      currentUserName: user.displayName!,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _souraBox({
    required String name,
    required String? readerName,
    required String currentUserName,
  }) {
    String souraName = " ســـورة";
    String readerText = readerName == null
        ? "غيـــر محجـوزة"
        : readerName == currentUserName
            ? "محجـوزة من قبلك"
            : "محجـوزة من قبل  : $readerName";

    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MainTheme.greyishColor,
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
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      souraName,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Text(
                  readerText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: readerName == null
                        ? Colors.black
                        : readerName == currentUserName
                            ? MainTheme.primaryColor
                            : MainTheme.redishColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF2F2F2),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 3,
                  spreadRadius: 1,
                  color: Color(0x3F000000),
                )
              ],
            ),
            child: _customIcon(
              status: readerName == null
                  ? "book"
                  : readerName == currentUserName
                      ? "remove"
                      : null,
              onTap: readerName == null
                  ? () => _bookSoura(name)
                  : readerName == currentUserName
                      ? () => _removeSouraBooking(name)
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customIcon({required String? status, required Function()? onTap}) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case "book":
        iconData = Icons.bookmark_add_outlined;
        iconColor = MainTheme.primaryColor;
        break;
      case "remove":
        iconData = Icons.bookmark_remove_outlined;
        iconColor = MainTheme.redishColor;
        break;
      default:
        iconData = Icons.circle;
        iconColor = MainTheme.greyishColor;
    }

    return InkWell(
      onTap: onTap,
      child: Icon(iconData, size: 35, color: iconColor),
    );
  }

  Widget _detailsBox(Map<String, dynamic> khetmaData) {
    return Center(
      child: Container(
        height: 225,
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: MainTheme.greyishColor,
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
        child: ListView(
          children: [
            _detailRow(
                key: 'عــدد المشاركين الحاليين',
                value: khetmaData['currentParticipantsNumber']),
            _detailRow(
                key: 'العــدد الأقــصى للمشاركين',
                value: khetmaData['maxParticipantsNumber']),
            _detailRow(
                key: 'نسبــة إكتمــال الختمة',
                value:
                    "${(khetmaData['completionPercent'] * 100).toStringAsFixed(1)}%"),
            // "Test"),
            _detailRow(
                key: 'عــدد السور المكتملة',
                value: khetmaData['finishedSouras']),
            _detailRow(
                key: 'عــدد السور غير المكتملة',
                value: khetmaData['unfinishedSouras']),
          ],
        ),
      ),
    );
  }

  Widget _detailRow({required dynamic key, required dynamic value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 200,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: Color(0x3F000000),
                )
              ],
            ),
            child: Center(
              child: Text(
                key,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              color: MainTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 2,
                  color: Color(0x3F000000),
                )
              ],
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 45,
      decoration: BoxDecoration(
        color: MainTheme.greyishColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x3F000000),
          ),
        ],
      ),
      child: TextFormField(
        controller: _searchController,
        keyboardType: TextInputType.text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'Amiri',
          fontSize: 20,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // hintText: 'ابحث عن سورة',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Map<String, int> sourasWithAyahs = {
    "الفاتحة": 7,
    "البقرة": 286,
    "آل عمران": 200,
    "النساء": 176,
    "المائدة": 120,
    "الأنعام": 165,
    "الأعراف": 206,
    "الأنفال": 75,
    "التوبة": 129,
    "يونس": 109,
    "هود": 123,
    "يوسف": 111,
    "الرعد": 43,
    "إبراهيم": 52,
    "الحجر": 99,
    "النحل": 128,
    "الإسراء": 111,
    "الكهف": 110,
    "مريم": 98,
    "طه": 135,
    "الأنبياء": 112,
    "الحج": 78,
    "المؤمنون": 118,
    "النور": 64,
    "الفرقان": 77,
    "الشعراء": 227,
    "النمل": 93,
    "القصص": 88,
    "العنكبوت": 69,
    "الروم": 60,
    "لقمان": 34,
    "السجدة": 30,
    "الأحزاب": 73,
    "سبأ": 54,
    "فاطر": 45,
    "يس": 83,
    "الصافات": 182,
    "ص": 88,
    "الزمر": 75,
    "غافر": 85,
    "فصلت": 54,
    "الشورى": 53,
    "الزخرف": 89,
    "الدخان": 59,
    "الجاثية": 37,
    "الأحقاف": 35,
    "محمد": 38,
    "الفتح": 29,
    "الحجرات": 18,
    "ق": 45,
    "الذاريات": 60,
    "الطور": 49,
    "النجم": 62,
    "القمر": 55,
    "الرحمن": 78,
    "الواقعة": 96,
    "الحديد": 29,
    "المجادلة": 22,
    "الحشر": 24,
    "الممتحنة": 13,
    "الصف": 14,
    "الجمعة": 11,
    "المنافقون": 11,
    "التغابن": 18,
    "الطلاق": 12,
    "التحريم": 12,
    "الملك": 30,
    "القلم": 52,
    "الحاقة": 52,
    "المعارج": 44,
    "نوح": 28,
    "الجن": 28,
    "المزمل": 20,
    "المدثر": 56,
    "القيامة": 40,
    "الإنسان": 31,
    "المرسلات": 50,
    "النبأ": 40,
    "النازعات": 46,
    "عبس": 42,
    "التكوير": 29,
    "الانفطار": 19,
    "المطففين": 36,
    "الإنشقاق": 25,
    "البروج": 22,
    "الطارق": 17,
    "الأعلى": 19,
    "الغاشية": 26,
    "الفجر": 30,
    "البلد": 20,
    "الشمس": 15,
    "الليل": 21,
    "الضحى": 11,
    "الشرح": 8,
    "التين": 8,
    "العلق": 19,
    "القدر": 5,
    "البينة": 8,
    "الزلزلة": 8,
    "العاديات": 11,
    "القارعة": 11,
    "التكاثر": 8,
    "العصر": 3,
    "الهمزة": 9,
    "الفيل": 5,
    "قريش": 4,
    "الماعون": 7,
    "الكوثر": 3,
    "الكافرون": 6,
    "النصر": 3,
    "المسد": 5,
    "الإخلاص": 4,
    "الفلق": 5,
    "الناس": 6
  };
}
