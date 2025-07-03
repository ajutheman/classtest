import 'package:classtest/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'services/driver_registration_service.dart';
// import 'blocs/auth/driver_auth_bloc.dart';

void main() {
  final apiService = DriverRegistrationService();
  runApp(
    BlocProvider(
      create: (_) => DriverAuthBloc(apiService),
      child: const MyApp(),
    ),
  );
}
