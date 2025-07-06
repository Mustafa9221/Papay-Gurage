import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- import this for inputFormatters
import 'package:papay/Bussiness/mongoDB/mongoDBService.dart';
import 'package:papay/Presentation/confirmation_page/confirmation_screen.dart';
import 'package:papay/Presentation/theme/colors.dart';
import 'package:papay/Presentation/widgets/flutter_map.dart';
import 'package:papay/Presentation/widgets/messageshower.dart';

class RequestRepairPage extends StatefulWidget {
  const RequestRepairPage({super.key});

  @override
  State<RequestRepairPage> createState() => _RequestRepairPageState();
}

class _RequestRepairPageState extends State<RequestRepairPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qidController = TextEditingController();
  final _plateController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _problemController = TextEditingController();
  final _vechileController= TextEditingController();
  String? trackingId;

  bool _registering = false;

  bool pickupRequired = false;
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF191A23),
      appBar: AppBar(
        title: const Text("Request Repair"),
        backgroundColor: const Color(0xFF191A23),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 80, vertical: 30),
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Fill Repair Form", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildTextField("Full Name", controller: _nameController, validator: _requiredValidator),
                  _buildTextField(
                    "Phone Number",
                    controller: _phoneController,
                    validator: _phoneValidator,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // restrict digits only
                  ),
                  _buildTextField(
                    "QID",
                    controller: _qidController,
                    validator: _qidValidator,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // restrict digits only
                  ),
                   _buildTextField("Vehicle", controller: _vechileController, validator: _requiredValidator),
                  _buildTextField("Vehicle Plate Number", controller: _plateController, validator: _plateValidator),
                  _buildTextField("Vehicle Model", controller: _modelController, validator: _requiredValidator),
                  _buildTextField("Color", controller: _colorController, validator: _requiredValidator),
                  _buildTextField("Problem Description", controller: _problemController, validator: _requiredValidator, maxLines: 5),
                  const SizedBox(height: 20),

                  const Text("Select Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectLocation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedLocation ?? "Tap to select location",
                              style: TextStyle(fontSize: 16, color: selectedLocation == null ? Colors.grey : Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.location_on, color: Color(0xFF191A23)),
                        ],
                      ),
                    ),
                  ),
                  if (selectedLocation == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text("Location is required", style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Pickup Required?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Switch(
                        value: pickupRequired,
                        activeColor: const Color(0xFFB9FF66),
                        onChanged: (value) {
                          setState(() {
                            pickupRequired = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB9FF66),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _registering ? null : _onSubmit,
                      child: _registering
                          ? const CircularProgressIndicator()
                          : const Text("Submit Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    if (value.length != 8) return 'Phone number must be 8 digits';
    if (!RegExp(r'^\d{8}$').hasMatch(value)) return 'Invalid phone number';
    return null;
  }

  String? _qidValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'QID is required';
    if (value.length != 11) return 'QID must be 11 digits';
    if (!RegExp(r'^\d{11}$').hasMatch(value)) return 'Invalid QID';
    return null;
  }

  String? _plateValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Plate number is required';
    if (value.length > 6) return 'Plate number must be max 6 characters';
    return null;
  }

  void _selectLocation() async {
    final value = await Navigator.push(context, MaterialPageRoute(builder: (context) => const WebLocationPicker()));
    setState(() {
      selectedLocation = value.toString();
    });
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate() && selectedLocation != null) {
      setState(() {
        _registering = true;
      });

      try {
        // Simulate API call
        await requestForRepair();
      } catch (e) {
        // handle errors if needed
      } finally {
        setState(() {
          _registering = false;
        });
      }
    } else {
      if (selectedLocation == null) {
        setState(() {}); // Refresh UI to show location error
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _qidController.dispose();
    _plateController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _problemController.dispose();
    _vechileController.dispose();
    super.dispose();
  }
  
  requestForRepair(){
    MongoDbServices().addRepairRequest(name: _nameController.text, phoneNo: _phoneController.text, qid: _qidController.text,
     vechile: _vechileController.text,vecPlateNo: _plateController.text, vecModel: _modelController.text, color: _colorController.text, description: _problemController.text,
    location: selectedLocation!, pickup: pickupRequired).then((response){
    if(response[0]){
      showCustomSnackBar(context, response[1]);
      trackingId=response[2];
      visitConfirmationScreen();
    }else{
      showCustomSnackBar(context, response[1]);
    }
    return response[0];
    });
  }
  
  // void _clearInputFields() {
  //   _nameController.clear();
  //   _phoneController.clear();
  //   _qidController.clear();
  //   _plateController.clear();
  //   _modelController.clear();
  //   _colorController.clear();
  //   _problemController.clear();
  //   _vechileController.clear();
  // }

  visitConfirmationScreen(){
    final confirmPage = ConfirmationScreen(trackingId: trackingId!,name: _nameController.text, phoneno: _phoneController.text, qid: _qidController.text,
     vechile: _vechileController.text,vecPlateNo: _plateController.text, vehicleModel: _modelController.text, color: _colorController.text, description: _problemController.text,
    location: selectedLocation!, pickup: pickupRequired);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> confirmPage));
  }
}
