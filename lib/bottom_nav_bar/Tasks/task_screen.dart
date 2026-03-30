import 'package:application/bottom_nav_bar/Tasks/task_details.dart';
import 'package:application/utils/responsive_helper.dart';
import 'package:application/utils/task_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../_navigation_menu.dart';
import '../../core/utils/api_service.dart';
import '../Home/home_shimmer.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _isLoading = true;
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await ApiService().getPatientTasks();
      if (mounted) {
        setState(() {
          if (response['success'] == true && response['data'] != null) {
            final allTasks = response['data'] as List<dynamic>;
            final pending =
                allTasks.where((t) {
                  final isC =
                      t['is_completed'] == 1 ||
                      t['is_completed'] == true ||
                      t['is_completed'] == "1";
                  return !isC;
                }).toList();
            final completed =
                allTasks.where((t) {
                  final isC =
                      t['is_completed'] == 1 ||
                      t['is_completed'] == true ||
                      t['is_completed'] == "1";
                  return isC;
                }).toList();

            _tasks = [...pending, ...completed.reversed];
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56 * res.scale,
        leadingWidth: (res.isTablet ? 100 : 70) * res.scale,
        leading: Container(
          margin: EdgeInsets.only(left: (res.isTablet ? 20 : 12) * res.scale),
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: const Color(0xFF0E1A34),
              size: 20 * res.scale,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const NavigationMenu()),
                (route) => false,
              );
            },
          ),
        ),
        title: Text(
          'Tasks',
          style: TextStyle(
            color: const Color(0xFF0E1A34),
            fontWeight: FontWeight.w600,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 10 * res.scale),
          Divider(
            height: 1,
            thickness: .5,
            color: const Color(0xFFD5D5D5),
            indent: 40 * res.scale,
            endIndent: 40 * res.scale,
          ),
          Expanded(
            child:
                _isLoading
                    ? HomeShimmer.buildTaskShimmerList(res.scale)
                    : _tasks.isEmpty
                    ? Center(
                      child: Text(
                        "No tasks available",
                        style: TextStyle(
                          fontSize: 16 * res.scale,
                          color: const Color(0xFF939393),
                        ),
                      ),
                    )
                    : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: (res.isTablet ? 24 : 20) * res.scale,
                        vertical: 25 * res.scale,
                      ),
                      itemCount: _tasks.length,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 16 * res.scale),
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        final title = task['title']?.toString() ?? '';
                        final subtitle = task['description']?.toString() ?? '';
                        final dueDate = task['Due_date']?.toString() ?? '';
                        final isCompleted =
                            task['is_completed'] == 1 ||
                            task['is_completed'] == true ||
                            task['is_completed'] == "1";
                        final doctorName =
                            task['visit']?['doctor_name']?.toString() ?? '';
                        final taskId =
                            task['id'] is int
                                ? task['id'] as int
                                : int.tryParse(task['id']?.toString() ?? '') ??
                                    0;

                        return _buildTaskCard(
                          context,
                          res.scale,
                          title: title,
                          subtitle: subtitle,
                          dueDate: dueDate,
                          isCompleted: isCompleted,
                          doctorName: doctorName,
                          destination: TaskDetailsScreen(taskId: taskId),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    double scale, {
    required String title,
    required String subtitle,
    required String dueDate,
    required bool isCompleted,
    required String doctorName,
    required Widget destination,
  }) {
    final bool isOverdue = TaskHelper.isOverdue(dueDate);
    final Color statusColor = TaskHelper.getStatusColor(
      isCompleted: isCompleted,
      isOverdue: isOverdue,
    );
    final decoration = TaskHelper.getDeadlineDecoration(
      isCompleted: isCompleted,
      isOverdue: isOverdue,
      scale: scale,
    );
    final padding = TaskHelper.getDeadlinePadding(
      isCompleted: isCompleted,
      isOverdue: isOverdue,
      scale: scale,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.0 * scale,
        ),
        borderRadius: BorderRadius.circular(14 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14 * scale),
          onTap: () async {
            final result = await Navigator.of(
              context,
              rootNavigator: true,
            ).push(
              MaterialPageRoute(builder: (context) => destination),
            );
            if (result == true && mounted) {
              _fetchTasks();
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.0 * scale),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color:
                          isCompleted
                              ? Colors.green
                              : const Color(0xFFCBD5E1),
                      size: 20 * scale,
                    ),
                    SizedBox(width: 10 * scale),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 13 * scale,
                              fontWeight: FontWeight.bold,
                              color:
                                  isCompleted
                                      ? Colors.grey.withOpacity(0.7)
                                      : const Color(0xFF0E1A34),
                              decoration:
                                  isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),
                          if (subtitle.isNotEmpty) ...[
                            SizedBox(height: 4 * scale),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: const Color(0xFF939393),
                                fontSize: 11 * scale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 2 * scale),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * scale,
                        vertical: 4 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.grey.shade100 : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Dr. ",
                            style: TextStyle(
                              color: isCompleted ? const Color(0xFF939393) : const Color(0xFF2563EB),
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            doctorName,
                            style: TextStyle(
                              color: isCompleted ? const Color(0xFF939393) : const Color(0xFF2563EB),
                              fontSize: 11 * scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: padding,
                      decoration: decoration,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/Icons/clock.svg',
                            width: 13 * scale,
                            colorFilter: ColorFilter.mode(
                              statusColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 4 * scale),
                          Text(
                            dueDate,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11 * scale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
