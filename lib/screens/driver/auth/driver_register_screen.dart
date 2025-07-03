import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import '../../../blocs/driver/driver_bloc.dart';
import '../../../blocs/driver/driver_event.dart';
import '../../../blocs/driver/driver_state.dart';
import '../../../models/driver_registration_model.dart';

class DriverRegisterScreen extends StatefulWidget {
  final String verificationToken;

  const DriverRegisterScreen({super.key, required this.verificationToken});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final capacityController = TextEditingController();

  // Dropdown values
  String? selectedVehicleType;
  String? selectedBodyType;

  // File IDs
  String? profilePictureId;
  String? drivingLicenseId;
  String? registrationCertificateId;
  List<String> truckImageIds = [];

  bool acceptTerms = false;
  bool acceptPrivacy = false;

  @override
  void initState() {
    super.initState();
    // Fetch vehicle types
    context.read<DriverRegistrationBloc>().add(FetchVehicleData());
  }

  void pickAndUploadFile(String endpoint, String field, String target, Function(String) onUploaded) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      context.read<DriverRegistrationBloc>().add(
            UploadFile(
              path: endpoint,
              field: field,
              filePath: path,
              target: target,
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading file...')),
      );

      // Listen for upload completion
      BlocListener<DriverRegistrationBloc, DriverState>(
        listener: (context, state) {
          if (state is FileUploaded) {
            onUploaded(state.fileId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Upload successful!')),
            );
          } else if (state is RegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(),
      );
    }
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!acceptTerms || !acceptPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept terms and privacy policy')),
      );
      return;
    }
    if (profilePictureId == null || drivingLicenseId == null || registrationCertificateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload all required files')),
      );
      return;
    }
    final reg = DriverRegistration(
      name: nameController.text,
      whatsappNumber: phoneController.text,
      email: emailController.text,
      drivingLicenseId: drivingLicenseId!,
      profilePictureId: profilePictureId!,
      vehicleNumber: vehicleNumberController.text,
      vehicleTypeId: selectedVehicleType!,
      vehicleBodyTypeId: selectedBodyType!,
      vehicleCapacity: int.parse(capacityController.text),
      goodsAccepted: true,
      registrationCertificateId: registrationCertificateId!,
      termsAccepted: acceptTerms,
      privacyAccepted: acceptPrivacy,
      truckImageIds: truckImageIds,
    );
    context.read<DriverRegistrationBloc>().add(SubmitRegistration(reg.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Registration')),
      body: BlocBuilder<DriverRegistrationBloc, DriverState>(
        builder: (context, state) {
          if (state is RegistrationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VehicleDataLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'WhatsApp Number'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: vehicleNumberController,
                        decoration: const InputDecoration(labelText: 'Vehicle Number'),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedVehicleType,
                        items: (state.vehicleTypes as List)
                            .map((e) => DropdownMenuItem(
                                  value: e['_id'],
                                  child: Text(e['name']),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedVehicleType = v),
                        decoration: const InputDecoration(labelText: 'Vehicle Type'),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedBodyType,
                        items: (state.bodyTypes as List)
                            .map((e) => DropdownMenuItem(
                                  value: e['_id'],
                                  child: Text(e['name']),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedBodyType = v),
                        decoration: const InputDecoration(labelText: 'Vehicle Body Type'),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: capacityController,
                        decoration: const InputDecoration(labelText: 'Vehicle Capacity'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          pickAndUploadFile('/images/upload', 'images', 'users', (id) {
                            setState(() => profilePictureId = id);
                          });
                        },
                        child: const Text('Upload Profile Picture'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pickAndUploadFile('/documents/upload', 'documents', 'users', (id) {
                            setState(() => drivingLicenseId = id);
                          });
                        },
                        child: const Text('Upload Driving License'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pickAndUploadFile('/documents/upload', 'documents', 'vehicles', (id) {
                            setState(() => registrationCertificateId = id);
                          });
                        },
                        child: const Text('Upload Registration Certificate'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pickAndUploadFile('/images/upload', 'images', 'vehicles', (id) {
                            setState(() => truckImageIds.add(id));
                          });
                        },
                        child: const Text('Upload Truck Images'),
                      ),
                      CheckboxListTile(
                        value: acceptTerms,
                        onChanged: (v) => setState(() => acceptTerms = v!),
                        title: const Text('I accept Terms & Conditions'),
                      ),
                      CheckboxListTile(
                        value: acceptPrivacy,
                        onChanged: (v) => setState(() => acceptPrivacy = v!),
                        title: const Text('I accept Privacy Policy'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: submit,
                        child: const Text('Submit Registration'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Loading vehicle data...'));
        },
      ),
    );
  }
}
