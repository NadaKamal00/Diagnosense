import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
}
