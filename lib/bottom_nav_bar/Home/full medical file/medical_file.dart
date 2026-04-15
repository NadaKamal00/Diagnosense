import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:application/core/theme/app_colors.dart';
import 'package:application/bottom_nav_bar/Home/full%20medical%20file/timeline.dart';
import 'package:application/bottom_nav_bar/Home/history/history.dart';
import 'package:application/bottom_nav_bar/Home/lab%20results/lab_reports.dart';
import 'package:application/bottom_nav_bar/Settings/profile/profile.dart';
import '../../../shared/widgets/custom_search_bar.dart';
import '../radiology/radiology.dart';
import 'medications.dart';

class MedicalFilesScreen extends StatefulWidget {
  const MedicalFilesScreen({super.key});

  @override
  State<MedicalFilesScreen> createState() => _MedicalFilesScreenState();
}

class _MedicalFilesScreenState extends State<MedicalFilesScreen> {
  final List<Map<String, dynamic>> allFiles = [
    {
      'title': 'Personal Info',
      'subtitle': 'Name, Contact Info',
      'icon': Symbols.person,
      'iconColor': AppColors.primaryColor, // Unified Blue
      'destination': const ProfileScreen(),
    },
    {
      'title': 'Medical History',
      'subtitle': 'Summaries, Referrals, Notes',
      'icon': Symbols.medical_services,
      'iconColor': AppColors.primaryMediumLight, // Blue
      'destination': const MedicalHistoryScreen(),
    },
    {
      'title': 'Medications',
      'subtitle': 'Active prescriptions',
      'icon': Symbols.pill,
      'iconColor': AppColors.primaryMediumLight, // Unified Blue
      'destination': const MedicationsScreen(),
    },
    {
      'title': 'Lab Reports',
      'subtitle': 'Blood work PDFs',
      'icon': Symbols.lab_research,
      'iconColor': AppColors.successEmerald, // Emerald
      'destination': const LabResultsScreen(),
    },
    {
      'title': 'Radiology Reports',
      'subtitle': 'X-Ray & MRI',
      'icon': Symbols.featured_play_list,
      'iconColor': AppColors.warningAmber, // Amber
      'destination': const RadiologyScreen(),
    },
    {
      'title': 'Timeline',
      'subtitle': 'Complete visit history',
      'icon': Symbols.schedule,
      'iconColor': AppColors.primaryColor, // Unified Blue
      'destination': const VisitTimelineScreen(),
    },
  ];

  List<Map<String, dynamic>> filteredFiles = [];

  @override
  void initState() {
    super.initState();
    filteredFiles = allFiles;
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allFiles;
    } else {
      results =
          allFiles
              .where(
                (file) => file['title'].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
    }
    setState(() {
      filteredFiles = results;
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
        toolbarHeight: (56 * res.scale).toDouble(),
        leadingWidth: ((res.isTablet ? 90 : 70) * res.scale).toDouble(),
        leading: Container(
          margin: EdgeInsets.only(
            left: ((res.isTablet ? 20 : 12) * res.scale).toDouble(),
          ),
          alignment: Alignment.centerLeft,
          child: ClipOval(
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all((8 * res.scale).toDouble()),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primaryTextColor,
                    size: (20 * res.scale).toDouble(),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'My Medical Files',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: (18 * res.scale).toDouble(),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search medical files...',
            onChanged: _runSearch,
            res: res,
          ),
          Expanded(
            child:
                filteredFiles.isNotEmpty
                    ? ListView.builder(
                      padding: EdgeInsets.only(
                        left: ((res.isTablet ? 24 : 20) * res.scale).toDouble(),
                        right:
                            ((res.isTablet ? 24 : 20) * res.scale).toDouble(),
                        top: (4 * res.scale).toDouble(),
                        bottom: (20 * res.scale).toDouble(),
                      ),
                      itemCount: filteredFiles.length,
                      itemBuilder:
                          (context, index) => _buildFileCategoryCard(
                            context,
                            res.scale.toDouble(),
                            res.isTablet,
                            title: filteredFiles[index]['title'],
                            subtitle: filteredFiles[index]['subtitle'],
                            icon: filteredFiles[index]['icon'],
                            iconColor: filteredFiles[index]['iconColor'],
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          filteredFiles[index]['destination'],
                                ),
                              );
                            },
                          ),
                    )
                    : Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(
                          fontSize: (14 * res.scale).toDouble(),
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCategoryCard(
    BuildContext context,
    double scaleFactor,
    bool isTablet, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: (14 * scaleFactor).toDouble()),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14 * scaleFactor),
        border: Border.all(color: AppColors.cardBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTextColor.withOpacity(0.03),
            blurRadius: 10 * scaleFactor,
            // offset: Offset(0, 4 * scaleFactor),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular((14 * scaleFactor).toDouble()),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all((16 * scaleFactor).toDouble()),
            child: Row(
              children: [
                /// Icon Background
                Container(
                  width: (50 * scaleFactor).toDouble(),
                  height: (50 * scaleFactor).toDouble(),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(
                      (6 * scaleFactor).toDouble(),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: (26 * scaleFactor).toDouble(),
                  ),
                ),

                SizedBox(width: (16 * scaleFactor).toDouble()),

                /// Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: (13 * scaleFactor).toDouble(),
                          color: AppColors.headingColor,
                        ),
                      ),
                      SizedBox(height: (4 * scaleFactor).toDouble()),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.bodyTextColor,
                          fontSize: (12 * scaleFactor).toDouble(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Forward Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor,
                  size: (12 * scaleFactor).toDouble(),
                ),
                SizedBox(width: (8 * scaleFactor).toDouble()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
