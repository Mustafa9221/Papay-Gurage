import 'package:flutter/material.dart';

class OtpInputBox extends StatelessWidget {
  final String value;
  final bool isActive;

  const OtpInputBox({
    Key? key,
    required this.value,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: value.isNotEmpty
            ? Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              )
            : isActive
                ? Container(
                    width: 2,
                    height: 24,
                    color: const Color(0xFFFF6B35),
                  )
                : null,
      ),
    );
  }
}
