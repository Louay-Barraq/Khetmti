import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'عن التطبيق',
            showBackButton: true,
            showProfile: false,
            onBackTap: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSectionCard(
                    title: "ختمتي (Khetmti)",
                    icon: Icons.menu_book,
                    content:
                        "تطبيق ختمتي أُنشئ بهدف تسهيل وتشجيع قراءة القرآن الكريم وتنظيم الختمات الجماعية والفردية. نسأل الله أن يتقبل منا ومنكم صالح الأعمال وأن يجعله صدقة جارية.",
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "المطور",
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          offset: const Offset(0, 5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.greyishColor,
                          child: Icon(Icons.person,
                              size: 50, color: AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "لؤي البراق",
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Louay Barraq",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "مطور تطبيقات محمول",
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => _launchUrl(
                                  "https://github.com/louay-barraq"),
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black87
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.asset(
                                    'assets/images/github_logo.png',
                                    width: 32,
                                    height: 32),
                              ),
                            ),
                            const SizedBox(width: 20),
                            _socialButton(
                              icon: Icons.email,
                              color: Colors.redAccent,
                              url: "mailto:louaybarraq@gmail.com",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title,
      required IconData icon,
      required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            content,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              height: 1.6,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(
      {required IconData icon, required Color color, required String url}) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
