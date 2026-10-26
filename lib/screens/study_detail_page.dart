import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/study_material.dart';
import '../providers/study_provider.dart';

class StudyDetailPage extends StatelessWidget {
  const StudyDetailPage({super.key, required this.material});

  final StudyMaterial material;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reference Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // COVER
                  // ==================================================

                  Center(child: _buildCover(context)),

                  const SizedBox(height: 28),

                  // ==================================================
                  // TITLE
                  // ==================================================
                  Text(
                    material.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // AUTHOR
                  // ==================================================
                  Center(
                    child: Text(
                      material.author,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // INFORMATION
                  // ==================================================
                  _buildInformationCard(context),

                  const SizedBox(height: 24),

                  // ==================================================
                  // SAVE / REMOVE BUTTON
                  // ==================================================
                  Consumer<StudyProvider>(
                    builder: (context, provider, child) {
                      final saved = provider.isSaved(material);

                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            try {
                              // Simpan atau hapus dari Supabase
                              await provider.toggleSaved(material);

                              if (!context.mounted) {
                                return;
                              }

                              // Ambil status terbaru setelah
                              // proses Supabase selesai.
                              final isNowSaved = provider.isSaved(material);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isNowSaved
                                        ? 'Reference saved successfully'
                                        : 'Reference removed from Saved',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to update saved reference: $e',
                                  ),
                                ),
                              );
                            }
                          },

                          // Ikon berubah sesuai status
                          icon: Icon(
                            saved ? Icons.favorite : Icons.favorite_border,
                          ),

                          // Tulisan berubah sesuai status
                          label: Text(
                            saved ? 'Saved Reference' : 'Save Reference',
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // OPEN OPEN LIBRARY
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(
                          'https://openlibrary.org${material.id}',
                        );

                        final launched = await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );

                        if (!launched && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Tidak dapat membuka halaman Open Library.',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open in Open Library'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // COVER
  // ==============================================================

  Widget _buildCover(BuildContext context) {
    if (material.coverUrl == null) {
      return Container(
        width: 180,
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.menu_book_outlined,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        material.coverUrl!,
        width: 180,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 180,
            height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.broken_image_outlined,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }

  // ==============================================================
  // INFORMATION CARD
  // ==============================================================

  Widget _buildInformationCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow(
              icon: Icons.person_outline,
              label: 'Author',
              value: material.author,
            ),

            const Divider(height: 28),

            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Published',
              value: material.publishYear?.toString() ?? 'Unknown',
            ),

            const Divider(height: 28),

            _buildInfoRow(
              icon: Icons.source_outlined,
              label: 'Source',
              value: material.source,
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // INFORMATION ROW
  // ==============================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.indigo),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
