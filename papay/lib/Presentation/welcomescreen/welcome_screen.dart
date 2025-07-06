import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papay/Presentation/optscreen/opt_screen.dart';
import 'package:papay/Presentation/theme/colors.dart';
import 'package:papay/Presentation/widgets/messageshower.dart';

class WelcomeMobile extends StatefulWidget {
  const WelcomeMobile({Key? key}) : super(key: key);

  @override
  State<WelcomeMobile> createState() => _WelcomeMobileState();
}

class _WelcomeMobileState extends State<WelcomeMobile> {
  final TextEditingController _phoneController = TextEditingController();
  String? messageBuffer;
  bool _isLoading = false;

  void _onContinue() async {
    HapticFeedback.mediumImpact();
    final phonenoLen = _phoneController.text.length;

    if (phonenoLen != 8) {
      setState(() {
        messageBuffer = "PhoneNo Should Be 8 Digits";
      });
      return;
    }

    setState(() {
      messageBuffer = null;
      _isLoading = true;
    });

    try {
      final success = true;
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationScreen(phoneNumber: _phoneController.text),
          ),
        );
      } else {
        showCustomSnackBar(context, "Please Enter a Valid Number", isError: true);
      }
    } catch (e) {
      showCustomSnackBar(context, "Error sending OTP: $e", isError: true);
    } 
  }

  void _onPrivacyAgreements() {
    HapticFeedback.lightImpact();
    print('Privacy and agreements tapped');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              // Welcome Text
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your phone number to get started.',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 60),

              // Country Selector
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  children: const [
                    Text('🇶🇦', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Qatar (+974)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Phone Number Input
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Color(0xFFE5E7EB)),
                    right: BorderSide(color: Color(0xFFE5E7EB)),
                    bottom: BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: TextField(
                  controller: _phoneController,
                  maxLength: 8,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    errorText: messageBuffer,
                    counterText: "",
                    hintText: 'Phone number',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Privacy Link
              Center(
                child: GestureDetector(
                  onTap: _onPrivacyAgreements,
                  child: const Text(
                    'Privacy and agreements',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Continue Button
              Container(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Material(
                    color: const Color.fromARGB(255, 111, 199, 3),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _isLoading ? null : _onContinue,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Send OPT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
