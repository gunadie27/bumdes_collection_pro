import 'package:flutter/material.dart';

class AppPreferencesWidget extends StatefulWidget {
  const AppPreferencesWidget({super.key});

  @override
  State<AppPreferencesWidget> createState() => _AppPreferencesWidgetState();
}

class _AppPreferencesWidgetState extends State<AppPreferencesWidget> {
  String _selectedLanguage = 'Indonesian';
  String _selectedTheme = 'Auto';
  String _selectedSyncFrequency = '15 menit';

  final List<String> _languages = ['Indonesian', 'English'];
  final List<String> _themes = ['Light', 'Dark', 'Auto'];
  final List<String> _syncFrequencies = [
    '5 menit',
    '15 menit',
    '30 menit',
    '1 jam'
  ];

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                _savePreferences();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themes.map((theme) {
            IconData iconData;
            switch (theme) {
              case 'Light':
                iconData = Icons.wb_sunny;
                break;
              case 'Dark':
                iconData = Icons.nights_stay;
                break;
              default:
                iconData = Icons.brightness_auto;
            }

            return RadioListTile<String>(
              title: Row(
                children: [
                  Icon(iconData, size: 20),
                  const SizedBox(width: 8),
                  Text(theme),
                ],
              ),
              value: theme,
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
                _savePreferences();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _showSyncFrequencySelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frekuensi Sinkronisasi Offline'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _syncFrequencies.map((frequency) {
            return RadioListTile<String>(
              title: Text(frequency),
              value: frequency,
              groupValue: _selectedSyncFrequency,
              onChanged: (value) {
                setState(() {
                  _selectedSyncFrequency = value!;
                });
                Navigator.pop(context);
                _savePreferences();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _savePreferences() {
    // Implement saving to SharedPreferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferensi aplikasi disimpan'),
        duration: Duration(seconds: 1),
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
              'Preferensi Aplikasi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Language Selection
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Bahasa'),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showLanguageSelector,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Theme Options
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Tema'),
              subtitle: Text(_selectedTheme),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showThemeSelector,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Offline Sync Frequency
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Frekuensi Sinkronisasi Offline'),
              subtitle: Text('Setiap $_selectedSyncFrequency'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showSyncFrequencySelector,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
