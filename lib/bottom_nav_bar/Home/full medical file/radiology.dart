// import 'package:application/bottom_nav_bar/Home/radiology/radiology_details.dart';
import 'package:application/bottom_nav_bar/Home/full%20medical%20file/view_file.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_search_bar.dart';
import '../../../core/utils/api_service.dart';

class RadiologyScreen extends StatefulWidget {
  const RadiologyScreen({super.key});

  @override
  State<RadiologyScreen> createState() => _RadiologyScreenState();
}

class _RadiologyScreenState extends State<RadiologyScreen> {
  List<Map<String, dynamic>> allRadiology = [];
  List<Map<String, dynamic>> filteredRadiology = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRadiologyData();
  }

  Future<void> _fetchRadiologyData() async {
    try {
      final response = await ApiService().getMedicalFiles(type: 'radiology');
      debugPrint("DEBUG: [RadiologyScreen] Raw Response: $response");

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> dataList = response['data'];
        debugPrint(
          "DEBUG: [RadiologyScreen] Data List found, length: ${dataList.length}",
        );

        setState(() {
          allRadiology =
              dataList.map((item) => Map<String, dynamic>.from(item)).toList();
          filteredRadiology = List.from(allRadiology);
          isLoading = false;
        });
      } else {
        debugPrint("DEBUG: [RadiologyScreen] Success false or data null");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("DEBUG: [RadiologyScreen] Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allRadiology;
    } else {
      results = allRadiology
          .where(
            (item) => (item['name'] ?? '').toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      filteredRadiology = results;
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
          margin: EdgeInsets.only(
            left: (res.isTablet ? 20 : 12) * res.scale,
          ),
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
          'Radiology',
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
          CustomSearchBar(
            hintText: 'Search Radiology...',
            onChanged: _runSearch,
            res: res,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchRadiologyData,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredRadiology.isNotEmpty
                      ? ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: (res.isTablet ? 24 : 20) * res.scale,
                            vertical: 20 * res.scale,
                          ),
                          itemCount: filteredRadiology.length,
                          itemBuilder: (context, index) {
                            final item = filteredRadiology[index];

                            /// --- معالجة وتصحيح اسم الدكتور ---
                            String rawReferredBy = item['referred_by'] ?? 'Unknown';
                            String cleanDoctor = rawReferredBy.replaceAll('Ref: ', '').trim();
                            if (cleanDoctor.toLowerCase() == 'unknown' || cleanDoctor.isEmpty) {
                              cleanDoctor = 'Unknown Doctor';
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: 16 * res.scale,
                              ),
                              child: _buildRadiologyCard(
                                context,
                                res.scale,
                                title: item['name'] ?? 'Unknown Report',
                                date: item['date'] ?? 'Unknown Date',
                                ref: cleanDoctor,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ViewFileScreen(
                                        historyItem: item,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : ListView(
                          children: [
                            Spacer(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                            Center(
                              child: Text(
                                "No radiology reports found",
                                style: TextStyle(
                                  fontSize: 14 * res.scale,
                                  color: AppColors.hintGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiologyCard(
    BuildContext context,
    double scaleFactor, {
    required String title,
    required String date,
    required String ref,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              color: AppColors.cardShadowColor.withOpacity(0.25),
              blurRadius: 7.9 * scaleFactor,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // يجعل الأيقونة والسطر الأول متناسقين في المحاذاة
          children: [
            /// --- بوكس الأيقونة على اليسار ---
            Container(
              width: 44 * scaleFactor,
              height: 40 * scaleFactor,
              padding: EdgeInsets.all(10 * scaleFactor),
              decoration: BoxDecoration(
                color: AppColors.lightBlueSurface,
                borderRadius: BorderRadius.circular(8 * scaleFactor),
              ),
              child: SvgPicture.asset(
                'assets/Icons/file-icon.svg',
                width: 16.25 * scaleFactor,
                height: 20.71 * scaleFactor,
                colorFilter: ColorFilter.mode(
                  AppColors.darkMutedColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 14 * scaleFactor),
            
            /// --- محتوى النصوص ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// السطر الأول: الاسم (قصاد الأيقونة مباشرة) والتاريخ في الآخر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13 * scaleFactor,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8 * scaleFactor),
                      Text(
                        date,
                        style: TextStyle(
                          color: AppColors.mutedColor,
                          fontSize: 11 * scaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6 * scaleFactor),
                  
                  /// السطر الثاني: اسم الطبيب وكلمة Open
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Ref: $ref',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.mutedColor,
                            fontSize: 11 * scaleFactor,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Open',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12 * scaleFactor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}