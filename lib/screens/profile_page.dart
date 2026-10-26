import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/study_provider.dart';
import '../providers/note_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ============================================================
            // PROFILE HEADER
            // ============================================================

            CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 52,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Student',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              'StudyMate User',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 28),

            // ============================================================
            // STATISTICS
            // ============================================================
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.book_outlined,
                    title: 'Saved',
                    value: context
                        .watch<StudyProvider>()
                        .savedMaterials
                        .length
                        .toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.note_alt_outlined,
                    title: 'Notes',
                    value: context
                        .watch<NoteProvider>()
                        .notes
                        .length
                        .toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ============================================================
            // PROFILE MENU
            // ============================================================
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Informasi Profil'),
                    subtitle: const Text('Kelola informasi pengguna'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showInfoDialog(context);
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Tentang StudyMate'),
                    subtitle: const Text('Informasi aplikasi'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ============================================================
            // APP INFORMATION
            // ============================================================
            Text(
              'StudyMate',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Teman belajar untuk menemukan dan mengelola materi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Informasi Profil'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Student'),
              SizedBox(height: 16),
              Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Pengguna StudyMate'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'StudyMate',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school),
      children: const [
        Text(
          'StudyMate adalah aplikasi pendamping belajar '
          'untuk menemukan materi pembelajaran, menyimpan '
          'referensi, dan membuat catatan belajar.',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Icon(icon, size: 30, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
