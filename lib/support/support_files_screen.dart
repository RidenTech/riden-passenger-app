import 'package:Riden/theme/app_colors.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportFilesScreen extends StatefulWidget {
  const SupportFilesScreen({super.key});

  @override
  State<SupportFilesScreen> createState() => _SupportFilesScreenState();
}

class _SupportFilesScreenState extends State<SupportFilesScreen> {
  final List<Map<String, dynamic>> _supportFiles = [
    {
      'name': 'User Manual.pdf',
      'size': '2.4 MB',
      'date': 'Jan 15, 2024',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'FAQ Guide.docx',
      'size': '1.2 MB',
      'date': 'Jan 10, 2024',
      'icon': Icons.description,
      'color': Colors.blue,
    },
    {
      'name': 'Terms & Conditions.pdf',
      'size': '890 KB',
      'date': 'Dec 20, 2023',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'Privacy Policy.pdf',
      'size': '650 KB',
      'date': 'Dec 15, 2023',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'Safety Guide.pdf',
      'size': '1.8 MB',
      'date': 'Dec 10, 2023',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'name': 'Payment Methods.xlsx',
      'size': '500 KB',
      'date': 'Dec 5, 2023',
      'icon': Icons.table_chart,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background - Shared Map
          Positioned.fill(
            child: SharedMapWidget(height: MediaQuery.of(context).size.height),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Support Files",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // Files List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _supportFiles.length,
                    itemBuilder: (context, index) {
                      final file = _supportFiles[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white12, width: 1),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              // File Icon
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      file['color'].withOpacity(0.8),
                                      file['color'].withOpacity(0.5),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  file['icon'] as IconData,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // File Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      file['name'] as String,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          file['size'] as String,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white60,
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.white60,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          file['date'] as String,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white60,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Download Icon
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.download_rounded,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
