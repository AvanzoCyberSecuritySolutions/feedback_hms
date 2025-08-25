import 'package:feedback_hms/model/question_answers_upload_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  List<QuestionAnswersUploadModel> questionAnswers = [];
  Map<int, Map<int, int>> selectedOptionIndexes = {};
  Map<int, Map<int, TextEditingController>> selectedOptionControllers = {};

  Widget buildInlineRadioGroup({
    required String question,
    required List<String> options,
    required int? sectionId,
    required int? questionId,
    required String? questionType,
  }) {
    int? selectedIndex = selectedOptionIndexes[sectionId]?[questionId];

    if (questionType == 'TEXT') {
      selectedOptionControllers[sectionId ?? 0] ??= {};
      selectedOptionControllers[sectionId ?? 0]![questionId ?? 0] ??=
          TextEditingController();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        questionType != 'TEXT'
            ? Wrap(
                spacing: 10,
                runSpacing: 8,
                children: options.asMap().entries.map((option) {
                  int index = option.key;
                  String value = option.value;
                  return ChoiceChip(
                    label: Text(value),
                    labelStyle: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.black87,
                    ),
                    selected: selectedIndex == index,
                    selectedColor: ColorConstants.mainBlue,
                    onSelected: (_) {
                      setState(() {
                        selectedOptionIndexes[sectionId!] ??= {};
                        selectedOptionIndexes[sectionId]![questionId!] = index;
                      });

                      int existingIndex = questionAnswers.indexWhere(
                        (element) => element.questionId == questionId,
                      );

                      if (existingIndex != -1) {
                        questionAnswers[existingIndex].answers = value;
                      } else {
                        questionAnswers.add(
                          QuestionAnswersUploadModel(
                            questionId: questionId!,
                            answers: value,
                          ),
                        );
                      }
                    },
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              )
            : TextFormField(
                controller: selectedOptionControllers[sectionId]![questionId],
                decoration: InputDecoration(
                  hintText: "Type your response here...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onChanged: (value) {
                  int existingIndex = questionAnswers.indexWhere(
                    (element) => element.questionId == questionId,
                  );

                  if (existingIndex != -1) {
                    questionAnswers[existingIndex].answers = value;
                  } else {
                    questionAnswers.add(
                      QuestionAnswersUploadModel(
                        questionId: questionId!,
                        answers: value,
                      ),
                    );
                  }
                },
              ),
        const Divider(height: 24),
      ],
    );
  }

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
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  ColorConstants.mainLightBlue,
                  ColorConstants.mainBlue,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'PATIENT FEEDBACK FORM\n(NABH FORMAT)',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.mainBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Patient Details
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SECTION 1: Patient Details",
                              style: TextStyle(
                                color: ColorConstants.mainOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildPatientFields(context),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==============================
                      // Dynamic Sections (with image ONLY on 2nd card)
                      // ==============================
                      for (
                        int sIndex = 0;
                        sIndex < questionsProvider.questions.length;
                        sIndex++
                      )
                        _buildCard(
                          child: sIndex == 0
                              // ---- SECOND CARD: Row with right image panel ----
                              ? IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Left: Section title + questions
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              questionsProvider
                                                      .questions[sIndex]
                                                      .sectionName ??
                                                  '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    ColorConstants.mainOrange,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            for (
                                              int qIndex = 0;
                                              qIndex <
                                                  (questionsProvider
                                                      .questions[sIndex]
                                                      .questions!
                                                      .length);
                                              qIndex++
                                            )
                                              buildInlineRadioGroup(
                                                question:
                                                    questionsProvider
                                                        .questions[sIndex]
                                                        .questions?[qIndex]
                                                        .questionText ??
                                                    '',
                                                options:
                                                    questionsProvider
                                                        .questions[sIndex]
                                                        .questions?[qIndex]
                                                        .choices ??
                                                    [],
                                                sectionId: questionsProvider
                                                    .questions[sIndex]
                                                    .sectionId,
                                                questionId: questionsProvider
                                                    .questions[sIndex]
                                                    .questions?[qIndex]
                                                    .id,
                                                questionType: questionsProvider
                                                    .questions[sIndex]
                                                    .questions?[qIndex]
                                                    .questionType,
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Right: Image panel (fills card height)
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Lottie animation
                                            Expanded(
                                              child: Lottie.asset(
                                                'assets/images/Doctor welcoming pacient (1).json',
                                                fit: BoxFit.contain,
                                                repeat: true,
                                              ),
                                            ),

                                            // Gradient Text
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 16,
                                              ),
                                              child: ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    const LinearGradient(
                                                      colors: [
                                                        Colors.teal,
                                                        Colors.blueAccent,
                                                        Colors.orange,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ).createShader(bounds),
                                                child: const Text(
                                                  "Get Well Soon",
                                                  style: TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .white, // Needed for ShaderMask
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              // ---- OTHER CARDS: normal column ----
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      questionsProvider
                                              .questions[sIndex]
                                              .sectionName ??
                                          '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.mainOrange,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    for (
                                      int qIndex = 0;
                                      qIndex <
                                          (questionsProvider
                                              .questions[sIndex]
                                              .questions!
                                              .length);
                                      qIndex++
                                    )
                                      buildInlineRadioGroup(
                                        question:
                                            questionsProvider
                                                .questions[sIndex]
                                                .questions?[qIndex]
                                                .questionText ??
                                            '',
                                        options:
                                            questionsProvider
                                                .questions[sIndex]
                                                .questions?[qIndex]
                                                .choices ??
                                            [],
                                        sectionId: questionsProvider
                                            .questions[sIndex]
                                            .sectionId,
                                        questionId: questionsProvider
                                            .questions[sIndex]
                                            .questions?[qIndex]
                                            .id,
                                        questionType: questionsProvider
                                            .questions[sIndex]
                                            .questions?[qIndex]
                                            .questionType,
                                      ),
                                  ],
                                ),
                        ),

                      const SizedBox(height: 30),

                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final functionProvider =
                                Provider.of<NewFeedbackController>(
                                  context,
                                  listen: false,
                                );

                            bool isSuccess = await functionProvider
                                .feedbackDataSaving(
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

                            if (isSuccess) {
                              _clearForm();

                              // 🎉 Show Thank You Dialog with Lottie
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent closing by tapping outside
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: const EdgeInsets.all(20),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(
                                          'assets/images/Completed Successfully.json',
                                          height: 150,
                                          repeat: false,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Thank You!",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConstants.mainBlue,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Your feedback has been submitted successfully.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pop(); // close dialog
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorConstants.mainOrange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            "Close",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              // ❌ Show error Snackbar if failed
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: const Text(
                                    " Failed to submit feedback",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: ColorConstants.mainOrange,
                            elevation: 6,
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Reusable card widget ---
  // --- Reusable card widget with gradient background ---
  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              ColorConstants.mainLightBlue.withValues(alpha: 0.15),
              Colors.white,
              ColorConstants.mainBlue.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(padding: const EdgeInsets.all(18), child: child),
      ),
    );
  }

  // --- Patient details fields ---
  Widget _buildPatientFields(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: patientIdController,
          label: "Enter your Patient ID or Phone no",
          isUpperCase: true,
          onSubmitted: () async {
            bool status = await Provider.of<NewFeedbackController>(
              context,
              listen: false,
            ).getPatientDetailsForFeedback(patientIdController.text.trim());
            if (!context.mounted) return;
            final details = Provider.of<NewFeedbackController>(
              context,
              listen: false,
            ).patientDetails;
            if (status) {
              setState(() {
                patientIdController.text = details?.patientId ?? '';
                patientNameController.text = details?.name ?? '';
                ipOrOpNumberController.text =
                    details?.ipno ?? details?.opno ?? '';
                mobileNoController.text = details?.phone ?? '';
                dateOfVisitController.text = details?.registrationDate ?? '';
                departmentVistitedController.text = details?.department ?? '';
                roomNoController.text = details?.roomNumber ?? '';
                conusultedDoctorController.text = details?.doctor ?? '';
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No patient found'),
                  backgroundColor: ColorConstants.mainRed,
                  duration: Duration(milliseconds: 1500),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: patientNameController,
          label: "Patient Name",
          readOnly: true,
        ),
        _buildTextField(
          controller: ipOrOpNumberController,
          label: "IP / OP Number",
          readOnly: true,
        ),
        _buildTextField(controller: mobileNoController, label: "Mobile Number"),
        _buildTextField(
          controller: dateOfVisitController,
          label: "Date of Visit",
          readOnly: true,
        ),
        _buildTextField(
          controller: departmentVistitedController,
          label: "Department Visited",
          readOnly: true,
        ),
        _buildTextField(
          controller: roomNoController,
          label: "Ward / Room No",
          readOnly: true,
        ),
        _buildTextField(
          controller: conusultedDoctorController,
          label: "Consultant / Doctor",
          readOnly: true,
        ),
      ],
    );
  }

  // --- Common TextField Style ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isUpperCase = false,
    VoidCallback? onSubmitted,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onChanged: isUpperCase
            ? (value) {
                final upper = value.toUpperCase();
                if (value != upper) {
                  controller.value = controller.value.copyWith(
                    text: upper,
                    selection: TextSelection.collapsed(offset: upper.length),
                  );
                }
              }
            : null,
        onFieldSubmitted: (_) => onSubmitted?.call(),
      ),
    );
  }

  // --- Clear everything after submit ---
  void _clearForm() {
    selectedOptionControllers.forEach((sectionId, questionMap) {
      questionMap.forEach((questionId, controller) {
        controller.clear();
      });
    });
    selectedOptionControllers.clear();
    selectedOptionIndexes.clear();
    questionAnswers.clear();
    patientIdController.clear();
    patientNameController.clear();
    ipOrOpNumberController.clear();
    mobileNoController.clear();
    dateOfVisitController.clear();
    departmentVistitedController.clear();
    roomNoController.clear();
    conusultedDoctorController.clear();

    setState(() {});
  }
}
