import 'package:barbee_hive_app/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:barbee_hive_app/infrastructure/widgets/cutom_bottom_nav_bar.dart'; // Check spelling: "cutom" -> maybe should be "custom"?

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    DashboardScreen(),
    Center(child: Text("Location Screen", style: TextStyle(color: Colors.white))),
    Center(child: Text("Menu Screen", style: TextStyle(color: Colors.white))),
    Center(child: Text("Bakery Screen", style: TextStyle(color: Colors.white))),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: screens[selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
