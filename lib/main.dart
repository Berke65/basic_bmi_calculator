import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const hwapp());
}

class hwapp extends StatefulWidget {
  const hwapp({super.key});

  @override
  State<hwapp> createState() => _hwappState();
}

class _hwappState extends State<hwapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.blueGrey,
        ),
        primarySwatch: Colors.blueGrey,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.blueGrey),
        ),
      ),
      home: const hesapla(),
    );
  }
}

class hesapla extends StatefulWidget {
  const hesapla({super.key});

  @override
  State<hesapla> createState() => _hesaplaState();
}

class _hesaplaState extends State<hesapla> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String state = "";

  final List<Map<String, dynamic>> bmiHistory = [];

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final weight = double.tryParse(weightController.text);
    final height = double.tryParse(heightController.text);

    if (weight == null || height == null || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid weight and height')),
      );
      return;
    }

    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);
    String bmiState = "";
    String only = "";

    if (bmi < 18.5) {
      bmiState = "You are underweight. Try to gain weight for your health.";
      only = "underweight";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      bmiState = "Your weight is normal, continue like this.";
      only = "normal";
    } else if (bmi >= 25.0 && bmi <= 29.9) {
      bmiState = "You are overweight. Try losing weight for your health.";
      only = "overweight";
    } else if (bmi >= 30.0 && bmi <= 34.9) {
      bmiState = "You are in the 1st stage of obesity. Try to lose weight for your health.";
      only = "1st stage obesity";
    } else if (bmi >= 35.0 && bmi <= 39.9) {
      bmiState = "You are in the 2nd stage of obesity. Try to lose weight for your health.";
      only = "2nd stage obesity";
    } else if (bmi >= 40) {
      bmiState = "You are in the 3rd stage of obesity. Try to lose weight for your health.";
      only = "3rd stage obesity";
    }

    setState(() {
      state = bmiState;
      bmiHistory.add({
        'date': DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
        'weight': weight.toStringAsFixed(2),
        'height': height.toStringAsFixed(2),
        'only': only,
      });
    });

    _showBMIDialog(bmi, bmiState);
  }

  void _showBMIDialog(double bmi, String bmiState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('BMI Result', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            'Your BMI is ${bmi.toStringAsFixed(2)}\n$bmiState',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.blueGrey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearHistory() {
    setState(() {
      bmiHistory.clear();
      weightController.clear();
      heightController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Bmi Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Please enter your weight (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center, color: Colors.blueGrey),
                labelStyle: TextStyle(color: Colors.blueGrey),
                filled: true,
                fillColor: Colors.blueGrey.shade50,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Please enter your height (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height, color: Colors.blueGrey),
                labelStyle: TextStyle(color: Colors.blueGrey),
                filled: true,
                fillColor: Colors.blueGrey.shade50,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: const Text('Calculate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'All my results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Weight (kg)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Height (cm)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'State',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var entry in bmiHistory)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(entry['date']),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(entry['weight']),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(entry['height']),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(entry['only']),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: ElevatedButton(
                      onPressed: _clearHistory,
                      child: const Text('Delete all results'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
