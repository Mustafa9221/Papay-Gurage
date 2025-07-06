import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papay/Presentation/home_screen/homeScreen.dart';
import 'package:papay/Presentation/widgets/messageshower.dart';
import 'dart:async';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final int otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  bool _isVerifying = false;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(otpLength, (_) => FocusNode());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _clearOtpFields() {
  for (final controller in _controllers) {
    controller.clear();
  }
  // Optionally refocus to first field after clearing
  FocusScope.of(context).requestFocus(_focusNodes[0]);
}


  void _startTimer() {
    setState(() {
      _isVerifying = true;
      _remainingSeconds = 120;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();

        setState(() {
          _isVerifying = false;
        });
        _clearOtpFields();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _onSubmit() async {
    if (_isVerifying) return;

    final smsCode = _controllers.map((c) => c.text).join();

    if (smsCode.length != otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code')),
      );
      return;
    }

    setState(() => _isVerifying = true);

    final isSuccess = null;//await FirebaseAuthServices().signInWithOTP(smsCode);

    if (isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      showCustomSnackBar(context, "Invalid OTP");
      _startTimer(); // Start timer only if failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'An authentication code has been sent to +974 ${widget.phoneNumber}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "+974 ${widget.phoneNumber}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.deepOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(otpLength, (index) {
                return Container(
                  margin: EdgeInsets.only(right: index < otpLength - 1 ? 12 : 0),
                  width: 40,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index + 1 < otpLength) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      }
                      if (value.isEmpty && index > 0) {
                        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      }
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 128, 230, 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isVerifying && _remainingSeconds > 0
                    ? Text(
                        '$_remainingSeconds s',
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
