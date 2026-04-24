import 'package:application/core/utils/api_service.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:application/utils/task_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/theme/shimmer_effect.dart';
import '../../core/theme/app_colors.dart';

class TaskDetailsScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool _isLoading = true;
  bool _isCompleting = false;
  bool _hasStatusChanged =
      false; // Track if status was toggled for list refresh
  Map<String, dynamic>? _taskData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    try {
      final result = await ApiService().getTaskDetails(widget.taskId);
      if (mounted) {
        setState(() {
          if (result['success'] == true && result['data'] != null) {
            _taskData = result['data'] as Map<String, dynamic>;
          } else {
            _errorMessage =
                result['message']?.toString() ?? 'Failed to load task.';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onToggleStatus() async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      final response = await ApiService().toggleTaskStatus(widget.taskId);
      if (mounted) {
        if (response['success'] == true) {
          // Update local state based on API response
          final newData = response['data'];
          if (newData != null && newData is Map<String, dynamic>) {
            setState(() {
              _taskData?['is_completed'] = newData['is_completed'];
              _hasStatusChanged = true;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to update status'),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final bool isTablet = res.isTablet;
    final double scaleFactor = res.scale;

    // Extract fields safely from API response
    final String title = _taskData?['title']?.toString() ?? '';
    final String dueDate = _taskData?['Due_date']?.toString() ?? '';

    final String rawDescription = _taskData?['description']?.toString() ?? '';
    final String description =
        rawDescription.isEmpty ? 'No description' : rawDescription;

    final String rawNotes = _taskData?['notes']?.toString() ?? '';
    final String notes = rawNotes.isEmpty ? 'No Instructions Needed' : rawNotes;

    final String doctorName =
        _taskData?['visit']?['doctor_name']?.toString() ?? '';

    final bool isCompleted =
        _taskData?['is_completed'] == 1 ||
        _taskData?['is_completed'] == true ||
        _taskData?['is_completed'] == "1";

    final bool isOverdue = TaskHelper.isOverdue(dueDate);
    final String visitDate =
        _taskData?['visit']?['date']?.toString() ?? dueDate;
    final String visitTime = _taskData?['visit']?['time']?.toString() ?? '';

    final Color deadlineColor;
    final Color deadlineBg;
    final Color badgeBg;
    final Color badgeText;
    final Color instrBg;
    final Color instrBorder;
    final bool showInstrAccent = !isCompleted;

    if (isCompleted) {
      deadlineColor = AppColors.mutedColor; // Grey
      deadlineBg = AppColors.surfaceVariant;
      badgeBg = AppColors.surfaceVariant;
      badgeText = AppColors.bodyTextColor;
      instrBg = AppColors.shimmerHighlight;
      instrBorder = AppColors.black.withOpacity(0.05);
    } else if (isOverdue) {
      deadlineColor = AppColors.errorColor;
      deadlineBg = AppColors.errorLightBackground;
      badgeBg = AppColors.lightBlueSurface;
      badgeText = AppColors.primaryColor;
      instrBg = AppColors.instructionBackground;
      instrBorder = AppColors.warningAmber.withOpacity(0.3);
    } else {
      deadlineColor = AppColors.successEmerald;
      deadlineBg = AppColors.successLight;
      badgeBg = AppColors.lightBlueSurface;
      badgeText = AppColors.primaryColor;
      instrBg = AppColors.instructionBackground;
      instrBorder = AppColors.warningAmber.withOpacity(0.3);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        toolbarHeight: 56 * scaleFactor,
        leadingWidth: (isTablet ? 100 : 70) * scaleFactor,
        leading: Container(
          margin: EdgeInsets.only(left: (isTablet ? 20 : 12) * scaleFactor),
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryTextColor,
              size: 20 * scaleFactor,
            ),
            onPressed: () => Navigator.pop(context, _hasStatusChanged),
          ),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18 * scaleFactor,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body:
          _isLoading
              ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (isTablet ? 24 : 20) * scaleFactor,
                  vertical: 34 * scaleFactor,
                ),
                child: HomeShimmer.buildTaskDetailsShimmer(scale: scaleFactor),
              )
              : _errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.errorColor),
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (isTablet ? 24 : 20) * scaleFactor,
                  vertical: 10 * scaleFactor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 1,
                      thickness: .5,
                      color: AppColors.dividerColor,
                      indent: (isTablet ? 20 : 40) * scaleFactor,
                      endIndent: (isTablet ? 20 : 40) * scaleFactor,
                    ),
                    SizedBox(height: 24 * scaleFactor),

                    // ── Main task card ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20 * scaleFactor),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14 * scaleFactor),
                        border: Border.all(
                          color: AppColors.secondaryBorderColor,
                          width: .5 * scaleFactor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.04),
                            blurRadius: 4 * scaleFactor,
                            offset: Offset(0, 4 * scaleFactor),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Blue badge + clock icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildBadge(
                                  doctorName.isNotEmpty
                                      ? 'Dr. $doctorName'
                                      : 'DOCTOR ORDERED',
                                  scaleFactor,
                                  badgeBg,
                                  badgeText,
                                ),
                              ),
                              SizedBox(width: 8 * scaleFactor),
                              Container(
                                padding: EdgeInsets.all(6 * scaleFactor),
                                decoration: BoxDecoration(
                                  color: deadlineBg,
                                  borderRadius: BorderRadius.circular(
                                    6 * scaleFactor,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  'assets/Icons/clock.svg',
                                  width: 16 * scaleFactor,
                                  colorFilter: ColorFilter.mode(
                                    deadlineColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16 * scaleFactor),

                          // Task title
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 17 * scaleFactor,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          SizedBox(height: 16 * scaleFactor),

                          // Due date
                          Padding(
                            padding: EdgeInsets.only(bottom: 5 * scaleFactor),
                            child: Text(
                              "Due Date",
                              style: TextStyle(
                                color: AppColors.mutedTextColor,
                                fontSize: 13 * scaleFactor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            visitTime.isNotEmpty ? visitDate : visitDate,
                            style: TextStyle(
                              fontSize: 15 * scaleFactor,
                              fontWeight: FontWeight.w600,
                              color: deadlineColor,
                            ),
                          ),

                          // Divider
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16 * scaleFactor,
                            ),
                            child: Divider(
                              color: AppColors.dividerColor,
                              thickness: .5 * scaleFactor,
                            ),
                          ),

                          // Description
                          Padding(
                            padding: EdgeInsets.only(bottom: 5 * scaleFactor),
                            child: Text(
                              "Description",
                              style: TextStyle(
                                color: AppColors.mutedTextColor,
                                fontSize: 13 * scaleFactor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 13 * scaleFactor,
                              color: AppColors.mutedColor,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    // ── Doctor Instructions card ────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(22 * scaleFactor),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14 * scaleFactor),
                        border:
                            showInstrAccent
                                ? Border(
                                  left: BorderSide(
                                    color: AppColors.warningAmber,
                                    width: 3 * scaleFactor,
                                  ),
                                )
                                : Border.all(
                                  color: AppColors.black.withOpacity(0.05),
                                  width: 1 * scaleFactor,
                                ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.04),
                            blurRadius: 10 * scaleFactor,
                            offset: Offset(0, 4 * scaleFactor),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Doctor Instructions",
                            style: TextStyle(
                              fontSize: 15 * scaleFactor,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTextColor,
                            ),
                          ),
                          SizedBox(height: 16 * scaleFactor),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12 * scaleFactor),
                            decoration: BoxDecoration(
                              color: instrBg,
                              borderRadius: BorderRadius.circular(
                                6 * scaleFactor,
                              ),
                              border: Border.all(
                                color: instrBorder,
                                width: 1 * scaleFactor,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "\" $notes \"",
                                    style: TextStyle(
                                      fontSize: 13 * scaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.completedGrey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8 * scaleFactor),
                                Icon(
                                  Icons.tips_and_updates,
                                  color: AppColors.warningAmber,
                                  size: 18 * scaleFactor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 120 * scaleFactor),
                  ],
                ),
              ),

      bottomNavigationBar: Container(
        color: AppColors.backgroundColor,
        padding: EdgeInsets.fromLTRB(
          24 * scaleFactor,
          10 * scaleFactor,
          24 * scaleFactor,
          (isTablet ? 30 : 40) * scaleFactor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading
                      ? HomeShimmer.buildButtonShimmer(scale: scaleFactor)
                      : _buildButton(
                        isCompleted ? "Completed" : "Mark as Done",
                        !isCompleted,
                        isCompleted
                            ? AppColors.successText
                            : AppColors.primaryColor,
                        scaleFactor,
                        onTap: _onToggleStatus,
                        isLoading: _isCompleting,
                      ),
                  SizedBox(height: 20 * scaleFactor),
                  InkWell(
                    onTap: () => Navigator.pop(context, _hasStatusChanged),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 14 * scaleFactor,
                          color: AppColors.mutedTextColor,
                        ),
                        SizedBox(width: 8 * scaleFactor),
                        Text(
                          "Back to Tasks",
                          style: TextStyle(
                            fontSize: 13 * scaleFactor,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedTextColor,
                          ),
                        ),
                      ],
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

  // ── Helper widgets ─────────────────────────────────────────────────────────

  Widget _buildBadge(
    String text,
    double scale,
    Color background,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 6 * scale,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6 * scale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/Icons/user-stroke-rounded.svg',
            width: 18 * scale,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),

          SizedBox(width: 6 * scale),
          Expanded(
            child: Text(
              text,
              softWrap: true,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: textColor,
                fontSize: 11 * scale,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    bool isPrimary,
    Color color,
    double scale, {
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52 * scale,
        decoration: BoxDecoration(
          gradient:
              isPrimary
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryColor, AppColors.accentColor],
                  )
                  : null,
          color: isPrimary ? null : color,
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        alignment: Alignment.center,
        child:
            isLoading
                ? SizedBox(
                  width: 20 * scale,
                  height: 20 * scale,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.bold,
                    color:
                        (isPrimary || color != AppColors.white)
                            ? AppColors.white
                            : AppColors.primaryTextColor,
                  ),
                ),
      ),
    );
  }
}
