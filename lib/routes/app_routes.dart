import 'package:flutter/material.dart';

import '../presentation/collection_form_screen/collection_form_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/member_detail_screen/member_detail_screen.dart';
import '../presentation/notification_center/notification_center.dart';
import '../presentation/overdue_accounts_dashboard/overdue_accounts_dashboard.dart';
import '../presentation/profile_analysis_screen/profile_analysis_screen.dart';
import '../presentation/settings_profile_management/settings_profile_management.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/supervisor_monitoring_dashboard/supervisor_monitoring_dashboard.dart';
import '../presentation/detailed_reports_screen/detailed_reports_screen.dart';
import '../presentation/agreement_tracking_screen/agreement_tracking_screen.dart';
import '../presentation/data_export_analytics_hub/data_export_analytics_hub.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String supervisorMonitoringDashboard =
      '/supervisor-monitoring-dashboard';
  static const String overdueAccountsDashboard = '/overdue-accounts-dashboard';
  static const String memberDetailScreen = '/member-detail-screen';
  static const String collectionFormScreen = '/collection-form-screen';
  static const String profileAnalysisScreen = '/profile-analysis-screen';
  static const String notificationCenter = '/notification-center';
  static const String settingsProfileManagement =
      '/settings-profile-management';
  static const String detailedReportsScreen = '/detailed-reports-screen';
  static const String agreementTrackingScreen = '/agreement-tracking-screen';
  static const String dataExportAnalyticsHub = '/data-export-analytics-hub';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    supervisorMonitoringDashboard: (context) =>
        const SupervisorMonitoringDashboard(),
    overdueAccountsDashboard: (context) => const OverdueAccountsDashboard(),
    memberDetailScreen: (context) => const MemberDetailScreen(),
    collectionFormScreen: (context) => const CollectionFormScreen(),
    profileAnalysisScreen: (context) => const ProfileAnalysisScreen(),
    notificationCenter: (context) => const NotificationCenter(),
    settingsProfileManagement: (context) => const SettingsProfileManagement(),
    detailedReportsScreen: (context) => const DetailedReportsScreen(),
    agreementTrackingScreen: (context) => const AgreementTrackingScreen(),
    dataExportAnalyticsHub: (context) => const DataExportAnalyticsHub(),
    // TODO: Add your other routes here
  };
}
