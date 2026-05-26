import '../../data/role_catalog.dart';
import '../../widgets/role_dashboard.dart';

class SuperAdminScreen extends RoleDashboard {
  SuperAdminScreen({super.key}) : super(role: roleCatalog[0]);
}
