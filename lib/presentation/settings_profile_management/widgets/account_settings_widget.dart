import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AccountSettingsWidget extends StatefulWidget {
  const AccountSettingsWidget({super.key});

  @override
  State<AccountSettingsWidget> createState() => _AccountSettingsWidgetState();
}

class _AccountSettingsWidgetState extends State<AccountSettingsWidget> {
  bool _biometricEnabled = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  void _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (isAvailable && isDeviceSupported) {
        // Load saved biometric preference
        setState(() {
          _biometricEnabled = false; // Load from SharedPreferences
        });
      }
    } catch (e) {
      // Biometric not available
    }
  }

  void _toggleBiometric(bool value) async {
    if (value) {
      try {
        final bool didAuthenticate = await _localAuth.authenticate(
          localizedReason:
              'Verifikasi sidik jari untuk mengaktifkan autentikasi biometrik',
          options: const AuthenticationOptions(
            biometricOnly: true,
          ),
        );

        if (didAuthenticate) {
          setState(() {
            _biometricEnabled = true;
          });
          // Save to SharedPreferences
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Autentikasi biometrik berhasil diaktifkan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengaktifkan autentikasi biometrik'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        _biometricEnabled = false;
      });
      // Save to SharedPreferences
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => _buildChangePasswordDialog(),
    );
  }

  Widget _buildChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Ubah Kata Sandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Saat Ini',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setDialogState(() {
                        obscureCurrentPassword = !obscureCurrentPassword;
                      });
                    },
                    icon: Icon(
                      obscureCurrentPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Baru',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setDialogState(() {
                        obscureNewPassword = !obscureNewPassword;
                      });
                    },
                    icon: Icon(
                      obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi Baru',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setDialogState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kata sandi berhasil diubah'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Konfirmasi kata sandi tidak cocok'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Ubah'),
            ),
          ],
        );
      },
    );
  }

  void _manageSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kelola Sesi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sesi aktif saat ini:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.smartphone, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Perangkat ini',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Aktif',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Login: 22 Jul 2025, 08:30',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout all sessions
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua sesi lain telah diakhiri'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Akhiri Sesi Lain'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Akun',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Change Password
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Ubah Kata Sandi'),
              subtitle: const Text('Perbarui kata sandi akun Anda'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _changePassword,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Biometric Authentication
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Autentikasi Biometrik'),
              subtitle: const Text('Login menggunakan sidik jari'),
              trailing: Switch(
                value: _biometricEnabled,
                onChanged: _toggleBiometric,
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Session Management
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Kelola Sesi'),
              subtitle: const Text('Lihat dan kelola sesi login aktif'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _manageSession,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
