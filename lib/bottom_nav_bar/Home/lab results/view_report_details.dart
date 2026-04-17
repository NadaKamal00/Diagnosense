import 'package:application/utils/responsive_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewReportDetailsScreen extends StatefulWidget {
  final String name;
  final String date;
  final String viewUrl;

  const ViewReportDetailsScreen({
    super.key,
    required this.name,
    required this.date,
    required this.viewUrl,
  });

  @override
  State<ViewReportDetailsScreen> createState() =>
      _ViewReportDetailsScreenState();
}

class _ViewReportDetailsScreenState extends State<ViewReportDetailsScreen> {
  String localPath = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/temp_report.pdf");

      await Dio().download(widget.viewUrl, file.path);

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("PDF download error: $e");
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
        SnackBar(
          content: const Text("Saved to Downloads"),
          backgroundColor: AppColors.successGreen,
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
          widget.name,
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10 * res.scale),

          // PDF Container
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: (res.isTablet ? 30 : 20) * res.scale,
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
        color: isPrimary ? AppColors.white : AppColors.primaryTextColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15 * scale,
          fontWeight: FontWeight.w600,
          color: isPrimary ? AppColors.white : AppColors.primaryTextColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColors.primaryColor : AppColors.white,
        padding: EdgeInsets.symmetric(vertical: 16 * scale),
        elevation: isPrimary ? 2 : 0,
        side: BorderSide(
          color:
              isPrimary
                  ? AppColors.transparent
                  : AppColors.secondaryBorderColor,
          width: .5 * scale,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * scale),
        ),
      ),
    );
  }
}
