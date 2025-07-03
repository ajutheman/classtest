abstract class DriverAuthEvent {}

class RequestDriverOtp extends DriverAuthEvent {
  final String phone;
  RequestDriverOtp(this.phone);
}

class VerifyDriverOtp extends DriverAuthEvent {
  final String phone;
  final String otp;
  VerifyDriverOtp(this.phone, this.otp);
}
