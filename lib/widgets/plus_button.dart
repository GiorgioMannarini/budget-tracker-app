import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final Function onPressed;
  const PlusButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {onPressed();},
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}