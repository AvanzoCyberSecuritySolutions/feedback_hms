import 'dart:convert';
import 'dart:developer';
import 'package:feedback_hms/model/feedback_questions_model.dart';
import 'package:feedback_hms/model/patient_details_model.dart';
import 'package:feedback_hms/model/question_answers_upload_model.dart';
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
          'Failed to fetch patient details.----------------------------------------- Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error occurred while fetching patient details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  Future<void> feedbackDataSaving({
    required String patientId,
    required String patientName,
    required String ipOpNumber,
    required String mobileNumber,
    required String dateOfVisit,
    required String departmentVisited,
    required String wardRoomNo,
    required String treatingDoctor,
    required List<QuestionAnswersUploadModel> responses,
  }) async {
    String uri = "${AppUtils.pythonBaseURL}/feedback/";

    log(
      'res: --------------------------------${responses.map((e) => e.toJson()).toList()}',
    );

    //  body
    Map<String, dynamic> body = {
      "patient_id": patientId,
      "patient_name": patientName,
      "ip_op_number": ipOpNumber,
      "mobile_number": mobileNumber,
      "date_of_visit": dateOfVisit,
      "department_visited": departmentVisited,
      "ward_room_no": wardRoomNo,
      "treating_doctor": treatingDoctor,
      "responses": responses.map((e) => e.toJson()).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(" Feedback submitted successfully");
        print("Response: ${response.body}");
      } else {
        print("Failed to submit feedback. ");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print(" Error : $e");
    }
  }
}
