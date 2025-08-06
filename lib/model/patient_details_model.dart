class NewFeedbackModel {
  final String? patientId;
  final String? name;
  final String? phone;
  final String? registrationDate;
  final String? department;
  final String? doctor;
  final String? roomNumber;
  final String? admissionType;
  final String? ipno;
  final String? opno;

  NewFeedbackModel({
    this.patientId,
    this.name,
    this.phone,
    this.registrationDate,
    this.department,
    this.doctor,
    this.roomNumber,
    this.admissionType,
    this.ipno,
    this.opno,
  });

  factory NewFeedbackModel.fromJson(Map<String, dynamic> json) {
    return NewFeedbackModel(
      patientId: json['patient_id'],
      name: json['name'],
      phone: json['phone'],
      registrationDate: json['registration_date'],
      department: json['department'],
      doctor: json['doctor'],
      roomNumber: json['room_number'],
      admissionType: json['admission_type'],
      ipno: json['ipno'],
      opno: json['opno'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'name': name,
      'phone': phone,
      'registration_date': registrationDate,
      'department': department,
      'doctor': doctor,
      'room_number': roomNumber,
      'admission_type': admissionType,
      'ipno': ipno,
      'opno': opno,
    };
  }
}
