import 'package:flutter/material.dart';

class CountdownOverlay extends StatefulWidget {
  final int countdownStart;
  final VoidCallback onFinished;

  const CountdownOverlay({
    Key? key,
    required this.countdownStart,
    required this.onFinished,
  }) : super(key: key);

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay> {
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.countdownStart;
    _startCountdown();
  }

  void _startCountdown() async {
    while (current > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        current--;
      });
    }
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Text(
          current > 0 ? '$current' : '¡Vamos!',
          style: const TextStyle(
            fontSize: 80,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,             // activa subrayado
            decorationColor:  Color.fromARGB(255, 218, 123, 213),                     // color del subrayado
            decorationThickness: 1,      
          ),
        ),
      ),
    );
  }
}
