import 'package:flutter/material.dart';

class CustomProfileButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomProfileButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  CustomProfileButtonState createState() => CustomProfileButtonState();
}

class CustomProfileButtonState extends State<CustomProfileButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHighlightChanged: (isHighlighted) {
        setState(() {
          _isPressed = isHighlighted;
        });
      },
      //splashColor: Colors.grey.withOpacity(0.3), // Tap effect
      child: Container(
        width: 144, // Square size (adjust as needed)
        height: 50, // Rectangular for better text fit
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey : Colors.black, // Grey when pressed, black otherwise
          borderRadius: BorderRadius.circular(5.0), // Square, no rounded corners
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: Colors.white,
            ),
            const SizedBox(width: 8), // Space between icon and text
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage:
/*
Widget profileButton() {
  return CustomProfileButton(
    text: 'Profile image',
    icon: Icons.beach_access,
    onPressed: () {
      // Define your on-press action here
      print('Button pressed!');
    },
  );
}
*/