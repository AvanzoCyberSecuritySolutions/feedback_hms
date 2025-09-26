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

  Future<bool> getPatientDetailsForFeedback(String searchInput) async {
    String uri = "${AppUtils.pythonBaseURL}/patient-op-ip/";

    String queryParam;
    if (RegExp(r'^[a-zA-Z]').hasMatch(searchInput)) {
      queryParam = "?patient_id=$searchInput";
    } else if (RegExp(r'^\d{10}$').hasMatch(searchInput)) {
      queryParam = "?phone=$searchInput";
    } else {
      print('Invalid input. Please enter a valid Patient ID or Phone Number.');
      return false;
    }

    String url = uri + queryParam;

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        patientDetails = NewFeedbackModel.fromJson(jsonDecode(response.body));
        debugPrint("Patient details fetched: ${patientDetails?.toJson()}");
        notifyListeners();
        return true;
      } else {
        debugPrint(
          'Failed to fetch patient details.----------------------------------------- Status: ${response.statusCode}',
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Error occurred while fetching patient details: $e');
      notifyListeners();
      return false;
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
        debugPrint("Feedback questions loaded: ${questions.length}");
      } else {
        debugPrint('Failed to fetch questions. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching feedback questions: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<bool> feedbackDataSaving({
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
        debugPrint("Feedback submitted successfully");
        debugPrint("Response: ${response.body}");
        return true; // ✅ Success
      } else {
        debugPrint("Failed to submit feedback.");
        debugPrint("Response: ${response.body}");
        return false; // ❌ Failure
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false; // ❌ Error case
    }
  }

  Future<void> getFeedbackQuestionsByLang(String lang) async {
    String uri = "${AppUtils.pythonBaseURL}/feedback-questions/?lang=$lang";

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        questions = jsonData
            .map((json) => FeedbackQuestionModel.fromJson(json))
            .toList();

        debugPrint(
          "Feedback questions loaded for lang=$lang: ${questions.length}",
        );
      } else {
        debugPrint('Failed to fetch questions. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching feedback questions: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
