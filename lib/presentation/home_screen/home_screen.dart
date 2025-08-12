import 'package:bumdes_collection_pro/core/app_export.dart';
import 'package:bumdes_collection_pro/presentation/home_screen/widgets/collector_menu_widget.dart';
import 'package:bumdes_collection_pro/presentation/home_screen/widgets/supervisor_menu_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HomeScreen extends StatelessWidget {
  String userRole;

  HomeScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (userRole == 'kolektor') {
      return const CollectorMenuWidget();
    } else if (userRole == 'supervisor') {
      return const SupervisorMenuWidget();
    } else {
      return const Center(
        child: Text('Peran pengguna tidak dikenal.'),
      );
    }
  }
}
