import 'package:flutter/material.dart';

class WaveContainer extends StatelessWidget {
  const WaveContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Set your desired background color here
      child: ClipPath(
        clipper: WaveClipper(),
        child: Container(
          color: Colors.white, // Set the color of the wave section here
          height: 200, // Adjust the height as per your requirement
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // Adjust the height of the wave curve
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    final secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 85);
    final secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
