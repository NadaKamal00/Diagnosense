import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewReportDetailsScreen extends StatefulWidget {
  const ViewReportDetailsScreen({super.key});

  @override
  State<ViewReportDetailsScreen> createState() =>
      _ViewReportDetailsScreenState();
}

class _ViewReportDetailsScreenState extends State<ViewReportDetailsScreen> {
  final String assetPath = "assets/pdf/1774300807_oyoU3.pdf";
  String localPath = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _prepareFile();
  }

  Future<void> _prepareFile() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/temp_report.pdf");
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _downloadAndSaveFile() async {
    if (localPath.isEmpty) return;
    try {
      Directory? directory =
          Platform.isAndroid
              ? Directory('/storage/emulated/0/Download')
              : await getApplicationDocumentsDirectory();

      final String savePath =
          "${directory.path}/Report_${DateTime.now().millisecondsSinceEpoch}.pdf";
      await File(localPath).copy(savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saved to Downloads"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Save failed")));
    }
  }

  Future<void> _shareFile() async {
    if (localPath.isNotEmpty) {
      await Share.shareXFiles([XFile(localPath)], text: 'Medical Report');
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
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
          'View Report',
          style: TextStyle(
            color: const Color(0xFF0E1A34),
            fontWeight: FontWeight.w600,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40 * res.scale),
            child: Divider(
              color: const Color(0xFFD5D5D5),
              thickness: 1 * res.scale,
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20 * res.scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Complete Blood Count (CBC)',
                        style: TextStyle(
                          fontSize: 15 * res.scale,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0E1A34),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * res.scale,
                        vertical: 4 * res.scale,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(2 * res.scale),
                        border: Border.all(
                          color: const Color(0xFFCDCDCD),
                          width: .5 * res.scale,
                        ),
                      ),
                      child: Text(
                        'PDF',
                        style: TextStyle(
                          fontSize: 11 * res.scale,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4 * res.scale),
                Text(
                  'Nov 15, 2023 • Hematology',
                  style: TextStyle(
                    color: const Color(0xFF939393),
                    fontSize: 12 * res.scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // PDF Container
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: (res.isTablet ? 30 : 20) * res.scale,
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
                    // offset: Offset(0, 5 * res.scale),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12 * res.scale),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : localPath.isNotEmpty
                        ? PDFView(
                          filePath: localPath,
                          enableSwipe: true,
                          autoSpacing: true,
                          pageSnap: true,
                        )
                        : const Center(child: Text("File not found")),
              ),
            ),
          ),

          //  Save & Share Buttons
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
                    label: 'Save PDF',
                    icon: Icons.file_download_outlined,
                    isPrimary: false,
                    scale: res.scale,
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
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20 * scale,
        color: isPrimary ? Colors.white : const Color(0xFF0E1A34),
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w600,
          color: isPrimary ? Colors.white : const Color(0xFF0E1A34),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF2563EB) : Colors.white,
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
