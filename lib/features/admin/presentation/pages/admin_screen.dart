import 'package:flutter/material.dart';

import '../../../shared/role_portal_page.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RolePortalPage(
      endpoint: "/admin/dashboard",
      fallbackTitle: "Admin",
      accent: Color(0xFF14A0E0),
    );
  }
}
