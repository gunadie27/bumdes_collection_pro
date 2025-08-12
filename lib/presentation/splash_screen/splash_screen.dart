import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bumdes_logo_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_button_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  bool _showRetryButton = false;
  bool _isInitializing = true;

  // Mock user data for demonstration
  final Map<String, dynamic> _mockUserData = {
    "isAuthenticated": true,
    "userRole":
        "field_collector", // Options: "field_collector", "supervisor", "admin"
    "userId": "FC001",
    "userName": "Ahmad Rizki",
    "lastSyncTime": "2025-01-22T19:44:41.951852",
    "hasOfflineData": true,
    "pendingCollections": 12,
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: AppTheme.primaryLight,
      end: AppTheme.primaryVariantLight,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.repeat(reverse: true);
  }

  Future<void> _initializeApp() async {
    setState(() {
      _isInitializing = true;
      _showRetryButton = false;
    });

    try {
      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasConnection = connectivityResult != ConnectivityResult.none;

      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _syncOfflineData(hasConnection),
        _prepareCachedRecords(),
        Future.delayed(
            const Duration(milliseconds: 2500)), // Minimum splash time
      ]);

      // Navigate based on authentication and role
      await _navigateToNextScreen();
    } catch (e) {
      // Show retry option after 5 seconds
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _showRetryButton = true;
        });
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Simulate checking stored authentication
    await Future.delayed(const Duration(milliseconds: 800));

    // Store mock authentication data
    await prefs.setBool('isAuthenticated', _mockUserData['isAuthenticated']);
    await prefs.setString('userRole', _mockUserData['userRole']);
    await prefs.setString('userId', _mockUserData['userId']);
    await prefs.setString('userName', _mockUserData['userName']);
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 600));

    // Store mock preferences
    await prefs.setString('lastSyncTime', _mockUserData['lastSyncTime']);
    await prefs.setBool('hasOfflineData', _mockUserData['hasOfflineData']);
    await prefs.setInt(
        'pendingCollections', _mockUserData['pendingCollections']);
  }

  Future<void> _syncOfflineData(bool hasConnection) async {
    if (!hasConnection) return;

    // Simulate syncing offline data
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mock sync process
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSyncTime', DateTime.now().toIso8601String());
  }

  Future<void> _prepareCachedRecords() async {
    // Simulate preparing cached collection records
    await Future.delayed(const Duration(milliseconds: 900));

    // Mock cached data preparation
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cachedRecordsCount', 45);
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final userRole = prefs.getString('userRole') ?? '';

    // Smooth fade transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (!isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/login-screen');
    } else {
      switch (userRole) {
        case 'field_collector':
          Navigator.pushReplacementNamed(
              context, '/overdue-accounts-dashboard');
          break;
        case 'supervisor':
        case 'admin':
          Navigator.pushReplacementNamed(
              context, '/supervisor-monitoring-dashboard');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/login-screen');
      }
    }
  }

  void _handleRetry() {
    _initializeApp();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryVariantLight,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _backgroundAnimation.value ?? AppTheme.primaryLight,
                    AppTheme.primaryVariantLight,
                    AppTheme.secondaryVariantLight,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const BumdesLogoWidget(),
                            SizedBox(height: 8.h),
                            _showRetryButton
                                ? RetryButtonWidget(onRetry: _handleRetry)
                                : _isInitializing
                                    ? const LoadingIndicatorWidget()
                                    : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'verified',
                                color: AppTheme.lightTheme.colorScheme.surface
                                    .withValues(alpha: 0.8),
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Terdaftar Kementerian Desa PDTT',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.lightTheme.colorScheme.surface
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Versi 1.0.0 • Build 2025.01.22',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.lightTheme.colorScheme.surface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
