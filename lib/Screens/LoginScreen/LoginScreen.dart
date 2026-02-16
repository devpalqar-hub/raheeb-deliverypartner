import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/Service/LoginController.dart';


class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [

              SizedBox(height: 80.h),

              Icon(Icons.local_shipping,
                  size: 60.sp,
                  color: const Color(0xff2F80ED)),

              SizedBox(height: 40.h),

              /// EMAIL
              TextField(
                controller: auth.emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              /// PASSWORD
              TextField(
                controller: auth.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              /// LOGIN BUTTON
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed:
                          auth.isLoading.value ? null : auth.login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff2F80ED),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14.r),
                        ),
                      ),
                      child: auth.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}