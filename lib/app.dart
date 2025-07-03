import 'package:flutter/material.dart';
import 'screens/common/login_type_screen.dart';
import 'screens/driver/home/driver_home_screen.dart';
import 'screens/driver/profile/driver_profile_screen.dart';
import 'screens/driver/connect/driver_connect_screen.dart';
import 'screens/driver/post/driver_add_post_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truck App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginTypeScreen(),
        '/driver/home': (context) => const DriverHomeScreen(),
        '/driver/profile': (context) => const DriverProfileScreen(),
        '/driver/connect': (context) => const DriverConnectScreen(),
        '/driver/post': (context) => const DriverAddPostScreen(),
      },
    );
  }
}
