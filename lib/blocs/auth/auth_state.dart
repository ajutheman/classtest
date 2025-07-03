abstract class DriverAuthState {}

class DriverAuthInitial extends DriverAuthState {}

class DriverAuthLoading extends DriverAuthState {}

class DriverOtpRequested extends DriverAuthState {}

class DriverOtpVerified extends DriverAuthState {
  final String token;
  DriverOtpVerified(this.token);
}

class DriverAuthError extends DriverAuthState {
  final String message;
  DriverAuthError(this.message);
}
