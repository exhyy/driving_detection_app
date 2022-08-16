import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '连接错误',
        style: TextStyle(
          fontSize: 60.0,
        ),
      ),
    );
  }
}
