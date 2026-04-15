import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';

class RadiologyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? report;
  const RadiologyDetailsScreen({super.key, this.report});

  @override
  State<RadiologyDetailsScreen> createState() => _RadiologyDetailsScreenState();
}

class _RadiologyDetailsScreenState extends State<RadiologyDetailsScreen> {
  String localPath = "";
  bool isLoading = true;
  bool isImage = false;
  String? openUrl;

  @override
  void initState() {
    super.initState();
    openUrl = widget.report?['open_url'];
    _loadReport();
  }

  Future<void> _loadReport() async {
    if (openUrl == null || openUrl!.isEmpty) {
      debugPrint("DEBUG: [RadiologyDetails] No open_url found, using fallback.");
      await _prepareAssetPdf();
      return;
    }

    final String url = openUrl!.toLowerCase();
    if (url.endsWith('.pdf')) {
      debugPrint("DEBUG: [RadiologyDetails] Detected PDF. Downloading...");
      await _downloadRemotePdf(openUrl!);
    } else if (url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg')) {
      debugPrint(
        "DEBUG: [RadiologyDetails] Detected Image. Downloading for local use...",
      );
      await _downloadRemoteImage(openUrl!);
    } else {
      debugPrint(
        "DEBUG: [RadiologyDetails] Unknown format, attempting PDF download.",
      );
      await _downloadRemotePdf(openUrl!);
    }
  }

  Future<void> _downloadRemotePdf(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final String fileName =
          "radiology_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final String path = "${dir.path}/$fileName";

      await Dio().download(url, path);

      if (mounted) {
        setState(() {
          localPath = path;
          isImage = false;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("ERROR: [RadiologyDetails] PDF download failed: $e");
      if (mounted) {
        await _prepareAssetPdf(); // Fallback to asset
      }
    }
  }

  Future<void> _downloadRemoteImage(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final String ext = url.toLowerCase().contains('.png') ? '.png' : '.jpg';
      final String fileName =
          "radiology_${DateTime.now().millisecondsSinceEpoch}$ext";
      final String path = "${dir.path}/$fileName";

      await Dio().download(url, path);

      if (mounted) {
        setState(() {
          localPath = path;
          isImage = true;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("ERROR: [RadiologyDetails] Image download failed: $e");
      if (mounted) {
        setState(() {
          isImage = true;
          isLoading = false;
        });
      }
    }
  }


  Future<void> _prepareAssetPdf() async {
    const String assetPath = "assets/pdf/report.pdf";
    try {
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/temp_asset_report.pdf");
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        localPath = file.path;
        isImage = false;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR: [RadiologyDetails] Asset fallback failed: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _downloadAndSaveFile() async {
    try {
      if (localPath.isEmpty) return;

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final String extension = isImage ? ".jpg" : ".pdf";
      final String savePath =
          "${directory!.path}/Radiology_Report_${DateTime.now().millisecondsSinceEpoch}$extension";
      final File saveFile = File(savePath);

      final bytes = await File(localPath).readAsBytes();
      await saveFile.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File saved to: ${saveFile.path}"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not save file to Downloads")),
      );
    }
  }

  Future<void> _shareFile() async {
    if (localPath.isNotEmpty) {
      final String extension = isImage ? ".jpg" : ".pdf";
      await Share.shareXFiles([
        XFile(localPath, name: 'Radiology_Report$extension'),
      ], text: 'Sharing my Radiology Report');
    } else if (isImage && openUrl != null) {
      // If we don't have localPath for image yet, share URL
      await Share.share('Radiology Report: $openUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56 * res.scale,
        leadingWidth: (res.isTablet ? 90 : 70) * res.scale,
        leading: Container(
          margin: EdgeInsets.only(left: (res.isTablet ? 20 : 12) * res.scale),
          alignment: Alignment.centerLeft,
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(8 * res.scale),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: const Color(0xFF0E1A34),
                    size: 20 * res.scale,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          widget.report?['name'] ?? 'Radiology Report',
          style: TextStyle(
            color: const Color(0xFF0E1A34),
            fontWeight: FontWeight.bold,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Report Content Container
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: (res.isTablet ? 30 : 20) * res.scale,
                vertical: 10 * res.scale,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12 * res.scale),
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF2563EB),
                    width: 5 * res.scale,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4 * res.scale,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12 * res.scale),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : isImage && (localPath.isNotEmpty || openUrl != null)
                        ? InteractiveViewer(
                          child:
                              localPath.isNotEmpty
                                  ? Image.file(
                                    File(localPath),
                                    fit: BoxFit.contain,
                                  )
                                  : Image.network(
                                    openUrl!,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child:
                                            Text("Error loading image content"),
                                      );
                                    },
                                  ),
                        )

                        : localPath.isNotEmpty
                        ? PDFView(
                          filePath: localPath,
                          enableSwipe: true,
                          autoSpacing: true,
                          pageSnap: true,
                        )
                        : const Center(child: Text("Report content not found")),
              ),
            ),
          ),

          // Save & Share Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(
              (res.isTablet ? 30 : 20) * res.scale,
              15 * res.scale,
              (res.isTablet ? 30 : 20) * res.scale,
              (res.isTablet ? 25 : 15) * res.scale,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: isImage ? 'Save Image' : 'Save PDF',
                    icon: Icons.file_download_outlined,
                    isPrimary: false,
                    scale: res.scale,
                    isEnabled: localPath.isNotEmpty,
                    onPressed:
                        localPath.isNotEmpty ? _downloadAndSaveFile : null,
                  ),
                ),
                SizedBox(width: 12 * res.scale),
                Expanded(
                  child: _buildActionButton(
                    label: 'Share',
                    icon: Icons.share_outlined,
                    isPrimary: true,
                    scale: res.scale,
                    isEnabled: localPath.isNotEmpty,
                    onPressed: localPath.isNotEmpty ? _shareFile : null,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5 * res.scale),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required double scale,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    final Color primaryBg = isEnabled
        ? const Color(0xFF2563EB)
        : const Color(0xFF2563EB).withOpacity(0.5);
    final Color secondaryTextIconColor = isEnabled
        ? const Color(0xFF0E1A34)
        : const Color(0xFF0E1A34).withOpacity(0.5);

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20 * scale,
        color: isPrimary ? Colors.white : secondaryTextIconColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w600,
          color: isPrimary ? Colors.white : secondaryTextIconColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? primaryBg : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16 * scale),
        elevation: isPrimary ? 2 : 0,
        side: BorderSide(
          color: isPrimary ? Colors.transparent : const Color(0xFFCDCDCD),
          width: .5 * scale,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * scale),
        ),
      ),
    );
  }
}

