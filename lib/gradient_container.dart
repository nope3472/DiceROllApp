import 'dart:math';
import 'package:flutter/material.dart';

class GradientBackground extends StatefulWidget {
  const GradientBackground({super.key});

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground> with SingleTickerProviderStateMixin {
  final List<String> diceImages = [
    'assets/images/dice-six-faces-one.png',
    'assets/images/dice-six-faces-two.png',
    'assets/images/dice-six-faces-three.png',
    'assets/images/dice-six-faces-four.png',
    'assets/images/dice-six-faces-five.png',
    'assets/images/dice-six-faces-six.png',
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  String currentDiceImage = 'assets/images/dice-six-faces-one.png';
  bool isRolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollDice() {
    if (isRolling) return;
    setState(() => isRolling = true);
    _controller.reset();
    _controller.forward();

    int rollCount = 0;
    const totalRolls = 10;
    const rollInterval = Duration(milliseconds: 50);

    void changeImage() {
      if (rollCount < totalRolls) {
        setState(() {
          currentDiceImage = diceImages[Random().nextInt(6)];
        });
        rollCount++;
        Future.delayed(rollInterval, changeImage);
      } else {
        setState(() => isRolling = false);
      }
    }

    changeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 4 * 3.14159,
                    child: Transform.scale(
                      scale: 1.0 + (_animation.value * 0.2),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(currentDiceImage),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: rollDice,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  isRolling ? 'Rolling...' : 'Roll Dice',
                  style: const TextStyle(fontSize: 24, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}