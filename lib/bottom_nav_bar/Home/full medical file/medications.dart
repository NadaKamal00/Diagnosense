import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:application/core/theme/app_colors.dart';
import '../../../core/utils/api_service.dart';
import '../../../shared/widgets/custom_search_bar.dart';
import '../home_shimmer.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  List<Map<String, dynamic>> allMedications = [];
  List<Map<String, dynamic>> filteredMedications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  Future<void> _fetchMedications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().getMedications();

      if (!mounted) return;

      // The backend returns {"data": [...]}. We check if 'data' key exists.
      if (response.containsKey('data') && response['data'] is List) {
        final List<dynamic> data = response['data'];
        List<Map<String, dynamic>> fetchedMedications =
            List<Map<String, dynamic>>.from(data);

        // Sorting Logic: Active first, then Completed, then others.
        fetchedMedications.sort((a, b) {
          final statusA = (a['status'] ?? '').toString().toLowerCase();
          final statusB = (b['status'] ?? '').toString().toLowerCase();
          if (statusA == 'active' && statusB != 'active') return -1;
          if (statusA != 'active' && statusB == 'active') return 1;
          if (statusA == 'completed' && statusB != 'completed') return 1;
          if (statusA != 'completed' && statusB == 'completed') return -1;
          return 0;
        });

        if (mounted) {
          setState(() {
            allMedications = fetchedMedications;
            filteredMedications = allMedications;
            _isLoading = false;
          });
        }
        print(
          'DEBUG: [MedicationsUI] Successfully parsed ${allMedications.length} medications.',
        );
      } else if (response['success'] == true) {
        // Fallback for legacy success:true structure
        final List<dynamic> data = response['data'] ?? [];
        List<Map<String, dynamic>> fetchedMedications =
            List<Map<String, dynamic>>.from(data);

        // Sorting Logic: Active first, then Completed, then others.
        fetchedMedications.sort((a, b) {
          final statusA = (a['status'] ?? '').toString().toLowerCase();
          final statusB = (b['status'] ?? '').toString().toLowerCase();
          if (statusA == 'active' && statusB != 'active') return -1;
          if (statusA != 'active' && statusB == 'active') return 1;
          if (statusA == 'completed' && statusB != 'completed') return 1;
          if (statusA != 'completed' && statusB == 'completed') return -1;
          return 0;
        });

        if (mounted) {
          setState(() {
            allMedications = fetchedMedications;
            filteredMedications = allMedications;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Unable to parse medication data.';
          _isLoading = false;
        });
        print('DEBUG: [MedicationsUI] API Error Message: $_errorMessage');
        _showErrorSnackBar(_errorMessage!);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
        _isLoading = false;
      });
      print('DEBUG: [MedicationsUI] Catch Error: $e');
      _showErrorSnackBar(_errorMessage!);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _runSearch(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allMedications;
    } else {
      results =
          allMedications
              .where(
                (med) => med['name'].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
              )
              .toList();
    }
    setState(() {
      filteredMedications = results;
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
          'Medications',
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
          // Search Bar
          CustomSearchBar(
            hintText: 'Search Medications...',
            onChanged: _runSearch,
            res: res,
          ),

          SizedBox(height: 10 * res.scale),

          Expanded(
            child:
                _isLoading
                    ? HomeShimmer.buildMedicationListShimmer(
                        scale: res.scale,
                        isTablet: res.isTablet,
                      )
                    : _errorMessage != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.errorColor.withOpacity(0.7),
                            size: 48 * res.scale,
                          ),
                          SizedBox(height: 16 * res.scale),
                          Text(
                            "Failed to load medications",
                            style: TextStyle(
                              fontSize: 16 * res.scale,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          SizedBox(height: 8 * res.scale),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14 * res.scale,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                          SizedBox(height: 12 * res.scale),
                          // Added detailed error info visible only in UI
                          if (_errorMessage!.contains('401'))
                            Text(
                              "UNAUTHORIZED: Token might be expired.",
                              style: TextStyle(
                                fontSize: 12 * res.scale,
                                color: AppColors.warningAmber,
                              ),
                            ),
                          SizedBox(height: 24 * res.scale),
                          ElevatedButton(
                            onPressed: _fetchMedications,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12 * res.scale),
                              ),
                            ),
                            child: const Text("Try Again"),
                          ),
                        ],
                      ),
                    )
                    : filteredMedications.isNotEmpty
                    ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: (res.isTablet ? 24 : 20) * res.scale,
                      ),
                      itemCount: filteredMedications.length,
                      itemBuilder:
                          (context, index) => _buildMedicationCard(
                            name: filteredMedications[index]['name'],
                            dosage: filteredMedications[index]['dosage'],
                            sig: filteredMedications[index]['frequency'] ??
                                'As prescribed', // Mapping "frequency" to "sig"
                            status: filteredMedications[index]['status'] ??
                                'UNKNOWN',
                            scale: res.scale,
                            isTablet: res.isTablet,
                          ),
                    )
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.pill,
                            color: Colors.grey[300],
                            size: 64 * res.scale,
                          ),
                          SizedBox(height: 16 * res.scale),
                          Text(
                            "No medications found",
                            style: TextStyle(
                              fontSize: 14 * res.scale,
                              color: AppColors.mutedColor,
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

  Widget _buildMedicationCard({
    required String name,
    required String dosage,
    required String sig,
    required String status,
    required double scale,
    required bool isTablet,
  }) {
    final bool isCompleted = status.toLowerCase() == "completed";

    // Conditional Styling Colors
    final Color mainIconColor = isCompleted ? AppColors.mutedColor : AppColors.primaryColor;
    final Color titleColor = isCompleted ? AppColors.mutedColor : AppColors.primaryTextColor;
    final Color textColor =
        isCompleted ? AppColors.completedGrey : AppColors.secondaryTextColor;
    final Color statusColor = isCompleted ? AppColors.mutedColor : AppColors.activeGreen;

    return Container(
      margin: EdgeInsets.only(bottom: (isTablet ? 10 : 12) * scale),
      padding: EdgeInsets.symmetric(
        horizontal: (isTablet ? 14 : 16) * scale,
        vertical: (isTablet ? 12 : 16) * scale,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(
          color: AppColors.secondaryBorderColor.withOpacity(0.5),
          width: 0.5 * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTextColor.withOpacity(0.02),
            blurRadius: 8 * scale,
            offset: Offset(0, 3 * scale),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              /// Icon
              Container(
                width: 50 * scale,
                height: 37 * scale,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6 * scale),
                ),
                child: Icon(
                  Symbols.pill,
                  color: mainIconColor,
                  size: (isTablet ? 22 : 24) * scale,
                ),
              ),
              SizedBox(width: 12 * scale),

              /// Name + Dosage
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: (isTablet ? 13 : 15) * scale,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      dosage,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontSize: (isTablet ? 11 : 12) * scale,
                      ),
                    ),
                  ],
                ),
              ),

              /// Time Icon Container
              Container(
                alignment: Alignment.center,
                width: (isTablet ? 30 : 36) * scale,
                height: (isTablet ? 24 : 28) * scale,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6 * scale),
                ),
                child: Icon(
                  Icons.access_time,
                  color: isCompleted ? AppColors.mutedColor.withOpacity(0.5) : AppColors.mutedColor,
                  size: (isTablet ? 15 : 18) * scale,
                ),
              ),
            ],
          ),

          SizedBox(height: (isTablet ? 12 : 15) * scale),

          /// SIG Container (Info Section)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: (isTablet ? 8 : 10) * scale,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6 * scale),
              border: Border.all(
                color: AppColors.cardBorderColor,
                width: 0.5 * scale,
              ),
            ),
            child: Row(
              children: [
                Text(
                  "SIG  ",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: (isTablet ? 10 : 12) * scale,
                    color: titleColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    sig,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontSize: (isTablet ? 10 : 12) * scale,
                    ),
                  ),
                ),
                Icon(
                  Icons.circle,
                  color: statusColor,
                  size: 6 * scale,
                ),
                SizedBox(width: 6 * scale),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: (isTablet ? 10 : 11) * scale,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
