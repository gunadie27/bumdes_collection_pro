import 'package:flutter/material.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  const NotificationPreferencesWidget({super.key});

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  bool _pushNotifications = true;
  bool _smsAlerts = false;
  bool _emailReports = true;
  bool _quietHours = false;
  TimeOfDay _quietStartTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEndTime = const TimeOfDay(hour: 7, minute: 0);

  void _toggleNotification(String type, bool value) {
    setState(() {
      switch (type) {
        case 'push':
          _pushNotifications = value;
          break;
        case 'sms':
          _smsAlerts = value;
          break;
        case 'email':
          _emailReports = value;
          break;
        case 'quiet':
          _quietHours = value;
          break;
      }
    });

    // Save to SharedPreferences
    _saveNotificationPreferences();
  }

  void _saveNotificationPreferences() {
    // Implement saving to SharedPreferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferensi notifikasi disimpan'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _setQuietHours() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jam Tenang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Atur waktu dimana notifikasi tidak akan dikirim'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mulai:'),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _quietStartTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _quietStartTime = picked;
                            });
                          }
                        },
                        child: Text('${_quietStartTime.format(context)}'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selesai:'),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: _quietEndTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _quietEndTime = picked;
                            });
                          }
                        },
                        child: Text('${_quietEndTime.format(context)}'),
                      ),
                    ],
                  ),
                ),
              ],
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
              Navigator.pop(context);
              _saveNotificationPreferences();
            },
            child: const Text('Simpan'),
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
              'Preferensi Notifikasi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Push Notifications
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi Push'),
              subtitle: const Text('Terima notifikasi langsung di perangkat'),
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (value) => _toggleNotification('push', value),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // SMS Alerts
            ListTile(
              leading: const Icon(Icons.sms),
              title: const Text('Peringatan SMS'),
              subtitle: const Text('Terima peringatan melalui SMS'),
              trailing: Switch(
                value: _smsAlerts,
                onChanged: (value) => _toggleNotification('sms', value),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Email Reports
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Laporan Email'),
              subtitle: const Text('Terima laporan harian melalui email'),
              trailing: Switch(
                value: _emailReports,
                onChanged: (value) => _toggleNotification('email', value),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Quiet Hours
            ListTile(
              leading: const Icon(Icons.nights_stay),
              title: const Text('Jam Tenang'),
              subtitle: Text(
                _quietHours
                    ? 'Aktif: ${_quietStartTime.format(context)} - ${_quietEndTime.format(context)}'
                    : 'Nonaktif - Atur waktu tenang notifikasi',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: _quietHours,
                    onChanged: (value) => _toggleNotification('quiet', value),
                  ),
                  if (_quietHours) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _setQuietHours,
                      icon: const Icon(Icons.schedule),
                      iconSize: 20,
                    ),
                  ],
                ],
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
