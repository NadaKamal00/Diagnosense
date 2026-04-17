import 'package:application/bottom_nav_bar/Home/lab%20results/view_report_details.dart';
import 'package:application/core/utils/api_service.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_search_bar.dart';

class LabResultsScreen extends StatefulWidget {
  const LabResultsScreen({super.key});

  @override
  State<LabResultsScreen> createState() => _LabResultsScreenState();
}

class _LabResultsScreenState extends State<LabResultsScreen> {
  Future<Map<String, dynamic>>? _reportsFuture;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _reportsFuture = ApiService().getLabReports();
  }

  void _runSearch(String enteredKeyword) {
    setState(() {
      _searchQuery = enteredKeyword;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _reportsFuture = ApiService().getLabReports();
    });
    await _reportsFuture;
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
          'Lab Reports',
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
          /// --- Search Bar ---
          CustomSearchBar(
            hintText: 'Search Lab Reports...',
            onChanged: _runSearch,
            res: res,
          ),

          SizedBox(height: 10 * res.scale),

          /// --- List of Reports ---
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: FutureBuilder<Map<String, dynamic>>(
                future: _reportsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Center(
                          child: Text(
                            'Error loading reports',
                            style: TextStyle(
                              fontSize: 16 * res.scale,
                              color: AppColors.errorColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final data = snapshot.data;
                  if (data == null || data['success'] == false) {
                    return ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Center(
                          child: Text(
                            data?['message'] ?? 'Failed to load reports',
                            style: TextStyle(
                              fontSize: 16 * res.scale,
                              color: AppColors.hintGrey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  final List<dynamic> allReports = data['data'] ?? [];

                  final filteredReports =
                      allReports.where((report) {
                        final title = (report['name'] ?? '').toLowerCase();
                        return title.contains(_searchQuery.toLowerCase());
                      }).toList();

                  if (filteredReports.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 16 * res.scale,
                              color: AppColors.hintGrey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: (res.isTablet ? 24 : 20) * res.scale,
                    ),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      final bool isEven = index % 2 == 0;

                      return _buildLabCard(
                        context,
                        res.scale,
                        res.isTablet,
                        title: report['name'] ?? 'Unknown Report',
                        doctor: report['doctor'] ?? 'Unknown Doctor',
                        date: report['date'] ?? 'Unknown Date',
                        iconColor:
                            isEven
                                ? AppColors.successLight
                                : AppColors.warningLight,
                        onView: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => ViewReportDetailsScreen(
                                    name: report['name'] ?? 'Unknown Report',
                                    date: report['date'] ?? '',
                                    viewUrl: report['view_url'] ?? '',
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabCard(
    BuildContext context,
    double scaleFactor,
    bool isTablet, {
    required String title,
    required String doctor,
    required String date,
    required Color iconColor,
    required VoidCallback onView,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15 * scaleFactor),
      padding: EdgeInsets.all(16 * scaleFactor),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14 * scaleFactor),
        border: Border.all(
          color: AppColors.secondaryBorderColor,
          width: .5 * scaleFactor,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 10 * scaleFactor,
            // offset: Offset(0, 4 * scaleFactor),
          ),
        ],
      ),
      child: Row(
        children: [
          /// --- Icon Container ---
          Container(
            padding: EdgeInsets.all(12 * scaleFactor),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: SvgPicture.asset(
              'assets/Icons/lap-reports.svg',
              colorFilter: ColorFilter.mode(
                iconColor == AppColors.successLight
                    ? AppColors.successText
                    : AppColors.warningText,
                BlendMode.srcIn,
              ),
              width: 22 * scaleFactor,
              height: 22 * scaleFactor,
            ),
          ),

          SizedBox(width: 15 * scaleFactor),

          /// Text Info
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4 * scaleFactor),
                Text(
                  "Dr. $doctor",
                  style: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 12 * scaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4 * scaleFactor),
                Text(
                  date,
                  style: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 11 * scaleFactor,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),

          SizedBox(width: 10 * scaleFactor),

          /// --- View Button ---
          SizedBox(
            height: 34 * scaleFactor,
            width: 50 * scaleFactor,
            child: OutlinedButton(
              onPressed: onView,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surfaceVariant.withOpacity(0.5),
                side: BorderSide(
                  color: AppColors.secondaryBorderColor,
                  width: .5 * scaleFactor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6 * scaleFactor),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5 * scaleFactor),
              ),
              child: Text(
                'View',
                style: TextStyle(
                  fontSize: 12 * scaleFactor,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
