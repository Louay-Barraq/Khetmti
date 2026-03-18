import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/introductive_component.dart';
import '../../components/khetmti_app_bar.dart';
import '../../themes/main_theme.dart';
import '../Khetma/Khetma_page.dart';

class KhatmsSearchPage extends StatefulWidget {
  const KhatmsSearchPage({super.key});

  @override
  _KhatmsSearchPageState createState() => _KhatmsSearchPageState();
}

class _KhatmsSearchPageState extends State<KhatmsSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';

  // Fetch all khatms that the user hasn't joined
  Stream<List<Map<String, dynamic>>> _getKhatmsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Stream.value([]);
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    return userDoc.snapshots().asyncMap((snapshot) async {
      List<dynamic> khatmsJoinedUids = snapshot.data()?['khatmsJoined'] ?? [];

      QuerySnapshot allKhatmsSnapshot =
          await FirebaseFirestore.instance.collection('khatms').get();

      List<Map<String, dynamic>> allKhatms = allKhatmsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Filter out the khatms that the user has already joined
      List<Map<String, dynamic>> notJoinedKhatms = allKhatms
          .where((khetma) => !khatmsJoinedUids.contains(khetma['khetmaId']))
          .toList();

      // Apply search filtering if a query is provided
      if (_searchQuery.isNotEmpty) {
        notJoinedKhatms = notJoinedKhatms.where((khetma) {
          final name = khetma['name']?.toString().toLowerCase() ?? '';
          return name.contains(_searchQuery.toLowerCase());
        }).toList();
      }

      return notJoinedKhatms;
    });
  }

  Future<void> _searchForKhatms() async {
    setState(() {
      _searchQuery = _controller.text.trim();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const KhetmtiAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: IntroductiveComponent(text: "الإنضمام لختمة موجودة"),
            ),
            const SizedBox(height: 20),
            _searchField(),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getKhatmsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "حدث خطأ أثناء تحميل البيانات",
                        style: TextStyle(fontFamily: 'Amiri', fontSize: 20),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    if (data.isEmpty) {
                      return const Center(
                        child: Text(
                          "لا يوجد ختمة مطابقة للبحث",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KhetmaPage(
                                  khetmaUid:
                                      data[index]['khetmaId']?.toString() ?? '',
                                ),
                              ),
                            );
                          },
                          child: KhetmaComponent(
                            title: data[index]['name'] ?? 'Unknown',
                            participantsCount:
                                data[index]['currentParticipantsNumber'] ?? 0,
                            progress:
                                (data[index]['completionPercent'] as num?)
                                        ?.toDouble() ??
                                    0.0,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "لا توجد بيانات",
                        style: TextStyle(fontFamily: 'Amiri', fontSize: 20),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
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
        controller: _controller,
        keyboardType: TextInputType.text,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchForKhatms,
          ),
        ),
      ),
    );
  }
}
