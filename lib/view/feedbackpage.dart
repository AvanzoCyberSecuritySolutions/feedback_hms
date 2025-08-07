import 'package:feedback_hms/model/question_answers_upload_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback_hms/constants/color_constants.dart';
import 'package:feedback_hms/controller/feedback_controller.dart';

class FeedbackNew extends StatefulWidget {
  const FeedbackNew({super.key});

  @override
  State<FeedbackNew> createState() => _FeedbackNewState();
}

class _FeedbackNewState extends State<FeedbackNew> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController ipOrOpNumberController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController dateOfVisitController = TextEditingController();
  final TextEditingController departmentVistitedController =
      TextEditingController();
  final TextEditingController roomNoController = TextEditingController();
  final TextEditingController conusultedDoctorController =
      TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  String? rudeBehaviorAnswer;
  String? recommendHospitalAnswer;
  String? followUpAssistAnswer;
  String? isPatientOrParty;
  String? responseUploadOption;

  List<QuestionAnswersUploadModel> questionAnswers = [];

  Widget buildInlineRadioGroup({
    required String question,
    required List<String> options,
    required int? sectionId,
    required int? questionId,
    required String? questionType,
  }) {
    int? selectedIndex = selectedOptionIndexes[sectionId]?[questionId];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        questionType != 'TEXT'
            ? Wrap(
                spacing: 10,
                children: options.asMap().entries.map((option) {
                  int index = option.key;
                  String value = option.value;
                  return ChoiceChip(
                    label: Text(value),
                    selected: selectedIndex == index,
                    selectedColor: const Color.fromARGB(255, 255, 189, 90),
                    onSelected: (_) {
                      setState(() {
                        selectedOptionIndexes[sectionId!] ??= {};
                        selectedOptionIndexes[sectionId]![questionId!] = index;
                      });

                      // Check if this questionId already exists
                      int existingIndex = questionAnswers.indexWhere(
                        (element) => element.questionId == questionId,
                      );

                      if (existingIndex != -1) {
                        // If it exists, update the answer
                        questionAnswers[existingIndex].answers = value;
                      } else {
                        // If not, add a new answer
                        questionAnswers.add(
                          QuestionAnswersUploadModel(
                            questionId: questionId!,
                            answers: value,
                          ),
                        );
                      }

                      print('All Answers:');
                      for (var answer in questionAnswers) {
                        print(
                          'QID: ${answer.questionId}, Ans: ${answer.answers}',
                        );
                      }

                      print('Section ID: $sectionId');
                      print('Question ID: $questionId');
                      print('Selected Index: $index');
                      print('Selected Value: $value');
                    },

                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              )
            : TextFormField(
                controller: selectedOptionControllers[sectionId]?[questionId],
                onChanged: (value) {
                  int existingIndex = questionAnswers.indexWhere(
                    (element) => element.questionId == questionId,
                  );

                  if (existingIndex != -1) {
                    // If it exists, update the answer
                    questionAnswers[existingIndex].answers = value;
                  } else {
                    // If not, add a new answer
                    questionAnswers.add(
                      QuestionAnswersUploadModel(
                        questionId: questionId!,
                        answers: value,
                      ),
                    );
                  }
                  print(questionId);
                  print(value);
                },
              ),
        const Divider(height: 20),
      ],
    );
  }

  Map<int, Map<int, int>> selectedOptionIndexes = {};
  Map<int, Map<int, TextEditingController>> selectedOptionControllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<NewFeedbackController>(
        context,
        listen: false,
      ).getFeedbackQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewFeedbackController>(
      builder: (context, questionsProvider, _) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Consumer<NewFeedbackController>(
              builder: (context, provider, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo + Title
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/highlandlogo-removebg-preview.png',
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.12, // around 12% of screen height
                                ),

                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    // 'PATIENT FEEDBACK FORM\n(NABH FORMAT)',
                                    'PATIENT FEEDBACK FORM (NABH FORMAT)',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.mainOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "SECTION 1: Patient Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Patient ID field with submission logic
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: TextFormField(
                                        controller: patientIdController,
                                        decoration: InputDecoration(
                                          labelText: "Patient ID",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                        ),
                                        onFieldSubmitted: (value) async {
                                          await Provider.of<
                                                NewFeedbackController
                                              >(context, listen: false)
                                              .getPatientDetailsForFeedback(
                                                patientIdController.text.trim(),
                                              );

                                          final details =
                                              Provider.of<
                                                    NewFeedbackController
                                                  >(context, listen: false)
                                                  .patientDetails;

                                          setState(() {
                                            patientNameController.text =
                                                details?.name ?? '';
                                            ipOrOpNumberController.text =
                                                details?.ipno ??
                                                details?.opno ??
                                                '';
                                            mobileNoController.text =
                                                details?.phone ?? '';
                                            dateOfVisitController.text =
                                                details?.registrationDate ?? '';
                                            departmentVistitedController.text =
                                                details?.department ?? '';
                                            roomNoController.text =
                                                details?.roomNumber ?? '';
                                            conusultedDoctorController.text =
                                                details?.doctor ?? '';
                                          });
                                        },
                                      ),
                                    ),

                                    // Remaining fields dynamically
                                    ...[
                                      {
                                        "label": "Patient Name",
                                        "controller": patientNameController,
                                      },
                                      {
                                        "label": "IP / OP Number",
                                        "controller": ipOrOpNumberController,
                                      },
                                      {
                                        "label": "Mobile Number",
                                        "controller": mobileNoController,
                                      },
                                      {
                                        "label": "Date of Visit",
                                        "controller": dateOfVisitController,
                                      },
                                      {
                                        "label": "Department Visited",
                                        "controller":
                                            departmentVistitedController,
                                      },
                                      {
                                        "label": "Ward / Room No",
                                        "controller": roomNoController,
                                      },
                                      {
                                        "label": "Consultant / Doctor",
                                        "controller":
                                            conusultedDoctorController,
                                      },
                                    ].map<Widget>((field) {
                                      final controller =
                                          field["controller"]
                                              as TextEditingController;
                                      final label = field["label"] as String;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        child: TextFormField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            labelText: label,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Sections Loop
                            for (var section
                                in questionsProvider.questions) ...[
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Icon(
                                          //   section['icon'],
                                          //   color: ColorConstants.mainOrange,
                                          // ),
                                          const SizedBox(width: 8),
                                          Text(
                                            section.sectionName ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      for (
                                        int index = 0;
                                        index < section.questions!.length;
                                        index++
                                      )
                                        buildInlineRadioGroup(
                                          question:
                                              section
                                                  .questions?[index]
                                                  .questionText ??
                                              '',
                                          options:
                                              section
                                                  .questions?[index]
                                                  .choices ??
                                              [],
                                          sectionId: section.sectionId,
                                          questionId:
                                              section.questions?[index].id,
                                          questionType: section
                                              .questions?[index]
                                              .questionType,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final functionProvider =
                                      Provider.of<NewFeedbackController>(
                                        context,
                                        listen: false,
                                      );

                                  await functionProvider.feedbackDataSaving(
                                    patientId: patientIdController.text.trim(),
                                    patientName: patientNameController.text,
                                    ipOpNumber: ipOrOpNumberController.text,
                                    mobileNumber: mobileNoController.text,
                                    dateOfVisit: dateOfVisitController.text,
                                    departmentVisited:
                                        departmentVistitedController.text,
                                    wardRoomNo: roomNoController.text,
                                    treatingDoctor:
                                        conusultedDoctorController.text,
                                    responses: questionAnswers,
                                  );

                                  // ✅ Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 20,
                                      ),
                                      backgroundColor:
                                          ColorConstants.mainLightBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      duration: const Duration(seconds: 3),
                                      content: Row(
                                        children: const [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              "Feedback submitted successfully!",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                  // ✅ Clear all the text fields
                                  patientIdController.clear();
                                  patientNameController.clear();
                                  ipOrOpNumberController.clear();
                                  mobileNoController.clear();
                                  dateOfVisitController.clear();
                                  departmentVistitedController.clear();
                                  roomNoController.clear();
                                  conusultedDoctorController.clear();

                                  // ✅ Optionally clear questionAnswers map if needed
                                  questionAnswers.clear();
                                  selectedOptionIndexes
                                      .clear(); // Add this line or similar based on your implementation
                                  selectedOptionControllers.clear();
                                  setState(
                                    () {},
                                  ); // Rebuilds the UI with cleared values

                                  setState(() {}); // refresh UI if needed
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.mainOrange,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
