import 'dart:convert';
import 'dart:developer';
import 'package:feedback_hms/model/feedback_questions_model.dart';
import 'package:feedback_hms/model/patient_details_model.dart';
import 'package:feedback_hms/services/app_utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class NewFeedbackController with ChangeNotifier {
  NewFeedbackModel? patientDetails;
  bool isLoading = false;

  // List<dynamic> questions = [];
  // Map<int, String> responses = {};
  List<FeedbackQuestionModel> questions = [];

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
          'Failed to fetch patient details. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error occurred while fetching patient details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> getQuestionsForFeedback() async {
  //   String uri = "${AppUtils.pythonBaseURL}/feedback-questions/";

  //   try {
  //     isLoading = true;
  //     notifyListeners();

  //     final response = await http.get(Uri.parse(uri));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       questions = data;
  //       responses = {}; // reset responses
  //       notifyListeners();
  //     } else {
  //       print("Failed to fetch questions: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // void setResponse(int index, String value) {
  //   responses[index] = value;
  //   notifyListeners();
  // }

  Future<void> getFeedbackQuestions() async {
    String uri = "${AppUtils.pythonBaseURL}/feedback-questions/";

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        log(response.statusCode.toString());

        log("body ===== ${response.body}");
        questions = jsonData
            .map((json) => FeedbackQuestionModel.fromJson(json))
            .toList();
        log("questions: $questions");
        print("Feedback questions loaded: ${questions.length}");
      } else {
        print('Failed to fetch questions. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching feedback questions: $e');
    } finally {
      notifyListeners();
    }
  }
}
