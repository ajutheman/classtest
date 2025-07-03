import 'package:flutter_bloc/flutter_bloc.dart';
import 'driver_auth_event.dart';
import 'driver_auth_state.dart';
import '../../services/driver_registration_service.dart';

class DriverAuthBloc extends Bloc<DriverAuthEvent, DriverAuthState> {
  final DriverRegistrationService api;

  DriverAuthBloc(this.api) : super(DriverAuthInitial()) {
    on<RequestDriverOtp>((event, emit) async {
      emit(DriverAuthLoading());
      try {
        await api.requestOtp(event.phone);
        emit(DriverOtpRequested());
      } catch (e) {
        emit(DriverAuthError(e.toString()));
      }
    });

    on<VerifyDriverOtp>((event, emit) async {
      emit(DriverAuthLoading());
      try {
        final res = await api.verifyOtp(event.phone, event.otp);
        emit(DriverOtpVerified(res['token']));
      } catch (e) {
        emit(DriverAuthError(e.toString()));
      }
    });
  }
}
