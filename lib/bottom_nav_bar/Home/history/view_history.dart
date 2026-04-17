import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_colors.dart';

class ViewHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> historyItem;
  const ViewHistoryScreen({super.key, required this.historyItem});

  @override
  State<ViewHistoryScreen> createState() => _ViewHistoryScreenState();
}

class _ViewHistoryScreenState extends State<ViewHistoryScreen> {
  String localPath = "";
  bool isLoading = true;
  bool isImage = false;
  String? downloadUrl;

  @override
  void initState() {
    super.initState();
    downloadUrl = widget.historyItem['download_url']?.toString();
    _loadHistoryFile();
  }

  Future<void> _loadHistoryFile() async {
    if (downloadUrl == null || downloadUrl!.isEmpty) {
      debugPrint("DEBUG: [ViewHistory] No download_url found, using fallback.");
      await _prepareAssetPdf();
      return;
    }

    final String url = downloadUrl!.toLowerCase();
    if (url.endsWith('.pdf')) {
      debugPrint("DEBUG: [ViewHistory] Detected PDF. Downloading...");
      await _downloadRemotePdf(downloadUrl!);
    } else if (url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg')) {
      debugPrint(
        "DEBUG: [ViewHistory] Detected Image. Downloading for local use...",
      );
      await _downloadRemoteImage(downloadUrl!);
    } else {
      debugPrint(
        "DEBUG: [ViewHistory] Unknown format, attempting PDF download.",
      );
      await _downloadRemotePdf(downloadUrl!);
    }
  }

  Future<void> _downloadRemotePdf(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final String fileName =
          "history_${DateTime.now().millisecondsSinceEpoch}.pdf";
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
      debugPrint("ERROR: [ViewHistory] PDF download failed: $e");
      if (mounted) {
        await _prepareAssetPdf(); // Fallback to local asset
      }
    }
  }

  Future<void> _downloadRemoteImage(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final String ext = url.toLowerCase().contains('.png') ? '.png' : '.jpg';
      final String fileName =
          "history_${DateTime.now().millisecondsSinceEpoch}$ext";
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
      debugPrint("ERROR: [ViewHistory] Image download failed: $e");
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
      final file = File("${dir.path}/temp_history_fallback.pdf");
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        setState(() {
          localPath = file.path;
          isImage = false;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("ERROR: [ViewHistory] Asset fallback failed: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
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
      final String itemName = (widget.historyItem['name']?.toString() ??
              'History_File')
          .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
      final String savePath =
          "${directory!.path}/${itemName}_${DateTime.now().millisecondsSinceEpoch}$extension";
      final File saveFile = File(savePath);

      final bytes = await File(localPath).readAsBytes();
      await saveFile.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("File saved to: ${saveFile.path}"),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not save file to Downloads")),
        );
      }
    }
  }

  Future<void> _shareFile() async {
    final String itemName =
        widget.historyItem['name']?.toString() ?? 'History File';
    if (localPath.isNotEmpty) {
      final String extension = isImage ? ".jpg" : ".pdf";
      await Share.shareXFiles([
        XFile(localPath, name: '$itemName$extension'),
      ], text: 'Sharing my medical history: $itemName');
    } else if (downloadUrl != null) {
      await Share.share('Medical History - $itemName: $downloadUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final String title =
        widget.historyItem['name']?.toString() ?? 'Medical History';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        toolbarHeight: 56 * res.scale,
        leadingWidth: (res.isTablet ? 90 : 70) * res.scale,
        leading: Container(
          margin: EdgeInsets.only(left: (res.isTablet ? 20 : 12) * res.scale),
          alignment: Alignment.centerLeft,
          child: ClipOval(
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(8 * res.scale),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primaryTextColor,
                    size: 20 * res.scale,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // File Content Container
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: (res.isTablet ? 30 : 20) * res.scale,
                vertical: 10 * res.scale,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12 * res.scale),
                border: Border(
                  top: BorderSide(
                    color: AppColors.primaryColor,
                    width: 5 * res.scale,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.25),
                    blurRadius: 4 * res.scale,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12 * res.scale),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : isImage &&
                            (localPath.isNotEmpty || downloadUrl != null)
                        ? InteractiveViewer(
                          child:
                              localPath.isNotEmpty
                                  ? Image.file(
                                    File(localPath),
                                    fit: BoxFit.contain,
                                  )
                                  : Image.network(
                                    downloadUrl!,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text(
                                          "Error loading image content",
                                        ),
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
                        : const Center(
                          child: Text("File content not available"),
                        ),
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
    final Color primaryBg =
        isEnabled
            ? AppColors.primaryColor
            : AppColors.primaryColor.withOpacity(0.5);
    final Color secondaryTextIconColor =
        isEnabled
            ? AppColors.primaryTextColor
            : AppColors.primaryTextColor.withOpacity(0.5);

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20 * scale,
        color: isPrimary ? AppColors.white : secondaryTextIconColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w600,
          color: isPrimary ? AppColors.white : secondaryTextIconColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? primaryBg : AppColors.white,
        padding: EdgeInsets.symmetric(vertical: 16 * scale),
        elevation: isPrimary ? 2 : 0,
        side: BorderSide(
          color: isPrimary ? AppColors.transparent : AppColors.secondaryBorderColor,
          width: .5 * scale,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * scale),
        ),
      ),
    );
  }
}
