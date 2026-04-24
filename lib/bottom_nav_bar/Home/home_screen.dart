import 'package:application/utils/responsive_helper.dart';
import 'package:application/bottom_nav_bar/Home/full%20medical%20file/medical_file.dart';
import 'package:application/bottom_nav_bar/Tasks/task_details.dart';
import 'package:application/bottom_nav_bar/Home/history/history.dart';
import 'package:application/bottom_nav_bar/Home/lab%20results/lab_reports.dart';
import 'package:application/bottom_nav_bar/Home/notifications/notifications.dart';
import 'package:application/bottom_nav_bar/Home/radiology/radiology.dart';
import 'package:application/bottom_nav_bar/Tasks/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/shimmer_effect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingNextVisit = true;
  Map<String, dynamic>? _nextVisitData;
  bool _isLoadingTasks = true;
  List<dynamic> _tasks = [];
  String? _patientName;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchNextVisit();
    _fetchTasks();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    print(
      "DEBUG: [HOME_SCREEN] Fetching 'user_name' from prefs, value is: $name",
    );
    if (mounted) {
      setState(() {
        _patientName = name;
        _isLoadingUser = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh user name whenever this screen becomes active again (e.g., tab switch after edit)
    _loadUserData();
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await ApiService().getPatientTasks();
      if (mounted) {
        setState(() {
          if (response['success'] == true && response['data'] != null) {
            _tasks = response['data'] as List<dynamic>;
          }
          _isLoadingTasks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTasks = false;
        });
      }
    }
  }

  Future<void> _fetchNextVisit() async {
    try {
      final response = await ApiService().getNextVisit();
      if (mounted) {
        setState(() {
          if (response['success'] == true && response['data'] != null) {
            _nextVisitData = response['data'];
          }
          _isLoadingNextVisit = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingNextVisit = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await Future.wait([_fetchTasks(), _fetchNextVisit()]);
  }

  @override
  Widget build(BuildContext context) {
    // Explicitly watch ThemeProvider to respond to dark mode toggles instantly
    context.watch<ThemeProvider>();

    final res = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: res.isTablet ? 450 * res.scale : res.width,
            ),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: res.isTablet ? 5 * res.scale : 20 * res.scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 10 * res.scale),

                    /// Header
                    _isLoadingUser
                        ? HomeShimmer.buildHeaderShimmer(context, res.scale)
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${_patientName ?? 'User'}!',
                                  style: TextStyle(
                                    fontSize: 18 * res.scale,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                                Text(
                                  'Welcome back.',
                                  style: TextStyle(
                                    fontSize: 15 * res.scale,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            _buildNotificationIcon(context, res.scale),
                          ],
                        ),

                    SizedBox(height: 22 * res.scale),

                    /// Upcoming Tasks Card
                    _buildUpcomingTasksCard(context, res.scale),

                    SizedBox(height: 25 * res.scale),

                    /// Next Visit (Gradient Card)
                    _buildNextVisitCard(res.scale),

                    SizedBox(height: 30 * res.scale),

                    _isLoadingUser
                        ? HomeShimmer.buildMedicalFilesShimmer(res.scale)
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// --- Medical File Title ---
                            Text(
                              'Medical Files',
                              style: TextStyle(
                                fontSize: 18 * res.scale,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            SizedBox(height: 15 * res.scale),

                            /// Medical Items Row (History, Lab, Radiology)
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMedicalItem(
                                    context,
                                    'History',
                                    'assets/Icons/history.svg',
                                    AppColors.historyItemBg,
                                    AppColors.accentColor,
                                    res.scale,
                                    () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const MedicalHistoryScreen(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12 * res.scale),
                                Expanded(
                                  child: _buildMedicalItem(
                                    context,
                                    'Lab Results',
                                    'assets/Icons/lap-reports.svg',
                                    AppColors.labItemBg,
                                    AppColors.successText,
                                    res.scale,
                                    () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const LabResultsScreen(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12 * res.scale),
                                Expanded(
                                  child: _buildMedicalItem(
                                    context,
                                    'Radiology',
                                    'assets/Icons/radiology.svg',
                                    AppColors.radiologyItemBg,
                                    AppColors.radiologyIconColor,
                                    res.scale,
                                    () => Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const RadiologyScreen(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15 * res.scale),

                            /// View Full Medical File Button
                            _buildFullFileButton(context, res.scale),
                          ],
                        ),

                    SizedBox(height: 30 * res.scale),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context, double scale) {
    return IconButton(
      onPressed:
          () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          ),
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            'assets/Icons/notification.svg',
            width: 22 * scale,
            height: 22 * scale,
            colorFilter: ColorFilter.mode(AppColors.iconGrey, BlendMode.srcIn),
          ),
          Positioned(
            right: -2 * scale,
            top: -4 * scale,
            child: Container(
              width: 8 * scale,
              height: 8 * scale,
              decoration: BoxDecoration(
                color: AppColors.warningText,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.2 * scale),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTasksCard(BuildContext context, double scale) {
    if (_isLoadingTasks) {
      return HomeShimmer.buildUpcomingTasksShimmer(scale);
    }

    final incompleteTasks =
        _tasks.where((task) {
          final isCompletedValue = task['is_completed'];
          return isCompletedValue == 0 ||
              isCompletedValue == false ||
              isCompletedValue == "0";
        }).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10 * scale,
        horizontal: 15 * scale,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        border: Border.all(color: AppColors.borderColor, width: 0.5 * scale),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadowColor.withOpacity(0.25),
            blurRadius: 7.9 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Upcoming Tasks & View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Tasks',
                style: TextStyle(
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTextColor,
                ),
              ),
              TextButton(
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TaskScreen(),
                      ),
                    ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15 * scale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * scale),
          incompleteTasks.isEmpty
              ? Padding(
                padding: EdgeInsets.symmetric(vertical: 20 * scale),
                child: Center(
                  child: Text(
                    "No upcoming medical tasks",
                    style: TextStyle(
                      color: AppColors.mutedTextColor,
                      fontSize: 14 * scale,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children:
                      incompleteTasks.map((task) {
                        final String title =
                            task['title']?.toString() ?? 'Task';
                        final String dueDate =
                            task['visit']?['next_visit_date']?.toString() ??
                            'No Date';
                        final int taskId =
                            int.tryParse(task['id']?.toString() ?? '0') ?? 0;

                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        TaskDetailsScreen(taskId: taskId),
                              ),
                            );
                            if (result == true) {
                              _fetchTasks();
                            }
                          },
                          child: Container(
                            width: 215 * scale,
                            margin: EdgeInsets.only(
                              right: 12 * scale,
                              bottom: 8 * scale,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12 * scale,
                              vertical: 12 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightBlueSurface.withOpacity(
                                0.7,
                              ),
                              borderRadius: BorderRadius.circular(16 * scale),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                width: 1 * scale,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48 * scale,
                                  height: 48 * scale,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlueSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/Icons/document.svg',
                                      width: 22 * scale,
                                      height: 22 * scale,
                                      colorFilter: ColorFilter.mode(
                                        AppColors.primaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16 * scale),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16 * scale,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryTextColor,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      SizedBox(height: 4 * scale),
                                      Text(
                                        'Due: $dueDate',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13 * scale,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mutedTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildNextVisitCard(double scale) {
    if (_isLoadingNextVisit) {
      return HomeShimmer.buildNextVisitShimmer(scale);
    }

    if (_nextVisitData == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20 * scale),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryMediumLight, AppColors.primaryDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16 * scale),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradientShadow,
              blurRadius: 22 * scale,
              offset: Offset(0, 8 * scale),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Next Visit',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.7),
                fontSize: 18 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16 * scale),
            Center(
              child: Text(
                'No Upcoming Visits',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16 * scale),
          ],
        ),
      );
    }

    final doctorName = _nextVisitData!['doctor_name'] ?? '';
    final specialization = _nextVisitData!['specialization'] ?? '';
    final date = _nextVisitData!['date'] ?? '';
    final time = _nextVisitData!['time'] ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * scale),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryMediumLight, AppColors.primaryDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // color: const Color(0xFF2A66FF),
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradientShadow,
            blurRadius: 22 * scale,
            offset: Offset(0, 8 * scale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Visit',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.7),
              fontSize: 18 * scale,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8 * scale),
          Text(
            'Dr. $doctorName',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            specialization,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 12 * scale,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 18 * scale),
          Container(
            padding: EdgeInsets.all(15 * scale),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6 * scale),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVisitInfo('Date', date, scale),
                _buildVisitInfo('Time', time, scale),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitInfo(String label, String value, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.7),
            fontSize: 12 * scale,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14 * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalItem(
    BuildContext context,
    String title,
    String svgPath,
    Color bgColor,
    Color iconColor,
    double scale,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4 * scale,
          vertical: 15 * scale,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(
            color: AppColors.secondaryBorderColor,
            width: 0.5 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadowColor.withOpacity(0.25),
              blurRadius: 7.9 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10 * scale),
              width: 44 * scale,
              height: 44 * scale,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: SvgPicture.asset(
                svgPath,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            SizedBox(height: 10 * scale),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreyText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullFileButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => const MedicalFilesScreen()),
          ),
      child: Container(
        width: double.infinity,
        height: 50 * scale,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10 * scale),
          border: Border.all(
            color: AppColors.secondaryBorderColor,
            width: 0.5 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadowColor.withOpacity(0.25),
              blurRadius: 7.9 * scale,
              // offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'View Full Medical File',
            style: TextStyle(
              color: AppColors.accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 14 * scale,
            ),
          ),
        ),
      ),
    );
  }
}
