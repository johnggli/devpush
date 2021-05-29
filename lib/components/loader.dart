import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        ),
        SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              // strokeWidth: 5,
            ),
          ),
        )
      ],
    );
  }
}
