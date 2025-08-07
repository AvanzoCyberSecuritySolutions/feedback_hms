//

class QuestionAnswersUploadModel {
  QuestionAnswersUploadModel({required this.questionId, required this.answers});

  final int questionId;
  String? answers;

  Map<String, dynamic> toJson() {
    return {'question_id': questionId, 'answer': answers};
  }
}
