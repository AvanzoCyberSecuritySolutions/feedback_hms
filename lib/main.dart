import 'package:feedback_hms/controller/feedback_controller.dart';
import 'package:feedback_hms/view/feedbackpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(FeedbackHms());
}

class FeedbackHms extends StatefulWidget {
  const FeedbackHms({super.key});

  @override
  State<FeedbackHms> createState() => _FeedbackHmsState();
}

class _FeedbackHmsState extends State<FeedbackHms> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewFeedbackController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: FeedbackNew()),
      ),
    );
  }
}
