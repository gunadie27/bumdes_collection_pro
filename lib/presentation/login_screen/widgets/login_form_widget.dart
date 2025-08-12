import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String employeeId, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.onLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _employeeIdFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isEmployeeIdValid = false;
  bool _isPasswordValid = false;
  String? _employeeIdError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _employeeIdController.addListener(_validateEmployeeId);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    _employeeIdFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateEmployeeId() {
    final value = _employeeIdController.text;
    setState(() {
      if (value.isEmpty) {
        _employeeIdError = 'ID karyawan wajib diisi';
        _isEmployeeIdValid = false;
      } else if (value.length < 3) {
        _employeeIdError = 'ID karyawan minimal 3 karakter';
        _isEmployeeIdValid = false;
      } else {
        _employeeIdError = null;
        _isEmployeeIdValid = true;
      }
    });
  }

  void _validatePassword() {
    final value = _passwordController.text;
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password wajib diisi';
        _isPasswordValid = false;
      } else if (value.length < 6) {
        _passwordError = 'Password minimal 6 karakter';
        _isPasswordValid = false;
      } else {
        _passwordError = null;
        _isPasswordValid = true;
      }
    });
  }

  bool get _isFormValid =>
      _isEmployeeIdValid && _isPasswordValid && !widget.isLoading;

  void _handleLogin() {
    if (_isFormValid) {
      HapticFeedback.lightImpact();
      widget.onLogin(_employeeIdController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Employee ID Field
        TextFormField(
          controller: _employeeIdController,
          focusNode: _employeeIdFocusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          enabled: !widget.isLoading,
          decoration: InputDecoration(
            labelText: 'ID Karyawan',
            hintText: 'Masukkan ID karyawan',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: _employeeIdFocusNode.hasFocus
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
            ),
            errorText: _employeeIdError,
            suffixIcon: _isEmployeeIdValid
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 5.w,
                    ),
                  )
                : null,
          ),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),

        SizedBox(height: 2.h),

        // Password Field
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !_isPasswordVisible,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          enabled: !widget.isLoading,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Masukkan password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: _passwordFocusNode.hasFocus
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isPasswordValid)
                  Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 5.w,
                    ),
                  ),
                IconButton(
                  onPressed: widget.isLoading
                      ? null
                      : () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                  icon: CustomIconWidget(
                    iconName:
                        _isPasswordVisible ? 'visibility_off' : 'visibility',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ),
              ],
            ),
            errorText: _passwordError,
          ),
          onFieldSubmitted: (_) {
            if (_isFormValid) {
              _handleLogin();
            }
          },
        ),

        SizedBox(height: 1.h),

        // Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    // TODO: Implement forgot password functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Fitur lupa password akan segera tersedia'),
                      ),
                    );
                  },
            child: Text(
              'Lupa Password?',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Login Button
        SizedBox(
          height: 7.h,
          child: ElevatedButton(
            onPressed: _isFormValid ? _handleLogin : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
              foregroundColor: Colors.white,
              elevation: _isFormValid ? 2.0 : 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    height: 5.w,
                    width: 5.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Masuk',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
