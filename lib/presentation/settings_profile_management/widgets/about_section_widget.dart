import 'package:flutter/material.dart';

class AboutSectionWidget extends StatelessWidget {
  const AboutSectionWidget({super.key});

  void _showVersionInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Versi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1606868306217-dbf5046868d2',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BUMDes Collection Pro',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Versi 1.0.0+1',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Rilis Terakhir: 22 Juli 2025'),
            const SizedBox(height: 8),
            const Text('Build: Flutter 3.16.0'),
            const SizedBox(height: 8),
            const Text('Platform: Android/iOS'),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi profesional untuk manajemen koleksi dan pemantauan hutang khusus BUMDes.',
              style: TextStyle(fontSize: 12),
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

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Syarat dan Ketentuan'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SYARAT DAN KETENTUAN PENGGUNAAN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '1. PENERIMAAN SYARAT',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dengan menggunakan aplikasi BUMDes Collection Pro, Anda menyetujui untuk terikat dengan syarat dan ketentuan berikut.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '2. PENGGUNAAN APLIKASI',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aplikasi ini khusus digunakan untuk keperluan koleksi dan manajemen hutang BUMDes. Penggunaan untuk tujuan lain dilarang.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '3. KERAHASIAAN DATA',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pengguna wajib menjaga kerahasiaan data nasabah dan informasi sensitif lainnya.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '4. TANGGUNG JAWAB PENGGUNA',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pengguna bertanggung jawab atas keakuratan data yang diinput dan penggunaan aplikasi sesuai prosedur.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Terakhir diperbarui: 22 Juli 2025',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
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

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kebijakan Privasi'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KEBIJAKAN PRIVASI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '1. PENGUMPULAN INFORMASI',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kami mengumpulkan informasi yang diperlukan untuk operasional aplikasi, termasuk data pengguna, lokasi, dan aktivitas koleksi.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '2. PENGGUNAAN INFORMASI',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Informasi digunakan untuk meningkatkan layanan, monitoring, dan pelaporan aktivitas koleksi.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '3. PERLINDUNGAN DATA',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Data dilindungi dengan enkripsi dan sistem keamanan berlapis untuk mencegah akses tidak sah.',
                ),
                const SizedBox(height: 16),
                const Text(
                  '4. BERBAGI INFORMASI',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Informasi tidak akan dibagikan kepada pihak ketiga tanpa persetujuan, kecuali diwajibkan oleh hukum.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Untuk pertanyaan, hubungi: support@bumdes.co.id',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // App Version
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Informasi Versi'),
              subtitle: const Text('BUMDes Collection Pro v1.0.0+1'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showVersionInfo(context),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Terms of Service
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Syarat dan Ketentuan'),
              subtitle: const Text('Baca syarat penggunaan aplikasi'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTermsOfService(context),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),

            // Privacy Policy
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Kebijakan Privasi'),
              subtitle: const Text('Pelajari cara kami melindungi data Anda'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showPrivacyPolicy(context),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
