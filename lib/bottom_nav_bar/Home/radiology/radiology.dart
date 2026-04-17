import 'package:application/bottom_nav_bar/Home/radiology/radiology_details.dart';
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
      final response = await ApiService().getRadiologyReports();
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
      results =
          allRadiology
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
          'Radiology',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: (18 * res.scale).toDouble(),
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
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredRadiology.isNotEmpty
                      ? ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              ((res.isTablet ? 24 : 20) * res.scale).toDouble(),
                          vertical: (20 * res.scale).toDouble(),
                        ),
                        itemCount: filteredRadiology.length,
                        itemBuilder:
                            (context, index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: (16 * res.scale).toDouble(),
                              ),
                              child: _buildRadiologyCard(
                                context,
                                res.scale.toDouble(),
                                type: filteredRadiology[index]['type'] ?? '',
                                title: filteredRadiology[index]['name'] ?? '',
                                date: filteredRadiology[index]['date'] ?? '',
                                ref: filteredRadiology[index]['doctor'] ?? '',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (_) => RadiologyDetailsScreen(
                                            report: filteredRadiology[index],
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      )
                      : ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          Center(
                            child: Text(
                              "No radiology reports found",
                              style: TextStyle(
                                fontSize: (14 * res.scale).toDouble(),
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
    required String type,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10 * scaleFactor,
                          vertical: 4 * scaleFactor,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueSurface,
                          borderRadius: BorderRadius.circular(6 * scaleFactor),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12 * scaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                  SizedBox(height: 8 * scaleFactor),
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
                  SizedBox(height: 4 * scaleFactor),
                  Text(
                    'Ref: $ref',
                    style: TextStyle(
                      color: AppColors.mutedColor,
                      fontSize: 11 * scaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
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
