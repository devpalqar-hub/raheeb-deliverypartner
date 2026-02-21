import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/Service/LoginController.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final auth = Get.find<AuthController>();

  final RxBool obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F9),

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                /// COMPANY LOGO
                Container(
                  height: 92.h,
                  width: 92.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Image.asset(
                      "assets/image.png", // ✅ change to your asset path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                /// TITLE
                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff111827),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Login to your Raheeb admin account",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),

                SizedBox(height: 32.h),

                /// LOGIN CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// EMAIL LABEL
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff374151),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      /// EMAIL FIELD
                      TextField(
                        controller: auth.emailController,
                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(
                          hintText: "Enter your email",

                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 14.w,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(
                              color: Color(0xff2F80ED),
                              width: 1.4,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// PASSWORD LABEL
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff374151),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      /// PASSWORD FIELD
                      Obx(
                        () => TextField(
                          controller: auth.passwordController,
                          obscureText: obscurePassword.value,

                          decoration: InputDecoration(
                            hintText: "Enter your password",

                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.h,
                              horizontal: 14.w,
                            ),

                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                obscurePassword.value = !obscurePassword.value;
                              },
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(
                                color: Color(0xffE5E7EB),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(
                                color: Color(0xff2F80ED),
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      /// FORGOT PASSWORD
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     child: Text(
                      //       "Forgot password?",
                      //       style: TextStyle(
                      //         fontSize: 13.sp,
                      //         fontWeight: FontWeight.w500,
                      //         color: const Color(0xff2F80ED),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // SizedBox(height: 12.h),

                      /// LOGIN BUTTON
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 48.h,

                          child: ElevatedButton(
                            onPressed: auth.isLoading.value ? null : auth.login,

                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xff2F80ED),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),

                            child: auth.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                /// FOOTER
                Text(
                  "© Raheeb Delivery Partner",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
