import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String image;
  final String? pressedImage;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.image,
    this.pressedImage,
    required this.onPressed,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Image.asset(
        _isPressed && widget.pressedImage != null
            ? widget.pressedImage!
            : widget.image,
        width: 64,
        height: 64,
      ),
    );
  }
}
