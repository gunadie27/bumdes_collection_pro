import 'package:flutter/material.dart';

import './widgets/about_section_widget.dart';
import './widgets/account_settings_widget.dart';
import './widgets/app_preferences_widget.dart';
import './widgets/data_management_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/security_settings_widget.dart';
import './widgets/supervisor_options_widget.dart';

class SettingsProfileManagement extends StatefulWidget {
  const SettingsProfileManagement({super.key});

  @override
  State<SettingsProfileManagement> createState() =>
      _SettingsProfileManagementState();
}

class _SettingsProfileManagementState extends State<SettingsProfileManagement> {
  bool _isSupervisor = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  void _loadUserRole() async {
    // Load user role from shared preferences
    // For demo, assuming collector role by default
    setState(() {
      _isSupervisor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pengaturan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            // Settings content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    const ProfileSectionWidget(),
                    const SizedBox(height: 24),

                    // Account Settings
                    const AccountSettingsWidget(),
                    const SizedBox(height: 24),

                    // Notification Preferences
                    const NotificationPreferencesWidget(),
                    const SizedBox(height: 24),

                    // App Preferences
                    const AppPreferencesWidget(),
                    const SizedBox(height: 24),

                    // Data Management
                    const DataManagementWidget(),
                    const SizedBox(height: 24),

                    // Security Settings
                    const SecuritySettingsWidget(),
                    const SizedBox(height: 24),

                    // Supervisor Only Options
                    if (_isSupervisor) ...[
                      const SupervisorOptionsWidget(),
                      const SizedBox(height: 24),
                    ],

                    // About Section
                    const AboutSectionWidget(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
