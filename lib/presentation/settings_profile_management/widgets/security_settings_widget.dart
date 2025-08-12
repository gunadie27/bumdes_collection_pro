import 'package:flutter/material.dart';

class SecuritySettingsWidget extends StatefulWidget {
  const SecuritySettingsWidget({super.key});

  @override
  State<SecuritySettingsWidget> createState() => _SecuritySettingsWidgetState();
}

class _SecuritySettingsWidgetState extends State<SecuritySettingsWidget> {
  bool _twoFactorEnabled = false;

  void _showActiveSessions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sesi Aktif'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Daftar perangkat yang sedang login:'),
              const SizedBox(height: 16),
              _buildSessionItem(
                'Perangkat ini',
                'Android • 22 Jul 2025, 08:30',
                true,
              ),
              _buildSessionItem(
                'Tablet BUMDes Office',
                'iPad • 20 Jul 2025, 14:15',
                false,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _terminateOtherSessions();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Akhiri Sesi Lain'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(String deviceName, String details, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.smartphone : Icons.tablet,
            size: 20,
            color:
                isCurrent ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  details,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
    );
  }

  void _terminateOtherSessions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua sesi lain telah diakhiri'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showLoginHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Riwayat Login'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView(
            children: [
              _buildLoginHistoryItem(
                '22 Jul 2025, 08:30',
                'Android • 192.168.1.100',
                true,
              ),
              _buildLoginHistoryItem(
                '21 Jul 2025, 17:45',
                'Android • 192.168.1.100',
                true,
              ),
              _buildLoginHistoryItem(
                '20 Jul 2025, 14:15',
                'iPad • 192.168.1.105',
                true,
              ),
              _buildLoginHistoryItem(
                '19 Jul 2025, 09:20',
                'Android • 192.168.1.100',
                true,
              ),
              _buildLoginHistoryItem(
                '18 Jul 2025, 16:30',
                'Unknown Device • 203.142.1.25',
                false,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHistoryItem(String time, String device, bool isSuccessful) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccessful
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isSuccessful ? Icons.check_circle : Icons.warning,
            size: 16,
            color: isSuccessful ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  device,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            isSuccessful ? 'Berhasil' : 'Ditolak',
            style: TextStyle(
              fontSize: 12,
              color: isSuccessful ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _setupTwoFactor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Autentikasi Dua Faktor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_twoFactorEnabled) ...[
              const Text(
                  'Aktifkan autentikasi dua faktor untuk keamanan ekstra.'),
              const SizedBox(height: 16),
              const Text('Langkah-langkah:'),
              const SizedBox(height: 8),
              const Text('1. Install aplikasi Google Authenticator'),
              const SizedBox(height: 4),
              const Text('2. Scan QR code yang akan ditampilkan'),
              const SizedBox(height: 4),
              const Text('3. Masukkan kode verifikasi'),
            ] else ...[
              const Text('Autentikasi dua faktor sudah aktif.'),
              const SizedBox(height: 16),
              const Text('Apakah Anda ingin menonaktifkannya?'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _twoFactorEnabled = !_twoFactorEnabled;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _twoFactorEnabled
                        ? 'Autentikasi dua faktor diaktifkan'
                        : 'Autentikasi dua faktor dinonaktifkan',
                  ),
                  backgroundColor:
                      _twoFactorEnabled ? Colors.green : Colors.orange,
                ),
              );
            },
            child: Text(_twoFactorEnabled ? 'Nonaktifkan' : 'Aktifkan'),
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
              'Pengaturan Keamanan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Active Sessions
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Sesi Aktif'),
              subtitle: const Text('Kelola perangkat yang sedang login'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showActiveSessions,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Login History
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Login'),
              subtitle: const Text('Lihat aktivitas login terbaru'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showLoginHistory,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Two-Factor Authentication
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Autentikasi Dua Faktor'),
              subtitle: Text(
                _twoFactorEnabled
                    ? 'Aktif - Keamanan ekstra untuk login'
                    : 'Nonaktif - Aktifkan untuk keamanan ekstra',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _twoFactorEnabled
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _twoFactorEnabled ? 'Aktif' : 'Nonaktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: _twoFactorEnabled ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: _setupTwoFactor,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
