import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/api_service.dart';
import '../home_shimmer.dart';

class VisitTimelineScreen extends StatefulWidget {
  const VisitTimelineScreen({super.key});

  @override
  State<VisitTimelineScreen> createState() => _VisitTimelineScreenState();
}

class _VisitTimelineScreenState extends State<VisitTimelineScreen> {
  List<dynamic> timelineData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTimeline();
  }

  Future<void> _fetchTimeline() async {
    try {
      final response = await ApiService().getPatientTimeline();
      if (mounted) {
        setState(() {
          if (response.containsKey('data') && response['data'] != null) {
            timelineData = response['data'] as List<dynamic>;
          } else if (response['success'] == true && response['data'] != null) {
            timelineData = response['data'] as List<dynamic>;
          } else {
            _errorMessage =
                response['message']?.toString() ?? 'Failed to load timeline.';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
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
        leadingWidth: (res.isTablet ? 100 : 70) * res.scale,
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
          'Timeline',
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
          SizedBox(height: 10 * res.scale),

          Divider(
            height: 1,
            thickness: .5 * res.scale,
            color: AppColors.dividerColor,
            indent: 40 * res.scale,
            endIndent: 40 * res.scale,
          ),

          Expanded(
            child:
                _isLoading
                    ? HomeShimmer.buildTimelineListShimmer(
                      scale: res.scale,
                      isTablet: res.isTablet,
                    )
                    : _errorMessage != null
                    ? Center(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.errorColor),
                      ),
                    )
                    : timelineData.isEmpty
                    ? Center(
                      child: Text(
                        "No medical history available",
                        style: TextStyle(
                          color: AppColors.mutedColor,
                          fontSize: 16 * res.scale,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * res.scale,
                        vertical: (res.isTablet ? 15 : 20) * res.scale,
                      ),
                      itemCount: timelineData.length,
                      itemBuilder: (context, index) {
                        final data = timelineData[index];

                        final currentYear = data['year']?.toString() ?? '';
                        bool showYear = false;
                        if (index == 0) {
                          showYear = true;
                        } else {
                          final previousYear =
                              timelineData[index - 1]['year']?.toString() ?? '';
                          if (currentYear != previousYear) {
                            showYear = true;
                          }
                        }

                        return Column(
                          children: [
                            if (showYear && currentYear.isNotEmpty)
                              _buildYearHeader(
                                currentYear,
                                res.scale,
                                res.isTablet,
                              ),
                            _buildTimelineItem(
                              index,
                              data,
                              res.scale,
                              res.isTablet,
                            ),
                          ],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearHeader(String year, double scale, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: (isTablet ? 10 : 15) * scale),
      child: Row(
        children: [
          SizedBox(width: (isTablet ? 55 : 66) * scale),
          Container(
            width: 48 * scale,
            height: 22 * scale,
            padding: EdgeInsets.symmetric(
              horizontal: 4 * scale,
              vertical: 2 * scale,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputBackgroundColor,
              borderRadius: BorderRadius.circular(6 * scale),
              border: Border.all(color: AppColors.lightGrayBorder, width: .5),
              boxShadow: [
                // BoxShadow(
                //   color: Colors.black.withOpacity(0.04),
                //   blurRadius: 10 * scale,
                //   // offset: Offset(0, 4 * scale),
                // ),
              ],
            ),
            child: Center(
              child: Text(
                year,
                style: TextStyle(
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGreyTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    int index,
    dynamic itemData,
    double scale,
    bool isTablet,
  ) {
    final Map<String, dynamic> data =
        itemData is Map<String, dynamic> ? itemData : {};

    final day = data['date']?.toString() ?? '--';
    final month = data['month']?.toString().toUpperCase() ?? '---';
    final year = data['year']?.toString() ?? '';
    final type = data['type']?.toString().toUpperCase() ?? 'RECORD';
    final title = data['title']?.toString() ?? 'No Title';
    final doctor = data['doctor']?.toString() ?? 'Unknown Provider';
    final notes = data['description']?.toString() ?? '';
    final Color dotColor = AppColors.primaryColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Day and Month
          SizedBox(
            width: 40 * scale,
            child: Column(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 12 * scale,
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12 * scale),

          /// Line and Dot
          Column(
            children: [
              Container(
                width: 2 * scale,
                height: 12 * scale,
                    color:
                        index == 0 ? AppColors.transparent : AppColors.cardBorderColor,
              ),
              Container(
                width: 11 * scale,
                height: 11 * scale,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2 * scale,
                  color: index == timelineData.length - 1
                      ? AppColors.transparent
                      : AppColors.cardBorderColor,
                ),
              ),
            ],
          ),

          SizedBox(width: 16 * scale),

          /// Card Details
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 24 * scale),
              padding: EdgeInsets.all(16 * scale),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14 * scale),
                border: Border.all(
                  color: AppColors.secondaryBorderColor,
                  width: .5 * scale,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.04),
                    blurRadius: 10 * scale,
                    // offset: Offset(0, 4 * scale),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8 * scale,
                          vertical: 4 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackgroundColor,
                          borderRadius: BorderRadius.circular(6 * scale),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 12 * scale,
                            fontWeight: FontWeight.w500,
                            color:
                                type == "TASK"
                                    ? AppColors.deepSuccessColor
                                    : AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        year,
                        style: TextStyle(
                          color: AppColors.disabledTextColor,
                          fontSize: 12 * scale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * scale),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 2 * scale),
                  Text(
                    doctor,
                    style: TextStyle(
                      fontSize: 12 * scale,
                          color: AppColors.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (notes.isNotEmpty) ...[
                    SizedBox(height: 12 * scale),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10 * scale),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(6 * scale),
                        border: Border.all(
                          color: AppColors.secondaryBorderColor,
                          width: .1 * scale,
                        ),
                      ),
                      child: Text(
                        notes,
                        style: TextStyle(
                          fontSize: (isTablet ? 11 : 12) * scale,
                              color: AppColors.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
