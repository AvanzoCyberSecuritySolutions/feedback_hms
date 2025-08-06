import 'dart:convert';
import 'package:feedback_hms/model/feedback_model.dart';
import 'package:feedback_hms/services/app_utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class NewFeedbackController with ChangeNotifier {
  NewFeedbackModel? patientDetails;
  bool isLoading = false;

  Future<void> getPatientDetailsForFeedback(String patientId) async {
    String uri =
        "${AppUtils.pythonBaseURL}/patient-op-ip/?patient_id=$patientId";

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        patientDetails = NewFeedbackModel.fromJson(jsonDecode(response.body));
        print("Patient details fetched: ${patientDetails?.toJson()}");
      } else {
        print(
            'Failed to fetch patient details. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching patient details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
