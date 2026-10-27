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
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FD),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Referensi',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  // ==================================================
                  // 1. COVER WITH 3D SHADOW
                  // ==================================================
                  _buildCover(context),

                  const SizedBox(height: 24),

                  // ==================================================
                  // 2. TITLE & AUTHOR
                  // ==================================================
                  Text(
                    material.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          material.author,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // ==================================================
                  // 3. INFORMATION CARD
                  // ==================================================
                  _buildInformationCard(context),

                  const SizedBox(height: 26),

                  // ==================================================
                  // 4. ACTION BUTTONS (SAVE & OPEN EXTERNAL)
                  // ==================================================
                  Consumer<StudyProvider>(
                    builder: (context, provider, child) {
                      final saved = provider.isSaved(material);

                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton.icon(
                              onPressed: () async {
                                try {
                                  await provider.toggleSaved(material);

                                  if (!context.mounted) return;

                                  final isNowSaved = provider.isSaved(material);
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(milliseconds: 1500),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Text(
                                        isNowSaved
                                            ? 'Buku berhasil disimpan ke koleksi'
                                            : 'Buku dihapus dari koleksi',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(milliseconds: 2000),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Text('Gagal memperbarui status: $e'),
                                    ),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: saved
                                    ? const Color(0xFFFFF1F2)
                                    : const Color(0xFF4F46E5),
                                foregroundColor: saved
                                    ? const Color(0xFFE11D48)
                                    : Colors.white,
                                side: saved
                                    ? const BorderSide(color: Color(0xFFFECDD3))
                                    : BorderSide.none,
                                elevation: saved ? 0 : 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: Icon(
                                saved
                                    ? Icons.bookmark_added_rounded
                                    : Icons.bookmark_add_outlined,
                                size: 21,
                              ),
                              label: Text(
                                saved
                                    ? 'Buku Tersimpan di Koleksi'
                                    : 'Simpan ke Koleksi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
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
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(milliseconds: 1500),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: const Text(
                                        'Tidak dapat membuka tautan Open Library.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF374151),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(
                                Icons.open_in_new_rounded,
                                size: 19,
                              ),
                              label: const Text(
                                'Buka di Open Library',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
  // 1. COVER WITH 3D SHADOW
  // ==============================================================

  Widget _buildCover(BuildContext context) {
    Widget imageContent;

    if (material.coverUrl == null || material.coverUrl!.isEmpty) {
      imageContent = Container(
        width: 180,
        height: 255,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: Color(0xFF4F46E5),
          ),
        ),
      );
    } else {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          material.coverUrl!,
          width: 180,
          height: 255,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 180,
              height: 255,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  size: 54,
                  color: Color(0xFF4F46E5),
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: imageContent,
    );
  }

  // ==============================================================
  // 2. INFORMATION CARD
  // ==============================================================

  Widget _buildInformationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person_rounded,
            iconColor: const Color(0xFF4F46E5),
            iconBg: const Color(0xFFEEF2FF),
            label: 'Penulis Buku',
            value: material.author,
          ),
          Divider(height: 24, color: Colors.grey.shade100, indent: 54),
          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF0D9488),
            iconBg: const Color(0xFFF0FDFA),
            label: 'Tahun Terbit',
            value: material.publishYear?.toString() ?? 'Tidak diketahui',
          ),
          Divider(height: 24, color: Colors.grey.shade100, indent: 54),
          _buildInfoRow(
            icon: Icons.public_rounded,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFFFBEB),
            label: 'Sumber Katalog',
            value: material.source,
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // 3. INFO ROW ITEM
  // ==============================================================

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
