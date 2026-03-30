import 'package:application/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Privacy & Policy',
          style: TextStyle(
            color: const Color(0xFF0E1A34),
            fontWeight: FontWeight.w600,
            fontSize: 18 * res.scale,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25 * res.scale,
            vertical: 20 * res.scale,
          ),
          child: Column(
            children: [
              Divider(
                height: 1 * res.scale,
                thickness: 1 * res.scale,
                color: const Color(0xFFD5D5D5),
              ),

              SizedBox(height: 30 * res.scale),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24 * res.scale),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24 * res.scale),
                  border: Border.all(
                    color: const Color(0xFFEAEAEA),
                    width: 2 * res.scale,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Policy',
                      style: TextStyle(
                        fontSize: 18 * res.scale,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0E1A34),
                      ),
                    ),
                    SizedBox(height: 8 * res.scale),
                    Text(
                      'Your data is encrypted and stored securely. We do not share your personal medical records with third parties without your explicit consent.',
                      style: TextStyle(
                        fontSize: 13 * res.scale,
                        color: const Color(0xFF0E1A34),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 35 * res.scale),

                    Text(
                      'Access Log',
                      style: TextStyle(
                        fontSize: 15 * res.scale,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0E1A34),
                      ),
                    ),
                    SizedBox(height: 10 * res.scale),
                    Text(
                      'Last access: Today, 10:00 AM, near Cairo, Egypt.',
                      style: TextStyle(
                        fontSize: 13 * res.scale,
                        color: const Color(0xFF0E1A34),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
