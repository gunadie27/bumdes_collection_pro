import 'package:flutter/material.dart';

class DataManagementWidget extends StatefulWidget {
  const DataManagementWidget({super.key});

  @override
  State<DataManagementWidget> createState() => _DataManagementWidgetState();
}

class _DataManagementWidgetState extends State<DataManagementWidget> {
  String _cacheSize = '45.2 MB';
  String _storageUsage = '1.2 GB dari 64 GB tersedia';

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bersihkan Cache'),
        content: const Text(
          'Cache akan dihapus untuk mengosongkan ruang penyimpanan. Data aplikasi tidak akan terpengaruh.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performClearCache();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Bersihkan'),
          ),
        ],
      ),
    );
  }

  void _performClearCache() {
    // Implement cache clearing logic
    setState(() {
      _cacheSize = '0 MB';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache berhasil dibersihkan'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ekspor Data'),
        content: const Text(
          'Data koleksi dan laporan akan diekspor dalam format CSV. File akan disimpan di folder Downloads.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performDataExport();
            },
            child: const Text('Ekspor'),
          ),
        ],
      ),
    );
  }

  void _performDataExport() {
    // Implement data export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil diekspor ke Downloads/BUMDes_Data.csv'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showStorageDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Penggunaan Penyimpanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rincian penggunaan penyimpanan:'),
            const SizedBox(height: 16),
            _buildStorageItem('Data Aplikasi', '850 MB'),
            _buildStorageItem('Database', '280 MB'),
            _buildStorageItem('Cache', _cacheSize),
            _buildStorageItem('Gambar/Foto', '65 MB'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total: $_storageUsage',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: 0.019, // 1.2/64
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
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
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            size,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
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
              'Manajemen Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Clear Cache
            ListTile(
              leading: const Icon(Icons.cleaning_services),
              title: const Text('Bersihkan Cache'),
              subtitle: Text('Cache saat ini: $_cacheSize'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _clearCache,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Export Data
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Ekspor Data'),
              subtitle: const Text('Ekspor data koleksi dan laporan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _exportData,
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Storage Usage
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Penggunaan Penyimpanan'),
              subtitle: Text(_storageUsage),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showStorageDetails,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
