import 'package:flutter/material.dart';

class SupervisorOptionsWidget extends StatefulWidget {
  const SupervisorOptionsWidget({super.key});

  @override
  State<SupervisorOptionsWidget> createState() =>
      _SupervisorOptionsWidgetState();
}

class _SupervisorOptionsWidgetState extends State<SupervisorOptionsWidget> {
  String _selectedReportFrequency = 'Harian';
  final List<String> _reportFrequencies = ['Harian', 'Mingguan', 'Bulanan'];

  void _manageTeam() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Manajemen Tim'),
                content: SizedBox(
                    width: double.maxFinite,
                    height: 300,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tim Collector Aktif:'),
                          const SizedBox(height: 12),
                          Expanded(
                              child: ListView(children: [
                            _buildTeamMemberItem(
                                'Ahmad Collector', 'EMP001', 'Aktif'),
                            _buildTeamMemberItem(
                                'Budi Fieldwork', 'EMP002', 'Aktif'),
                            _buildTeamMemberItem(
                                'Sari Monitor', 'EMP003', 'Cuti'),
                            _buildTeamMemberItem(
                                'Dedi Collection', 'EMP004', 'Aktif'),
                          ])),
                        ])),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _addTeamMember();
                      },
                      child: const Text('Tambah Anggota')),
                ]));
  }

  Widget _buildTeamMemberItem(String name, String id, String status) {
    Color statusColor;
    switch (status) {
      case 'Aktif':
        statusColor = Colors.green;
        break;
      case 'Cuti':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!)),
        child: Row(children: [
          CircleAvatar(
              radius: 20,
              backgroundColor:
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Text(name.substring(0, 1),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                Text('ID: $id', style: Theme.of(context).textTheme.bodySmall),
              ])),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(status,
                  style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  void _addTeamMember() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Tambah Anggota Tim'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const TextField(
                      decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person))),
                  const SizedBox(height: 16),
                  const TextField(
                      decoration: InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.email))),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          labelText: 'Jabatan', prefixIcon: Icon(Icons.work)),
                      items: ['Collector', 'Field Officer'].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (value) {}),
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Anggota tim berhasil ditambahkan'),
                                backgroundColor: Colors.green));
                      },
                      child: const Text('Tambah')),
                ]));
  }

  void _scheduleReports() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Jadwal Laporan'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Atur frekuensi laporan otomatis:'),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Frekuensi Laporan',
                              prefixIcon: Icon(Icons.schedule)),
                          value: _selectedReportFrequency,
                          items: _reportFrequencies.map((frequency) {
                            return DropdownMenuItem(
                                value: frequency, child: Text(frequency));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedReportFrequency = value!;
                            });
                          }),
                      const SizedBox(height: 16),
                      const TextField(
                          decoration: InputDecoration(
                              labelText: 'Email Penerima',
                              prefixIcon: Icon(Icons.email),
                              hintText: 'supervisor@bumdes.com')),
                      const SizedBox(height: 16),
                      Row(children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 8),
                        const Text('Waktu Pengiriman: '),
                        TextButton(
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 9, minute: 0));
                              // Handle time selection
                            },
                            child: const Text('09:00')),
                      ]),
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Jadwal laporan berhasil diatur'),
                                backgroundColor: Colors.green));
                      },
                      child: const Text('Simpan')),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.supervisor_account,
                    color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 8),
                Text('Opsi Supervisor',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor)),
              ]),
              const SizedBox(height: 16),

              // Team Management
              ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Manajemen Tim'),
                  subtitle: const Text('Kelola anggota tim collector'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _manageTeam,
                  contentPadding: EdgeInsets.zero),
              const Divider(),

              // Report Scheduling
              ListTile(
                  leading: const Icon(Icons.schedule_send),
                  title: const Text('Jadwal Laporan'),
                  subtitle: Text('Otomatis $_selectedReportFrequency'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _scheduleReports,
                  contentPadding: EdgeInsets.zero),
            ])));
  }
}
