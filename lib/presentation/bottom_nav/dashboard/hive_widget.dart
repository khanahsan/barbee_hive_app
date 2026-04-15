import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'controller/dashboardController.dart';

class HiveSection extends StatelessWidget {
  const HiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of items based on the screenshot

    final DashboardController controller = Get.find<DashboardController>();
    final employees = controller.employees;

    final List<Map<String, dynamic>> hiveItems = [
      {'name': 'SARAH', 'distance': '6 Mi'},
      {'name': 'RACHEL', 'distance': '0 Mi'},
      {'name': 'TINA', 'distance': '6 Mi'},
      {'name': 'JANIFER', 'distance': '6 Mi'},
      {'name': 'MARIO', 'distance': '6 Mi'},
      {'name': 'ELINA', 'distance': '6 Mi'},
      {'name': 'VICKY', 'distance': '6 Mi'},
      {'name': 'ALEX', 'distance': '6 Mi'},
      // {'name': 'TINA', 'distance': '6 Mi'},
      // {'name': 'ADAM', 'distance': '6 Mi'},
      // {'name': 'MARIA', 'distance': '6 Mi'},
      // {'name': 'KEN', 'distance': '6 Mi'},
      // {'name': 'JULIYA', 'distance': '6 Mi'},
      // {'name': 'JOSEPH', 'distance': '6 Mi'},
      // {'name': 'SARAH', 'distance': '6 Mi'},
      // {'name': 'RACHEL', 'distance': '0 Mi'},
      // {'name': 'TINA', 'distance': '6 Mi'},
      // {'name': 'JANIFER', 'distance': '6 Mi'},
      // {'name': 'MARIO', 'distance': '6 Mi'},
      // {'name': 'ELINA', 'distance': '6 Mi'},
      // {'name': 'VICKY', 'distance': '6 Mi'},
      // {'name': 'ALEX', 'distance': '6 Mi'},
      // {'name': 'TINA', 'distance': '6 Mi'},
      // {'name': 'ADAM', 'distance': '6 Mi'},
      // {'name': 'MARIA', 'distance': '6 Mi'},
      // {'name': 'KEN', 'distance': '6 Mi'},
      // {'name': 'JULIYA', 'distance': '6 Mi'},
      // {'name': 'JOSEPH', 'distance': '6 Mi'},
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 4, // Base grid is 4 columns wide
          mainAxisSpacing: 5,
          crossAxisSpacing: 2,
          children:
              hiveItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                // Calculate row index for 4-3-4-3 pattern
                // Every 7 items (4 + 3), the pattern repeats
                final cycleIndex = index % 7; // Position within a 4-3 cycle
                final cycle = (index ~/ 7); // Which cycle (0-based)
                final rowIndex = cycle * 2 + (cycleIndex < 4 ? 0 : 1); // 4 items in even rows, 3 in odd

                // Determine tile size: 4 items in even rows, 3 items in odd rows
                final int crossAxisCellCount = (rowIndex % 2 == 0) ? 1 : (4 ~/ 3);

                // Calculate offsets for honeycomb overlap
                final double xOffset = (rowIndex % 2 == 1) ? 47.0 : 0.0; // Shift odd rows left
                final double yOffset = rowIndex > 0 ? -25.0 : 0.0; // Shift all but first row up

                return StaggeredGridTile.count(
                  crossAxisCellCount: crossAxisCellCount,
                  mainAxisCellCount: 1,
                  child: Transform.translate(
                    offset: Offset(xOffset, yOffset),
                    child: HexagonalTile(
                      name: employees[index].employee!.name,
                      distance: employees[index].employee!.toString(),
                      imageUrl: 'https://picsum.photos/200',
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

class HexagonalTile extends StatelessWidget {
  final String name;
  final String distance;
  final String imageUrl;

  const HexagonalTile({super.key, required this.name, required this.distance, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HexagonClipper(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Text overlay
          Container(
            color: Colors.white, // Semi-transparent black overlay
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(distance, style: const TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final hexHeight = height * 0.25;

    path.moveTo(width * 0.5, 0); // Top center
    path.lineTo(width, hexHeight); // Top right
    path.lineTo(width, height - hexHeight); // Bottom right
    path.lineTo(width * 0.5, height); // Bottom center
    path.lineTo(0, height - hexHeight); // Bottom left
    path.lineTo(0, hexHeight); // Top left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
