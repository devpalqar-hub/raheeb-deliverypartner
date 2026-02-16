import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:raheeb_deliverypartner/Screens/HomeScreen/home_screen.dart';



void main() {
  runApp(const RaheebDelivery(initialHome: HomeScreen()));
}

class RaheebDelivery extends StatelessWidget {
   final Widget initialHome;
  const RaheebDelivery({super.key,required this.initialHome});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:  Size(400, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: initialHome,
      ),
    );
    
  }
}
