// features/student/presentation/pages/coding_playground_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CodingPlaygroundPage extends StatelessWidget {
  const CodingPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Python Playground",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(
                        "main.py",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                        ),

                        onPressed: () {},

                        child: const Text("RUN"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Container(
                    height: 300,
                    width: double.infinity,

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),

                    child: const Text(
                      "import numpy as np",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Text(
                "Calculated Index: 38.9",
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}