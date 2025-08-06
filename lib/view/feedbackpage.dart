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

  final Map<int, String?> feedbackAnswers = {
    for (var i = 1; i <= 20; i++) i: null,
  };
  final List<String> options = ['Excellent', 'Good', 'Fair', 'Poor'];

  String? rudeBehaviorAnswer;
  String? recommendHospitalAnswer;
  String? followUpAssistAnswer;
  String? isPatientOrParty;
  String? responseUploadOption;

  final List<Map<String, dynamic>> sections = [
    {
      "title": "Front Office & Admissions",
      "icon": Icons.person_pin_rounded,
      "questions": [
        '1. Helpfulness and courtesy of front office staff',
        '2. Clarity of admission / registration process',
        '3. Waiting time for registration or token',
      ],
    },
    {
      "title": "Clinical Care",
      "icon": Icons.local_hospital,
      "questions": [
        '4. Nursing care (attentiveness, promptness, empathy)',
        '5. Doctors\' professionalism and communication',
        '6. Explanation of condition and treatment plan',
        '7. Time taken to attend by doctors or nurses',
      ],
    },
    {
      "title": "Diagnostics & Support Services",
      "icon": Icons.biotech,
      "questions": [
        '8. Lab services (sample collection, waiting time)',
        '9. Radiology services (X-ray, CT, MRI)',
        '10. Timeliness of investigation reports',
        '11. Ease of finding the diagnostic departments',
      ],
    },
    {
      "title": "Facilities, Maintenance & Security",
      "icon": Icons.cleaning_services,
      "questions": [
        '12. Cleanliness of room, toilets, and surroundings',
        '13. Maintenance response to any facility issues',
        '14. Courtesy and presence of security staff',
      ],
    },
    {
      "title": "Food & Pharmacy",
      "icon": Icons.restaurant,
      "questions": [
        '15. Quality and hygiene of food served',
        '16. Timeliness and courtesy of food delivery staff',
        '17. Pharmacy services - availability and staff behavior',
      ],
    },
    {
      "title": "Discharge & Billing",
      "icon": Icons.receipt_long,
      "questions": [
        '18. Speed and coordination of discharge process',
        '19. Clarity of discharge instructions and summary',
        '20. Transparency of final billing',
      ],
    },
  ];

  Widget buildInlineRadioGroup({required String question, required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: feedbackAnswers[index] == option,
              selectedColor: const Color.fromARGB(255, 255, 189, 90),
              onSelected: (_) {
                setState(() => feedbackAnswers[index] = option);
              },
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
        const Divider(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int questionIndex = 1;

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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                ...[
                                  {
                                    "label": "Patient ID",
                                    "controller": patientIdController,
                                  },
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
                                    "controller": departmentVistitedController,
                                  },
                                  {
                                    "label": "Ward / Room No",
                                    "controller": roomNoController,
                                  },
                                  {
                                    "label": "Consultant / Doctor",
                                    "controller": conusultedDoctorController,
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
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Sections Loop
                        for (var section in sections) ...[
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        section['icon'],
                                        color: ColorConstants.mainOrange,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        section['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  for (String question in section['questions'])
                                    buildInlineRadioGroup(
                                      question: question,
                                      index: questionIndex++,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),
                        const Text(
                          "SECTION 8: Interaction & Courtesy",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Overall behavior of hospital staff",
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText:
                                "Were you treated respectfully at all points?",
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Were your questions answered kindly?",
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          "Did anyone behave rudely or unprofessionally?",
                        ),
                        Row(
                          children: ["Yes", "No"].map((val) {
                            return Expanded(
                              child: RadioListTile<String>(
                                value: val,
                                groupValue: rudeBehaviorAnswer,
                                onChanged: (value) =>
                                    setState(() => rudeBehaviorAnswer = value),
                                title: Text(val),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                              ),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          controller: departmentController,
                          decoration: const InputDecoration(
                            labelText: "Department (if Yes)",
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          "SECTION 9: Overall Experience",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Would you recommend our hospital to others?",
                        ),
                        Row(
                          children: ["Yes", "No"].map((val) {
                            return Expanded(
                              child: RadioListTile<String>(
                                value: val,
                                groupValue: recommendHospitalAnswer,
                                onChanged: (value) => setState(
                                  () => recommendHospitalAnswer = value,
                                ),
                                title: Text(val),
                                dense: true,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 10),
                        const Text("OPTIONAL SERVICE"),
                        const Text(
                          "Would you like us to assist in follow-up booking?",
                        ),
                        Row(
                          children: ["Yes", "No"].map((val) {
                            return Expanded(
                              child: RadioListTile<String>(
                                value: val,
                                groupValue: followUpAssistAnswer,
                                onChanged: (value) => setState(
                                  () => followUpAssistAnswer = value,
                                ),
                                title: Text(val),
                              ),
                            );
                          }).toList(),
                        ),

                        const Text("(If yes, our staff will contact you)"),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Text("Are you the:"),
                            Checkbox(
                              value: isPatientOrParty == "Patient",
                              onChanged: (value) {
                                setState(() {
                                  isPatientOrParty = value! ? "Patient" : null;
                                });
                              },
                            ),
                            const Text("Patient"),
                            Checkbox(
                              value: isPatientOrParty == "Patient Party",
                              onChanged: (value) {
                                setState(() {
                                  isPatientOrParty = value!
                                      ? "Patient Party"
                                      : null;
                                });
                              },
                            ),
                            const Text("Patient Party"),
                          ],
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          "Would you like to upload this feedback to our website?",
                        ),
                        Row(
                          children: ["Yes", "No"].map((val) {
                            return Expanded(
                              child: RadioListTile<String>(
                                value: val,
                                groupValue: responseUploadOption,
                                onChanged: (value) => setState(
                                  () => responseUploadOption = value,
                                ),
                                title: Text(val),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
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
                              }
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
  }
}
