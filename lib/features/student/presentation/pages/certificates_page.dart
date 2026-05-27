// features/student/presentation/pages/certificates_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Achievements",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [

          certificateCard(
            "Advanced Neural Networks",
          ),

          certificateCard(
            "Quantum Computing Basics",
          ),

          certificateCard(
            "Ethical AI Frameworks",
          ),
        ],
      ),
    );
  }

  Widget certificateCard(String title) {

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 180,

            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Issued Dec 2023",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}