import 'package:application/bottom_nav_bar/Home/lab%20results/view_report_details.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_search_bar.dart';

class LabResultsScreen extends StatefulWidget {
  const LabResultsScreen({super.key});

  @override
  State<LabResultsScreen> createState() => _LabResultsScreenState();
}

class _LabResultsScreenState extends State<LabResultsScreen> {
  final List<Map<String, dynamic>> allReports = [
    {
      'title': 'Complete Blood Count (CBC)',
      'doctor': 'Dr.Ahmed',
      'date': 'Nov 15, 2023',
      'iconColor': const Color(0xFFDCFCE7),
      'icon': Icons.description_outlined,
    },
    {
      'title': 'Lipid Panel Assessment.pdf',
      'doctor': 'Dr.Ahmed',
      'date': 'Nov 15, 2023',
      'iconColor': const Color(0xFFFFF7ED),
      'icon': Icons.insert_drive_file_outlined,
    },
    {
      'title': 'Thyroid Function Test',
      'doctor': 'Dr.Ahmed',
      'date': '2023-10-22',
      'iconColor': const Color(0xFFDCFCE7),
      'icon': Icons.description_outlined,
    },
  ];

  List<Map<String, dynamic>> filteredReports = [];

  @override
  void initState() {
    super.initState();
    filteredReports = allReports;
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allReports;
    } else {
      results =
          allReports
              .where(
                (report) => report['title'].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
    }
    setState(() {
      filteredReports = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
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
          'Lab Reports',
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
          /// --- Search Bar ---
          CustomSearchBar(
            hintText: 'Search Lab Reports...',
            onChanged: _runSearch,
            res: res,
          ),

          SizedBox(height: 10 * res.scale),

          /// --- List of Reports ---
          Expanded(
            child:
                filteredReports.isNotEmpty
                    ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: (res.isTablet ? 24 : 20) * res.scale,
                      ),
                      itemCount: filteredReports.length,
                      itemBuilder:
                          (context, index) => _buildLabCard(
                            context,
                            res.scale,
                            res.isTablet,
                            title: filteredReports[index]['title'],
                            doctor: filteredReports[index]['doctor'],
                            date: filteredReports[index]['date'],
                            iconColor: filteredReports[index]['iconColor'],
                            icon: filteredReports[index]['icon'],
                            onView: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => const ViewReportDetailsScreen(),
                                ),
                              );
                            },
                          ),
                    )
                    : Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 16 * res.scale,
                          color: Colors.grey,
                        ),
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
    required IconData icon,
    required VoidCallback onView,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15 * scaleFactor),
      padding: EdgeInsets.all(16 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scaleFactor),
        border: Border.all(
          color: const Color(0xFFCDCDCD),
          width: .5 * scaleFactor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
            child: Icon(
              icon,
              color:
                  iconColor == const Color(0xFFDCFCE7)
                      ? const Color(0xFF34A853)
                      : const Color(0xFFFF7B00),
              size: 22 * scaleFactor,
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
                    color: const Color(0xFF0E1A34),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4 * scaleFactor),
                Text(
                  "$doctor • $date",
                  style: TextStyle(
                    color: const Color(0xFF8A94A6),
                    fontSize: 12 * scaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
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
                backgroundColor: const Color(0xFFF3F4F6).withOpacity(0.5),
                side: BorderSide(
                  color: const Color(0xFFCDCDCD),
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
                  color: const Color(0xFF0E1A34),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
