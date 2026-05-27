// features/student/presentation/pages/notifications_page.dart

import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: 10,

        itemBuilder: (_, index) {

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),

            child: Row(
              children: [

                const Icon(Icons.notifications),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    "Assignment reminder ${index + 1}",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}