import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/driver_auth_bloc.dart';
import '../../../blocs/auth/driver_auth_event.dart';
import '../../../blocs/auth/driver_auth_state.dart';
import 'driver_register_screen.dart';

class DriverOtpScreen extends StatefulWidget {
  const DriverOtpScreen({super.key});

  @override
  State<DriverOtpScreen> createState() => _DriverOtpScreenState();
}

class _DriverOtpScreenState extends State<DriverOtpScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool otpRequested = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver OTP Verification')),
      body: BlocConsumer<DriverAuthBloc, DriverAuthState>(
        listener: (context, state) {
          if (state is DriverOtpVerified) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DriverRegisterScreen(verificationToken: state.token),
              ),
            );
          } else if (state is DriverAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DriverAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                if (otpRequested)
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'OTP'),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (!otpRequested) {
                      context.read<DriverAuthBloc>().add(RequestDriverOtp(phoneController.text));
                      setState(() => otpRequested = true);
                    } else {
                      context.read<DriverAuthBloc>().add(VerifyDriverOtp(
                            phoneController.text,
                            otpController.text,
                          ));
                    }
                  },
                  child: Text(otpRequested ? 'Verify OTP' : 'Request OTP'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
