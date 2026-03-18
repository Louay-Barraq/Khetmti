import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../themes/main_theme.dart';
import '../../components/khetmti_header.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'louaybarraq@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'دعم تطبيق ختمتي',
      }),
    );
    if (!await launchUrl(emailLaunchUri)) {
      debugPrint('Could not launch email');
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'المساعدة والدعم',
            showBackButton: true,
            showNotification: false,
            showProfile: false,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                const Text(
                  "تواصل معنا",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MainTheme.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: _launchEmail,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: MainTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.email_outlined, color: MainTheme.primaryColor, size: 30),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                "عبر البريد الإلكتروني",
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: MainTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "louaybarraq@gmail.com",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MainTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_back_ios, size: 16, color: MainTheme.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "الأسئلة الشائعة",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MainTheme.textPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 15),
                _buildFaqItem(
                  question: "كيف يمكنني إنشاء ختمة جديدة؟",
                  answer: "يمكنك إنشاء ختمة جديدة من خلال الصفحة الرئيسية بالضغط على زر '+'، ثم تحديد نوع التقسيم (أجزاء أو سور) وعدد المشاركين المطلوب.",
                ),
                _buildFaqItem(
                  question: "كيف أنضم لختمة موجودة؟",
                  answer: "اطلب رمز الانضمام من منشئ الختمة، ثم من الصفحة الرئيسية اختر 'الانضمام لختمة' وأدخل الرمز.",
                ),
                _buildFaqItem(
                  question: "كيف يمكنني حجز جزء للقراءة؟",
                  answer: "بعد الدخول إلى الختمة، ستجد قائمة بالأجزاء أو السور، اضغط على زر الحجز بجانب الجزء المتاح (غير المحجوز) ليصبح باسمك.",
                ),
                _buildFaqItem(
                  question: "هل يمكنني قراءة القرآن داخل التطبيق؟",
                  answer: "نعم! عند دخولك لأي سورة أو جزء في الختمة أو من ملفك الشخصي، سيفتح لك التطبيق المصحف لقراءته مباشرة.",
                ),
                _buildFaqItem(
                  question: "هل يمكنني القراءة بدون إنترنت؟",
                  answer: "يحتاج التطبيق لاتصال بالإنترنت عند فتح الصفحة لأول مرة، لكننا نعمل على توفير ميزة الحفظ التلقائي للقراءة دون إنترنت قريباً.",
                ),
                _buildFaqItem(
                  question: "كيف يمكن معرفة إحصائيات قراءتي؟",
                  answer: "من خلال صفحة الملف الشخصي (الحساب)، ستجد تبويب 'الإحصائيات' الذي يعرض لك عدد الأجزاء والسور التي قرأتها.",
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MainTheme.textPrimary,
          ),
        ),
        iconColor: MainTheme.primaryColor,
        collapsedIconColor: MainTheme.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Text(
            answer,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: MainTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
