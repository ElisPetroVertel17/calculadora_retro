import 'package:flutter/material.dart';
import 'calculator_button.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  final List<String> _history = [];

  void _onButtonPressed(String value) {
    setState(() {
      _input += value;
    });
  }

  void _clearInput() {
    setState(() {
      _input = '';
    });
  }

  void _calculateResult() {
    try {
      final parser = ShuntingYardParser();
      final exp = parser.parse(
        _input.replaceAll('×', '*').replaceAll('÷', '/'),
      );
      final cm = ContextModel();
      final result = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        // Guardamos antes de sobrescribir _input
        _history.add('$_input = ${result.toString()}');
        if (_history.length > 30) {
          _history.removeAt(0); // Elimina el más viejo si hay más de 30
        }

        _input = result.toString();
      });
    } catch (e) {
      setState(() {
        _input = 'Error';
      });
    }
  }

  void _backspace() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    });
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1235),
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1235),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFF930DB9), width: 3),
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              // Encabezado con botón de cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Historial',
                    style: TextStyle(
                      color: Color(0xFF3AD9E0),
                      fontSize: 20,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF3AD9E0)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Color(0xFF3AD9E0)),
              Expanded(
                child:
                    _history.isEmpty
                        ? const Center(
                          child: Text(
                            'Aún no hay operaciones.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontFamily: 'PressStart2P',
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final item = _history[_history.length - 1 - index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Color(0xFF3AD9E0),
                                  fontSize: 16,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 100,
            left: 40,
            right: 40,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Image.asset('assets/images/display.png', fit: BoxFit.contain),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    _input,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(255, 170, 10, 233),
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 280,
            left: 20,
            right: 20,
            bottom: 20,
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                CalculatorButton(
                  image: 'assets/images/btn_clear.png',
                  pressedImage: 'assets/images/btn_clear_pressed.png',
                  onPressed: _clearInput,
                ),
                CalculatorButton(
                  image: 'assets/images/btn_backspace.png',
                  pressedImage: 'assets/images/btn_backspace_pressed.png',
                  onPressed: _backspace,
                ),
                CalculatorButton(
                  image: 'assets/images/btn_history.png',
                  pressedImage: 'assets/images/btn_history_pressed.png',
                  onPressed: _showHistory,
                ),
                CalculatorButton(
                  image: 'assets/images/btn_power.png',
                  pressedImage: 'assets/images/btn_power_pressed.png',
                  onPressed: () => _onButtonPressed('^'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_7.png',
                  pressedImage: 'assets/images/btn_7_pressed.png',
                  onPressed: () => _onButtonPressed('7'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_8.png',
                  pressedImage: 'assets/images/btn_8_pressed.png',
                  onPressed: () => _onButtonPressed('8'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_9.png',
                  pressedImage: 'assets/images/btn_9_pressed.png',
                  onPressed: () => _onButtonPressed('9'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_divide.png',
                  pressedImage: 'assets/images/btn_divide_pressed.png',
                  onPressed: () => _onButtonPressed('÷'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_4.png',
                  pressedImage: 'assets/images/btn_4_pressed.png',
                  onPressed: () => _onButtonPressed('4'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_5.png',
                  pressedImage: 'assets/images/btn_5_pressed.png',
                  onPressed: () => _onButtonPressed('5'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_6.png',
                  pressedImage: 'assets/images/btn_6_pressed.png',
                  onPressed: () => _onButtonPressed('6'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_multiply.png',
                  pressedImage: 'assets/images/btn_multiply_pressed.png',
                  onPressed: () => _onButtonPressed('×'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_1.png',
                  pressedImage: 'assets/images/btn_1_pressed.png',
                  onPressed: () => _onButtonPressed('1'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_2.png',
                  pressedImage: 'assets/images/btn_2_pressed.png',
                  onPressed: () => _onButtonPressed('2'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_3.png',
                  pressedImage: 'assets/images/btn_3_pressed.png',
                  onPressed: () => _onButtonPressed('3'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_minus.png',
                  pressedImage: 'assets/images/btn_minus_pressed.png',
                  onPressed: () => _onButtonPressed('-'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_0.png',
                  pressedImage: 'assets/images/btn_0_pressed.png',
                  onPressed: () => _onButtonPressed('0'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_dot.png',
                  pressedImage: 'assets/images/btn_dot_pressed.png',
                  onPressed: () => _onButtonPressed('.'),
                ),
                CalculatorButton(
                  image: 'assets/images/btn_equals.png',
                  pressedImage: 'assets/images/btn_equals_pressed.png',
                  onPressed: _calculateResult,
                ),
                CalculatorButton(
                  image: 'assets/images/btn_plus.png',
                  pressedImage: 'assets/images/btn_plus_pressed.png',
                  onPressed: () => _onButtonPressed('+'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
