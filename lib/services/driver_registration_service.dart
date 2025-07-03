import 'package:http/http.dart' as http;
import 'api_service.dart';

class DriverRegistrationService {
  final ApiService _api = ApiService();

  Future requestOtp(String phone) {
    return _api.post('/auth/request-otp', {'phone': phone});
  }

  Future verifyOtp(String phone, String otp) {
    return _api.post('/auth/verify-otp', {
      'phone': phone,
      'otp': otp,
    });
  }

  Future getVehicleTypes() {
    return _api.get('/vehicles/types');
  }

  Future getVehicleBodyTypes() {
    return _api.get('/vehicles/body-types');
  }

  Future uploadFile(String path, String field, String filePath, {String target = 'users'}) async {
    final file = await http.MultipartFile.fromPath(field, filePath);
    return _api.uploadMultipart(
      path,
      {
        'target': target,
        'newUser': 'true',
      },
      [file],
    );
  }

  Future registerDriver(Map<String, dynamic> data) {
    return _api.post('/users/drivers', data);
  }
}
