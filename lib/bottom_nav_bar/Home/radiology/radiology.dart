import 'package:application/bottom_nav_bar/Home/radiology/radiology_details.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              dataList
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList();
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
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all((8 * res.scale).toDouble()),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: const Color(0xFF0E1A34),
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
            color: const Color(0xFF0E1A34),
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
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredRadiology.isNotEmpty
                    ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: ((res.isTablet ? 24 : 20) * res.scale)
                            .toDouble(),
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
                    : Center(
                      child: Text(
                        "No radiology reports found",
                        style: TextStyle(
                          fontSize: (14 * res.scale).toDouble(),
                          color: Colors.grey,
                        ),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          border: Border.all(
            color: const Color(0xFFCDCDCD),
            width: .5 * scaleFactor,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC9C9C9).withOpacity(0.25),
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
                color: const Color(0xFFEDF2FF),
                borderRadius: BorderRadius.circular(8 * scaleFactor),
              ),
              child: SvgPicture.asset(
                'assets/Icons/file-icon.svg',
                width: 16.25 * scaleFactor,
                height: 20.71 * scaleFactor,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF777777),
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
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(6 * scaleFactor),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: const Color(0xFF2563EB),
                            fontSize: 12 * scaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          color: const Color(0xFF939393),
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
                            color: const Color(0xFF0E1A34),
                          ),
                        ),
                      ),
                      Text(
                        'Open',
                        style: TextStyle(
                          color: const Color(0xFF2563EB),
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
                      color: const Color(0xFF939393),
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
