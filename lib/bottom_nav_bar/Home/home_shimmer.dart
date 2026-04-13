import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/responsive_helper.dart';

class HomeShimmer {
  static Widget buildFullHomeShimmer(BuildContext context, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeaderShimmer(context, scale),
        SizedBox(height: 22 * scale),
        buildUpcomingTasksShimmer(scale),
        SizedBox(height: 25 * scale),
        buildNextVisitShimmer(scale),
        SizedBox(height: 30 * scale),
        buildMedicalFilesShimmer(scale),
        SizedBox(height: 30 * scale),
      ],
    );
  }

  static Widget buildHeaderShimmer(BuildContext context, double scale) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 140 * scale,
                height: 18 * scale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
              ),
              SizedBox(height: 8 * scale),
              Container(
                width: 90 * scale,
                height: 14 * scale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
              ),
            ],
          ),
          Container(
            width: 24 * scale,
            height: 24 * scale,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildUpcomingTasksShimmer(double scale) {
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
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120 * scale,
                  height: 18 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4 * scale),
                  ),
                ),
                Container(
                  width: 60 * scale,
                  height: 14 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4 * scale),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12 * scale),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(3, (index) {
                  return Container(
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16 * scale),
                      border: Border.all(
                        color: Colors.white,
                        width: 1 * scale,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48 * scale,
                          height: 48 * scale,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 16 * scale),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16 * scale,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4 * scale),
                                ),
                              ),
                              SizedBox(height: 8 * scale),
                              Container(
                                width: 80 * scale,
                                height: 12 * scale,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4 * scale),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildNextVisitShimmer(double scale) {
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
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80 * scale,
              height: 18 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4 * scale),
              ),
            ),
            SizedBox(height: 8 * scale),
            Container(
              width: 180 * scale,
              height: 20 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4 * scale),
              ),
            ),
            SizedBox(height: 4 * scale),
            Container(
              width: 100 * scale,
              height: 12 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4 * scale),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40 * scale,
                        height: 12 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                      SizedBox(height: 4 * scale),
                      Container(
                        width: 80 * scale,
                        height: 14 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40 * scale,
                        height: 12 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                      SizedBox(height: 4 * scale),
                      Container(
                        width: 60 * scale,
                        height: 14 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
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

  static Widget buildMedicalFilesShimmer(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 120 * scale,
            height: 18 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4 * scale),
            ),
          ),
        ),
        SizedBox(height: 15 * scale),
        Row(
          children: [
            Expanded(child: buildMedicalItemShimmer(scale)),
            SizedBox(width: 12 * scale),
            Expanded(child: buildMedicalItemShimmer(scale)),
            SizedBox(width: 12 * scale),
            Expanded(child: buildMedicalItemShimmer(scale)),
          ],
        ),
        SizedBox(height: 15 * scale),
        Container(
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
                color: const Color(0xFFC9C9C9).withOpacity(0.25),
                blurRadius: 7.9 * scale,
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Center(
              child: Container(
                width: 140 * scale,
                height: 14 * scale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildMedicalItemShimmer(double scale) {
    return Container(
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
            color: const Color(0xFFC9C9C9).withOpacity(0.25),
            blurRadius: 7.9 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44 * scale,
              height: 44 * scale,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 10 * scale),
            Container(
              width: 60 * scale,
              height: 12 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4 * scale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTaskCardShimmer(double scale) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0 * scale),
        borderRadius: BorderRadius.circular(14 * scale),
      ),
      padding: EdgeInsets.all(16.0 * scale),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 20 * scale,
                  height: 20 * scale,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10 * scale),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120 * scale,
                      height: 12 * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Container(
                      width: 80 * scale,
                      height: 10 * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4 * scale),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 15 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70 * scale,
                  height: 20 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10 * scale),
                  ),
                ),
                Container(
                  width: 60 * scale,
                  height: 20 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10 * scale),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget buildTaskShimmerList(double scale) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (context, index) => SizedBox(height: 16 * scale),
      itemBuilder: (context, index) => buildTaskCardShimmer(scale),
    );
  }

  static Widget buildBadgeShimmer({required double scale}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10 * scale,
          vertical: 6 * scale,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6 * scale),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18 * scale,
              height: 18 * scale,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6 * scale),
            Container(
              width: 60 * scale,
              height: 11 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2 * scale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildButtonShimmer({required double scale}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 52 * scale,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12 * scale),
        ),
      ),
    );
  }

  static Widget buildTaskDetailsShimmer({required double scale}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Divider
        Center(
          child: Container(
            width: 300 * scale,
            height: 0.5 * scale,
            color: const Color(0xFFD5D5D5),
          ),
        ),
        SizedBox(height: 24 * scale),

        // Main Task Card Shimmer
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14 * scale),
            border: Border.all(
              color: const Color(0xFFCDCDCD),
              width: 0.5 * scale,
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100 * scale,
                      height: 24 * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6 * scale),
                      ),
                    ),
                    Container(
                      width: 28 * scale,
                      height: 28 * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6 * scale),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16 * scale),
                Container(
                  width: 200 * scale,
                  height: 20 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4 * scale),
                  ),
                ),
                SizedBox(height: 16 * scale),
                Container(
                  width: 60 * scale,
                  height: 12 * scale,
                  color: Colors.white,
                ),
                SizedBox(height: 6 * scale),
                Container(
                  width: 120 * scale,
                  height: 16 * scale,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16 * scale),
                  child: Divider(
                    color: Colors.white,
                    thickness: 0.5 * scale,
                  ),
                ),
                Container(
                  width: 80 * scale,
                  height: 12 * scale,
                  color: Colors.white,
                ),
                SizedBox(height: 8 * scale),
                Container(
                  width: double.infinity,
                  height: 12 * scale,
                  color: Colors.white,
                ),
                SizedBox(height: 4 * scale),
                Container(
                  width: double.infinity,
                  height: 12 * scale,
                  color: Colors.white,
                ),
                SizedBox(height: 4 * scale),
                Container(
                  width: 150 * scale,
                  height: 12 * scale,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24 * scale),

        // Instructions Card Shimmer
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(22 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14 * scale),
            border: Border.all(
              color: Colors.black.withOpacity(0.05),
              width: 1 * scale,
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140 * scale,
                  height: 16 * scale,
                  color: Colors.white,
                ),
                SizedBox(height: 16 * scale),
                Container(
                  width: double.infinity,
                  height: 60 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6 * scale),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildMedicationCardShimmer({required double scale, bool isTablet = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: (isTablet ? 10 : 12) * scale),
      padding: EdgeInsets.symmetric(
        horizontal: (isTablet ? 14 : 16) * scale,
        vertical: (isTablet ? 12 : 16) * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(
          color: const Color(0xFFCDCDCD).withOpacity(0.5),
          width: 0.5 * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8 * scale,
            offset: Offset(0, 3 * scale),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50 * scale,
                  height: 37 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6 * scale),
                  ),
                ),
                SizedBox(width: 12 * scale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140 * scale,
                        height: (isTablet ? 13 : 15) * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                      SizedBox(height: 4 * scale),
                      Container(
                        width: 80 * scale,
                        height: (isTablet ? 11 : 12) * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: (isTablet ? 30 : 36) * scale,
                  height: (isTablet ? 24 : 28) * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6 * scale),
                  ),
                ),
              ],
            ),
            SizedBox(height: (isTablet ? 12 : 15) * scale),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: (isTablet ? 8 : 10) * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * scale),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 0.5 * scale,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30 * scale,
                    height: (isTablet ? 10 : 12) * scale,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8 * scale),
                  Expanded(
                    child: Container(
                      height: (isTablet ? 10 : 12) * scale,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8 * scale),
                  Container(
                    width: 60 * scale,
                    height: (isTablet ? 10 : 11) * scale,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildMedicationListShimmer({required double scale, int count = 4, bool isTablet = false}) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: (isTablet ? 24 : 20) * scale,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) => buildMedicationCardShimmer(scale: scale, isTablet: isTablet),
    );
  }

  static Widget buildYearHeaderShimmer({required double scale, required bool isTablet}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: (isTablet ? 10 : 15) * scale),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            SizedBox(width: (isTablet ? 55 : 66) * scale),
            Container(
              width: 48 * scale,
              height: 22 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * scale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTimelineItemShimmer({required int index, required int totalItems, required double scale, required bool isTablet}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left Section (Day & Month)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: SizedBox(
              width: 40 * scale,
              child: Column(
                children: [
                  Container(
                    width: 24 * scale,
                    height: 16 * scale,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4 * scale)),
                  ),
                  SizedBox(height: 4 * scale),
                  Container(
                    width: 30 * scale,
                    height: 12 * scale,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4 * scale)),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12 * scale),

          /// Middle Section (Line & Dot)
          Column(
            children: [
              Container(
                width: 2 * scale,
                height: 12 * scale,
                color: index == 0 ? Colors.transparent : const Color(0xFFE5E7EB),
              ),
              Container(
                width: 11 * scale,
                height: 11 * scale,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E7EB),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2 * scale,
                  color: index == totalItems - 1 ? Colors.transparent : const Color(0xFFE5E7EB),
                ),
              ),
            ],
          ),

          SizedBox(width: 16 * scale),

          /// Right Section (Card)
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 24 * scale),
              padding: EdgeInsets.all(16 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14 * scale),
                border: Border.all(
                  color: const Color(0xFFCDCDCD),
                  width: .5 * scale,
                ),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50 * scale,
                          height: 20 * scale,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6 * scale)),
                        ),
                        Container(
                          width: 40 * scale,
                          height: 14 * scale,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4 * scale)),
                        ),
                      ],
                    ),
                    SizedBox(height: 12 * scale),
                    Container(
                      width: 150 * scale,
                      height: 13 * scale,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4 * scale)),
                    ),
                    SizedBox(height: 4 * scale),
                    Container(
                      width: 100 * scale,
                      height: 12 * scale,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4 * scale)),
                    ),
                    SizedBox(height: 12 * scale),
                    Container(
                      width: double.infinity,
                      height: 40 * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6 * scale),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTimelineListShimmer({required double scale, required bool isTablet, int count = 5}) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 20 * scale,
        vertical: (isTablet ? 15 : 20) * scale,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == 0) buildYearHeaderShimmer(scale: scale, isTablet: isTablet),
            buildTimelineItemShimmer(
              index: index,
              totalItems: count,
              scale: scale,
              isTablet: isTablet,
            ),
          ],
        );
      },
    );
  }

  static Widget buildProfileShimmer({required double scale, required bool isTablet}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 * scale : 18 * scale,
        vertical: isTablet ? 24 * scale : 18 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            SizedBox(width: 15 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140 * scale,
                    height: 16 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                  SizedBox(height: 8 * scale),
                  Container(
                    width: 180 * scale,
                    height: 12 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 16 * scale,
              height: 16 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4 * scale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildProfileRowShimmer(Responsive res) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (16 * res.scale).toDouble(),
        vertical: (16 * res.scale).toDouble(),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: (42 * res.scale).toDouble(),
              height: (42 * res.scale).toDouble(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular((12 * res.scale).toDouble()),
              ),
            ),
            SizedBox(width: (16 * res.scale).toDouble()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: (60 * res.scale).toDouble(),
                    height: (10 * res.scale).toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular((2 * res.scale).toDouble()),
                    ),
                  ),
                  SizedBox(height: (8 * res.scale).toDouble()),
                  Container(
                    width: (150 * res.scale).toDouble(),
                    height: (16 * res.scale).toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular((4 * res.scale).toDouble()),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: (14 * res.scale).toDouble(),
              height: (14 * res.scale).toDouble(),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildProfileShimmerList(Responsive res, {int count = 3}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((20 * res.scale).toDouble()),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: (20 * res.scale).toDouble(),
            offset: Offset(0, (10 * res.scale).toDouble()),
          ),
        ],
      ),
      child: Column(
        children: List.generate(count, (index) {
          return Column(
            children: [
              buildProfileRowShimmer(res),
              if (index < count - 1)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (16 * res.scale).toDouble(),
                  ),
                  child: Divider(
                    height: 1,
                    thickness: (0.8 * res.scale).toDouble(),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  static Widget buildLabCardShimmer({required double scale}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15 * scale),
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(
          color: const Color(0xFFCDCDCD),
          width: .5 * scale,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 46 * scale,
              height: 46 * scale,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 15 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140 * scale,
                    height: 13 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                  SizedBox(height: 8 * scale),
                  Container(
                    width: 100 * scale,
                    height: 12 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10 * scale),
            Container(
              width: 50 * scale,
              height: 34 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * scale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildLabListShimmer({required double scale, int count = 4}) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => buildLabCardShimmer(scale: scale),
    );
  }

  static Widget buildRadiologyCardShimmer({required double scale}) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(
          color: const Color(0xFFCDCDCD),
          width: .5 * scale,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44 * scale,
              height: 40 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8 * scale),
              ),
            ),
            SizedBox(width: 14 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50 * scale,
                        height: 20 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6 * scale),
                        ),
                      ),
                      Container(
                        width: 40 * scale,
                        height: 11 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8 * scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150 * scale,
                        height: 13 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                      Container(
                        width: 30 * scale,
                        height: 12 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4 * scale),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8 * scale),
                  Container(
                    width: 100 * scale,
                    height: 11 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4 * scale),
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

  static Widget buildRadiologyListShimmer({required double scale, int count = 4}) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16 * scale),
        child: buildRadiologyCardShimmer(scale: scale),
      ),
    );
  }

  static Widget buildHistoryCardShimmer({required double scale}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15 * scale),
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(
          color: const Color(0xFFCDCDCD),
          width: .5 * scale,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 50 * scale,
              height: 37 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6 * scale),
              ),
            ),
            SizedBox(width: 15 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140 * scale,
                    height: 13 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                  SizedBox(height: 8 * scale),
                  Container(
                    width: 100 * scale,
                    height: 12 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22 * scale,
              height: 22 * scale,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildHistoryListShimmer({required double scale, int count = 4}) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => buildHistoryCardShimmer(scale: scale),
    );
  }
}
