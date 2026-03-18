import 'package:flutter/material.dart';
import 'package:khetmti/components/khetmti_header.dart';
import 'package:khetmti/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khetmti/pages/actions/notifications_page.dart';
import '../../themes/main_theme.dart';

class JoinKhatmaPage extends StatefulWidget {
  const JoinKhatmaPage({super.key});

  @override
  State<JoinKhatmaPage> createState() => _JoinKhatmaPageState();
}

class _JoinKhatmaPageState extends State<JoinKhatmaPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _joinMethod = 'code'; // 'code' or 'name'
  List<DocumentSnapshot> _searchResults = [];

  Future<void> _joinKhatma(String khetmaId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      showErrorToast("يجب تسجيل الدخول أولاً");
      return;
    }

    setState(() => _isLoading = true);
    showLoadingDialog(context);

    try {
      final docRef = FirebaseFirestore.instance.collection('khatms').doc(khetmaId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        if (mounted) dismissLoadingDialog(context);
        showErrorToast("الختمة غير موجودة");
        setState(() => _isLoading = false);
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final List participants = data['participants'] ?? [];

      if (participants.contains(userId)) {
        if (mounted) {
          dismissLoadingDialog(context);
          setState(() => _isLoading = false);
        }
        showWarningToast("أنت منضم بالفعل لهذه الختمة");
        return;
      }

      final int current = data['currentParticipantsNumber'] ?? 0;
      final int max = data['maxParticipantsNumber'] ?? 999;

      if (current >= max) {
        if (mounted) {
          dismissLoadingDialog(context);
          setState(() => _isLoading = false);
        }
        showErrorToast("عذراً، هذه الختمة مكتملة العدد");
        return;
      }

      await docRef.update({
        'participants': FieldValue.arrayUnion([userId]),
        'currentParticipantsNumber': FieldValue.increment(1),
      });

      if (mounted) {
        dismissLoadingDialog(context);
        showSuccessToast("تم الانضمام بنجاح!");
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        dismissLoadingDialog(context);
        setState(() => _isLoading = false);
      }
      showErrorToast("حدث خطأ أثناء الانضمام");
    }
  }

  Future<void> _searchByName() async {
    final name = _searchController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('khatms')
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: '$name\uf8ff')
          .limit(10)
          .get();

      setState(() {
        _searchResults = querySnapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorToast("حدث خطأ أثناء البحث");
    }
  }

  Future<void> _joinByCode() async {
    final code = _codeController.text.trim();
    if (code.length != 5) {
      showErrorToast("يرجى إدخال رمز مكون من 5 أرقام");
      return;
    }

    setState(() => _isLoading = true);
    showLoadingDialog(context);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('khatms')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        if (mounted) {
          dismissLoadingDialog(context);
          setState(() => _isLoading = false);
        }
        showErrorToast("الرمز غير صحيح أو الختمة غير موجودة");
        return;
      }

      final khetmaId = querySnapshot.docs.first.id;
      if (mounted) dismissLoadingDialog(context);
      await _joinKhatma(khetmaId);
    } catch (e) {
      if (mounted) {
        dismissLoadingDialog(context);
        setState(() => _isLoading = false);
      }
      showErrorToast("حدث خطأ أثناء البحث عن الرمز");
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'الانضمام لختمة',
            showProfile: false,
            showBackButton: true,
            onBackTap: () => Navigator.pop(context),
            onNotificationTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsPage()),
            ),
          ),
          const SizedBox(height: 20),
          _buildMethodChoice(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _joinMethod == 'code' ? _buildCodeView() : _buildNameView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodChoice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: MainTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _buildChoiceItem('بواسطة الإسم', 'name')),
          Expanded(child: _buildChoiceItem('بواسطة الرمز', 'code')),
        ],
      ),
    );
  }

  Widget _buildChoiceItem(String label, String method) {
    bool isSelected = _joinMethod == method;
    return GestureDetector(
      onTap: () => setState(() {
        _joinMethod = method;
        _searchResults = [];
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? MainTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : MainTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.vpn_key_outlined, size: 80, color: MainTheme.primaryColor),
        const SizedBox(height: 24),
        const Text(
          'أدخل رمز الانضمام',
          style: TextStyle(fontFamily: 'Amiri', fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'الرمز مكون من 5 أرقام حصلت عليه من منشئ الختمة',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Amiri', fontSize: 16, color: MainTheme.textSecondary),
        ),
        const SizedBox(height: 48),
        _buildCodeInput(),
        const SizedBox(height: 48),
        _buildJoinButton(),
      ],
    );
  }

  Widget _buildNameView() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'ابحث عن اسم الختمة...',
            hintStyle: const TextStyle(fontFamily: 'Amiri'),
            prefixIcon: IconButton(
              icon: const Icon(Icons.search, color: MainTheme.primaryColor),
              onPressed: _searchByName,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
          onSubmitted: (_) => _searchByName(),
        ),
        const SizedBox(height: 24),
        if (_isLoading) const CircularProgressIndicator(),
        if (!_isLoading && _searchResults.isEmpty && _searchController.text.isNotEmpty)
          const Text('لا توجد نتائج', style: TextStyle(fontFamily: 'Amiri')),
        ..._searchResults.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
            ),
            child: ListTile(
              title: Text(data['name'], textDirection: TextDirection.rtl, style: const TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold)),
              subtitle: Text('المشاركون: ${data['currentParticipantsNumber']}/${data['maxParticipantsNumber']}', textDirection: TextDirection.rtl),
              trailing: ElevatedButton(
                onPressed: () => _joinKhatma(doc.id),
                style: ElevatedButton.styleFrom(backgroundColor: MainTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('انضمام', style: TextStyle(color: Colors.white, fontFamily: 'Amiri')),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCodeInput() {
    return Container(
      width: 250,
      child: TextField(
        controller: _codeController,
        maxLength: 5,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 20,
          color: MainTheme.primaryColor,
        ),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MainTheme.primaryColor.withOpacity(0.3), width: 2),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MainTheme.primaryColor, width: 2),
          ),
          hintText: "00000",
          hintStyle: TextStyle(color: MainTheme.primaryColor.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: MainTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: MainTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isLoading ? null : _joinByCode,
          child: const Center(
            child: Text(
              'انضم الآن',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
