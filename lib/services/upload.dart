import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class ProgressBar extends StatelessWidget {
  final int? currentStep;
  const ProgressBar({Key? key, this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LinearProgressBar(
          maxSteps: 100,
          progressType: LinearProgressBar.progressTypeLinear,
          currentStep: currentStep,
          progressColor: Colors.red,
          backgroundColor: Colors.grey,
        ),
        Text('$currentStep %'),
      ],
    );
  }
}
