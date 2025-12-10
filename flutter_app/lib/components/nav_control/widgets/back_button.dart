import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 13, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
            size: 18,
          ),
        ),
      ),
    );
  }
}
