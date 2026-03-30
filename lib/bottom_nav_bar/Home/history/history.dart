import 'package:flutter/material.dart';
import 'package:application/utils/responsive_helper.dart';
import '../../../shared/widgets/custom_search_bar.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final List<Map<String, dynamic>> allHistory = [
    // {
    //   'title': 'Hospital Discharge Summary.pdf',
    //   'date': 'Nov 12, 2023',
    //   'size': '2.4 MB',
    //   'type': 'PDF',
    //   'typeColor': const Color(0xFFFFE9E7),
    //   'textColor': const Color(0xFFFF3F3F),
    // },
    // {
    //   'title': 'Type 2 Diabetes Diagnosis.pdf',
    //   'date': 'Jan 10, 2022',
    //   'size': '1.1 MB',
    //   'type': 'PDF',
    //   'typeColor': const Color(0xFFFFEBEE),
    //   'textColor': const Color(0xFFEF5350),
    // },
    {
      'title': 'Allergy Panel Results.pdf',
      'date': 'Mar 20, 2018',
      'size': '3.2 MB',
      'type': 'PDF',
      'typeColor': const Color(0xFFFFEBEE),
      'textColor': const Color(0xFFEF5350),
    },
    {
      'title': 'Knee Surgery Operative Report.doc',
      'date': 'Aug 15, 2019',
      'size': '850 KB',
      'type': 'DOC',
      'typeColor': const Color(0xFFD9D9D9),
      'textColor': const Color(0xFF818181),
    },
  ];

  List<Map<String, dynamic>> filteredHistory = [];

  @override
  void initState() {
    super.initState();
    filteredHistory = allHistory;
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allHistory;
    } else {
      results =
          allHistory
              .where(
                (item) => item['title'].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
    }
    setState(() {
      filteredHistory = results;
    });
  }

  void _showOptions(
    BuildContext context,
    Offset tapPosition,
    String title,
    double scaleFactor,
  ) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final List<PopupMenuItem<String>> menuItems = [
      PopupMenuItem(
        value: 'preview',
        child: Row(
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 20 * scaleFactor,
              color: const Color(0xFF3B82F6),
            ),
            SizedBox(width: 10 * scaleFactor),
            Text(
              "Preview",
              style: TextStyle(
                fontSize: 14 * scaleFactor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'download',
        child: Row(
          children: [
            Icon(
              Icons.file_download_outlined,
              size: 20 * scaleFactor,
              color: const Color(0xFF3B82F6),
            ),
            SizedBox(width: 10 * scaleFactor),
            Text(
              "Download",
              style: TextStyle(
                fontSize: 14 * scaleFactor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ];

    await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: menuItems,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * scaleFactor),
      ),
    );
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
          'Medical History',
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
          // Search Bar
          CustomSearchBar(
            hintText: 'Search History...',
            onChanged: _runSearch,
            res: res,
          ),

          SizedBox(height: 5 * res.scale),

          Expanded(
            child:
                filteredHistory.isNotEmpty
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
                          color: Colors.grey,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item, double scaleFactor) {
    return Container(
      margin: EdgeInsets.only(bottom: 15 * scaleFactor),
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
            // offset: Offset(0, 4 * scaleFactor),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          onTapDown:
              (details) => _showOptions(
                context,
                details.globalPosition,
                item['title'],
                scaleFactor,
              ),
          child: Padding(
            padding: EdgeInsets.all(16 * scaleFactor),
            child: Row(
              children: [
                /// Types Icon Badge
                Container(
                  width: 50 * scaleFactor,
                  height: 37 * scaleFactor,
                  decoration: BoxDecoration(
                    color: item['typeColor'],
                    borderRadius: BorderRadius.circular(6 * scaleFactor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item['type'],
                    style: TextStyle(
                      color: item['textColor'],
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
                        item['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13 * scaleFactor,
                          color: const Color(0xFF0E1A34),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4 * scaleFactor),
                      Text(
                        "${item['date']} • ${item['size']}",
                        style: TextStyle(
                          color: const Color(0xFF8A94A6),
                          fontSize: 12 * scaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// More Options Icon
                Icon(
                  Icons.more_vert,
                  color: const Color(0xFF8A94A6),
                  size: 22 * scaleFactor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TODO: لون البوردر بتاع كل ايطون ضيفيه
