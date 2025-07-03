class DriverRegistration {
  String name;
  String whatsappNumber;
  String email;
  String drivingLicenseId;
  String profilePictureId;
  String vehicleNumber;
  String vehicleTypeId;
  String vehicleBodyTypeId;
  int vehicleCapacity;
  bool goodsAccepted;
  String registrationCertificateId;
  bool termsAccepted;
  bool privacyAccepted;
  List<String> truckImageIds;

  DriverRegistration({
    required this.name,
    required this.whatsappNumber,
    required this.email,
    required this.drivingLicenseId,
    required this.profilePictureId,
    required this.vehicleNumber,
    required this.vehicleTypeId,
    required this.vehicleBodyTypeId,
    required this.vehicleCapacity,
    required this.goodsAccepted,
    required this.registrationCertificateId,
    required this.termsAccepted,
    required this.privacyAccepted,
    required this.truckImageIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "whatsappNumber": whatsappNumber,
      "email": email,
      "drivingLicense": drivingLicenseId,
      "profilePicture": profilePictureId,
      "vehicleNumber": vehicleNumber,
      "vehicleType": vehicleTypeId,
      "vehicleBodyType": vehicleBodyTypeId,
      "vehicleCapacity": vehicleCapacity,
      "goodsAccepted": goodsAccepted,
      "registrationCertificate": registrationCertificateId,
      "termsAndConditionsAccepted": termsAccepted,
      "privacyPolicyAccepted": privacyAccepted,
      "truckImages": truckImageIds,
    };
  }
}
