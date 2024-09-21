import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/introductive_component.dart';
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

    // Listening for user's khatmsJoined in real-time
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    return userDoc.snapshots().asyncMap((snapshot) async {
      List<dynamic> khatmsJoinedUids = snapshot.data()?['khatmsJoined'] ?? [];

      // Fetch all khatms that the user hasn't joined
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MainTheme.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
                  color: Color(0x3F000000)),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: IntroductiveComponent(text: "الإنضمام لختمة موجودة"),
            ),
            SizedBox(height: 20),
            _searchField(), // Search bar to filter khatms
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream:
                    _getKhatmsStream(), // Use StreamBuilder to show data in real-time
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading data"));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    if (data.isEmpty) {
                      return Center(
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

                    // Display the list of khatms
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KhetmaPage(
                                        khetmaUid: data[index]['khetmaId']
                                                ?.toString() ??
                                            '')));
                          },
                          child: KhetmaComponent(
                            title: data[index]['name'] ?? 'Unknown',
                            participantsCount:
                                data[index]['currentParticipantsNumber'] ?? 0,
                            progress: (data[index]['completionPercent'] as num?)
                                    ?.toDouble() ??
                                0.0,
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No data available"));
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
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchForKhatms, // Trigger search on press
          ),
        ),
      ),
    );
  }
}
