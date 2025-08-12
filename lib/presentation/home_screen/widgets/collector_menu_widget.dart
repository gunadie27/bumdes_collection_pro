import 'package:bumdes_collection_pro/core/app_export.dart';
import 'package:flutter/material.dart';

class CollectorMenuWidget extends StatelessWidget {
  const CollectorMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildMenuItem(
          context,
          icon: Icons.assignment,
          label: 'Formulir Penagihan',
          routeName: AppRoutes.collectionFormScreen,
        ),
        _buildMenuItem(
          context,
          icon: Icons.people,
          label: 'Detail Anggota',
          routeName: AppRoutes.memberDetailScreen,
        ),
        _buildMenuItem(
          context,
          icon: Icons.track_changes,
          label: 'Lacak Perjanjian',
          routeName: AppRoutes.agreementTrackingScreen,
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
