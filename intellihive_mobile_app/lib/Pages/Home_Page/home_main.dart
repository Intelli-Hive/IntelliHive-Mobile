import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _Page1State();
}

class _Page1State extends State<HomePage> {
  static const String _title = 'Intellihive';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intellihive'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BeehiveCard(
                hiveName: 'Hive 1',
                humidity: 60,
                temperature: 25,
                weight: 0.7,
                numBars: 3,
              ),
              SizedBox(height: 20),
              BeehiveCard(
                hiveName: 'Hive 2',
                humidity: 70,
                temperature: 26,
                weight: 0.5,
                numBars: 4,
              ),
              SizedBox(height: 20),
              BeehiveCard(
                hiveName: 'Hive 3',
                humidity: 65,
                temperature: 24,
                weight: 0.8,
                numBars: 4,
              ),
              SizedBox(height: 20),
              BeehiveCard(
                hiveName: 'Hive 4',
                humidity: 62,
                temperature: 23,
                weight: 0.6,
                numBars: 4,
              ),
              SizedBox(height: 20),
              BeehiveCard(
                hiveName: 'Hive 5',
                humidity: 68,
                temperature: 27,
                weight: 0.9,
                numBars: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BeehiveCard extends StatelessWidget {
  final String hiveName;
  final double humidity;
  final double temperature;
  final double weight;
  final int numBars;

  BeehiveCard({
    required this.hiveName,
    required this.humidity,
    required this.temperature,
    required this.weight,
    required this.numBars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hiveName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Humidity: ${humidity.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Temperature: ${temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              numBars,
                  (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  height: 20,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Weight: ${weight.toStringAsFixed(1)} kg',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Butona basıldığında yapılacak işlemler buraya yazılabilir
            },
            child: const Text('İncele'),
          ),
        ],
      ),
    );
  }
}

