class FeedbackQuestionModel {
  int? sectionId;
  String? sectionName;
  List<FeedbackQuestion>? questions;

  FeedbackQuestionModel({this.sectionId, this.sectionName, this.questions});

  factory FeedbackQuestionModel.fromJson(Map<String, dynamic> json) {
    return FeedbackQuestionModel(
      sectionId: json['section_id'],
      sectionName: json['section_name'],
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => FeedbackQuestion.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_id': sectionId,
      'section_name': sectionName,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }
}

class FeedbackQuestion {
  int? id;
  String? questionText;
  String? questionType;
  List<String>? choices;

  FeedbackQuestion({this.id, this.questionText, this.questionType, this.choices});

  factory FeedbackQuestion.fromJson(Map<String, dynamic> json) {
    return FeedbackQuestion(
      id: json['id'],
      questionText: json['question_text'],
      questionType: json['question_type'],
      choices: (json['choices'] as List<dynamic>?)
          ?.map((c) => c.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType,
      'choices': choices,
    };
  }
}
