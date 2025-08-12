import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../presentation/home_screen/home_screen.dart';
import './widgets/bumdes_logo_widget.dart';
import './widgets/error_message_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  // Mock credentials for different user roles
  final Map<String, Map<String, dynamic>> _mockCredentials = {
    'collector001': {
      'password': 'bumdes123',
      'role': 'collector',
      'name': 'Ahmad Rizki',
      'route': '/overdue-accounts-dashboard',
    },
    'collector002': {
      'password': 'bumdes123',
      'role': 'collector',
      'name': 'Siti Nurhaliza',
      'route': '/overdue-accounts-dashboard',
    },
    'supervisor001': {
      'password': 'admin123',
      'role': 'supervisor',
      'name': 'Budi Santoso',
      'route': '/supervisor-monitoring-dashboard',
    },
    'admin001': {
      'password': 'admin123',
      'role': 'admin',
      'name': 'Dewi Sartika',
      'route': '/supervisor-monitoring-dashboard',
    },
  };

  @override
  void initState() {
    super.initState();
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _handleLogin(String employeeId, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check credentials
    final credentials = _mockCredentials[employeeId.toLowerCase()];

    if (credentials == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'ID karyawan tidak ditemukan. Periksa kembali ID Anda.';
      });
      return;
    }

    if (credentials['password'] != password) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Password salah. Periksa kembali password Anda.';
      });
      return;
    }

    // Successful login
    HapticFeedback.mediumImpact();

    // Navigate to HomeScreen with the user's role
    final role = credentials['role'] as String;
    final newRole = role == "collector" ? "kolektor" : "supervisor";

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userRole: newRole),
        ),
      );
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _clearError();
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),

                    // BUMDes Logo
                    const BumdesLogoWidget(),

                    SizedBox(height: 6.h),

                    // Error Message
                    ErrorMessageWidget(
                      errorMessage: _errorMessage,
                      onRetry: _clearError,
                    ),

                    // Login Form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Version Info
                    Text(
                      'Versi 1.0.0 • BUMDes Bersama',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
