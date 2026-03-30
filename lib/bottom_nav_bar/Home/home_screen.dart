import 'package:application/utils/responsive_helper.dart';
import 'package:application/bottom_nav_bar/Home/full%20medical%20file/medical_file.dart';
import 'package:application/bottom_nav_bar/Tasks/task_details.dart';
import 'package:application/bottom_nav_bar/Home/history/history.dart';
import 'package:application/bottom_nav_bar/Home/lab%20results/lap_reports.dart';
import 'package:application/bottom_nav_bar/Home/notifications/notifications.dart';
import 'package:application/bottom_nav_bar/Home/radiology/radiology.dart';
import 'package:application/bottom_nav_bar/Tasks/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Settings/notifications_settings.dart';
import '../../core/utils/api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: res.isTablet ? 450 * res.scale : res.width,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: res.isTablet ? 5 * res.scale : 20 * res.scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20 * res.scale),

                  /// Header
                  Row(
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
                              color: const Color(0xFF0E1A34),
                            ),
                          ),
                          Text(
                            'Welcome back.',
                            style: TextStyle(
                              fontSize: 15 * res.scale,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8A94A6),
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

                  /// --- Medical File Title ---
                  Text(
                    'Medical Files',
                    style: TextStyle(
                      fontSize: 18 * res.scale,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0E1A34),
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
                          const Color(0xFFE4ECFF),
                          const Color(0xFF3B82F6),
                          res.scale,
                          () => Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const MedicalHistoryScreen(),
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
                          const Color(0xFFCCFFD6),
                          const Color(0xFF34A853),
                          res.scale,
                          () => Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => const LabResultsScreen(),
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
                          const Color.fromARGB(255, 255, 236, 228),
                          const Color(0xFFB93815),
                          res.scale,
                          () => Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => const RadiologyScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15 * res.scale),

                  /// View Full Medical File Button
                  _buildFullFileButton(context, res.scale),

                  SizedBox(height: 30 * res.scale),
                ],
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
            colorFilter: const ColorFilter.mode(
              Color(0xFF667085),
              BlendMode.srcIn,
            ),
          ),
          Positioned(
            right: -2 * scale,
            top: -4 * scale,
            child: Container(
              width: 8 * scale,
              height: 8 * scale,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7B00),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.2 * scale),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTasksCard(BuildContext context, double scale) {
    if (_isLoadingTasks) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20 * scale),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final incompleteTasks =
        _tasks.where((task) {
          final isCompletedValue = task['is_completed'];
          return isCompletedValue == 0 ||
              isCompletedValue == false ||
              isCompletedValue == "0";
        }).toList();

    if (incompleteTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10 * scale,
        horizontal: 15 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        border: Border.all(color: const Color(0xFFD9D9D9), width: 0.5 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC9C9C9).withOpacity(0.25),
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
                  color: const Color(0xFF0E1A34),
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
                    color: const Color(0xFF2563EB),
                    fontSize: 15 * scale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * scale),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children:
                  incompleteTasks.map((task) {
                    final String title = task['title']?.toString() ?? 'Task';
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
                                (context) => TaskDetailsScreen(taskId: taskId),
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
                          color: const Color(0xFFEBF1FF),
                          borderRadius: BorderRadius.circular(16 * scale),
                          border: Border.all(
                            color: const Color(0xFF2563EB).withOpacity(0.1),
                            width: 1 * scale,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48 * scale,
                              height: 48 * scale,
                              decoration: const BoxDecoration(
                                color: Color(0xFFCDDCFF),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/Icons/document.svg',
                                  width: 22 * scale,
                                  height: 22 * scale,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF2563EB),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16 * scale),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16 * scale,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0E1A34),
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
                                      color: const Color(0xFF64748B),
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
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20 * scale),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3A80F5), Color(0xFF2B65D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16 * scale),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF74A9FF),
              blurRadius: 22 * scale,
              offset: Offset(0, 8 * scale),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20 * scale),
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (_nextVisitData == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20 * scale),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3A80F5), Color(0xFF2B65D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16 * scale),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF74A9FF),
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
                color: Colors.white70,
                fontSize: 18 * scale,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16 * scale),
            Center(
              child: Text(
                'No Upcoming Visits',
                style: TextStyle(
                  color: Colors.white,
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
        gradient: const LinearGradient(
          colors: [Color(0xFF3A80F5), Color(0xFF2B65D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // color: const Color(0xFF2A66FF),
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF74A9FF),
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
              color: Colors.white70,
              fontSize: 18 * scale,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8 * scale),
          Text(
            'Dr. $doctorName',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            specialization,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12 * scale,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 18 * scale),
          Container(
            padding: EdgeInsets.all(15 * scale),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
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
            color: Colors.white70,
            fontSize: 12 * scale,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(
            color: const Color(0xFFCDCDCD),
            width: 0.5 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFC9C9C9).withOpacity(0.25),
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
                color: const Color(0xFF2D2D2D),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(10 * scale),
          border: Border.all(
            color: const Color(0xFFCDCDCD),
            width: 0.5 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFC9C9C9).withOpacity(0.25),
              blurRadius: 7.9 * scale,
              // offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'View Full Medical File',
            style: TextStyle(
              color: const Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
              fontSize: 14 * scale,
            ),
          ),
        ),
      ),
    );
  }
}
