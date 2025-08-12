import 'package:bumdes_collection_pro/core/app_export.dart';
import 'package:flutter/material.dart';

class SupervisorMenuWidget extends StatelessWidget {
  const SupervisorMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMenuItem(
          context,
          icon: Icons.dashboard,
          label: 'Pemantauan Supervisor',
          routeName: AppRoutes.supervisorMonitoringDashboard,
        ),
        _buildMenuItem(
          context,
          icon: Icons.warning,
          label: 'Akun Lewat Jatuh Tempo',
          routeName: AppRoutes.overdueAccountsDashboard,
        ),
        _buildMenuItem(
          context,
          icon: Icons.bar_chart,
          label: 'Laporan Rinci',
          routeName: AppRoutes.detailedReportsScreen,
        ),
        _buildMenuItem(
          context,
          icon: Icons.analytics,
          label: 'Hub Analitik Ekspor Data',
          routeName: AppRoutes.dataExportAnalyticsHub,
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String label,
      required String routeName}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0),
            const SizedBox(height: 8.0),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
