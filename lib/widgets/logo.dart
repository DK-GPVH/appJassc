import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: MediaQuery.of(context).size.width * 0.38,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.blue.shade800,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.white)]),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'JASSC',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class LogoHeaderAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: MediaQuery.of(context).size.width * 0.38,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.yellow.shade800,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.white)]),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'JASSC|ADMIN',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
