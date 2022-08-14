import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.onLoading}) : super(key: key);
  final VoidCallback onLoading;

  @override
  Widget build(BuildContext context) {
    onLoading();
    return const SpinKitWave(
      color: Colors.blue,
      size: 50.0,
    );
  }
}
