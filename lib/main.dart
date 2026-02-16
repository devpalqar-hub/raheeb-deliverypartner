import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/Service/LoginController.dart';



void main() {
  runApp(const RaheebDelivery());
}

class RaheebDelivery extends StatelessWidget {
  const RaheebDelivery({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Get.put(AuthController());

    return ScreenUtilInit(
      designSize: const Size(400, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {

        return FutureBuilder(
          future: auth.checkLogin(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: snapshot.data as Widget,
            );
          },
        );
      },
    );
  }
}