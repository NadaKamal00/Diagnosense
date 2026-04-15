import 'package:flutter/material.dart';
import 'package:application/utils/responsive_helper.dart';
import '../../../shared/widgets/custom_search_bar.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/theme/app_colors.dart';
import 'view_history.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  List<Map<String, dynamic>> allHistory = [];
  List<Map<String, dynamic>> filteredHistory = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final response = await ApiService().getMedicalHistory();
      print('API Response: $response'); // Debug print
      if (response['data'] != null || response['success'] == true) {
        final List<dynamic> data = response['data'];
        final List<Map<String, dynamic>> list =
            data.map((item) => Map<String, dynamic>.from(item)).toList();
        setState(() {
          allHistory = list;
          filteredHistory = list;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              response['message'] ?? "Failed to load medical history";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allHistory;
    } else {
      results =
          allHistory
              .where(
                (item) => item['name'].toString().toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
    }
    setState(() {
      filteredHistory = results;
    });
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
          'Medical History',
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
          // Search Bar
          CustomSearchBar(
            hintText: 'Search History...',
            onChanged: _runSearch,
            res: res,
          ),

          SizedBox(height: 5 * res.scale),

          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                    ? Center(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(
                          fontSize: 14 * res.scale,
                          color: AppColors.errorColor,
                        ),
                      ),
                    )
                    : filteredHistory.isNotEmpty
                    ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: (res.isTablet ? 24 : 20) * res.scale,
                      ),
                      itemCount: filteredHistory.length,
                      itemBuilder:
                          (context, index) => _buildHistoryCard(
                            filteredHistory[index],
                            res.scale,
                          ),
                    )
                    : Center(
                      child: Text(
                        "No history found",
                        style: TextStyle(
                          fontSize: 14 * res.scale,
                          color: AppColors.hintGrey,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item, double scaleFactor) {
    final String title = item['name'] ?? "";
    final String date = item['date'] ?? "";
    final String size = item['size'] ?? "";
    final String extension = (item['extension'] ?? "").toString().toUpperCase();

    Color typeColor;
    Color textColor;

    if (extension == 'PDF') {
      typeColor = AppColors.pdfBadgeBackground;
      textColor = AppColors.pdfBadgeText;
    } else if (extension == 'DOC') {
      typeColor = AppColors.docBadgeBackground;
      textColor = AppColors.docBadgeText;
    } else {
      typeColor = AppColors.defaultBadgeBackground;
      textColor = AppColors.defaultBadgeText;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15 * scaleFactor),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14 * scaleFactor),
        border: Border.all(
          color: AppColors.secondaryBorderColor,
          width: .5 * scaleFactor,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadowColor.withOpacity(0.25),
            blurRadius: 7.9 * scaleFactor,
            // offset: Offset(0, 4 * scaleFactor),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewHistoryScreen(historyItem: item),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16 * scaleFactor),
            child: Row(
              children: [
                /// Types Icon Badge
                Container(
                  width: 50 * scaleFactor,
                  height: 37 * scaleFactor,
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(6 * scaleFactor),
                    border: Border.all(color: textColor, width: .5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    extension,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12 * scaleFactor,
                    ),
                  ),
                ),

                SizedBox(width: 15 * scaleFactor),

                /// Text Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13 * scaleFactor,
                          color: AppColors.primaryTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4 * scaleFactor),
                      Text(
                        "$date • $size",
                        style: TextStyle(
                          color: AppColors.secondaryTextColor,
                          fontSize: 12 * scaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
