import 'package:flutter/material.dart';

// Entry point of the Flutter application
void main() => runApp(const CounterApp());

/// CounterApp - The root widget (StatefulWidget)
/// Demonstrates Flutter's reactive UI system where setState() triggers rebuilds
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

/// State class for CounterApp
/// Manages the mutable state (count) and rebuilds UI when state changes
class _CounterAppState extends State<CounterApp> {
  // Mutable state variable
  int count = 0;

  /// Increments the counter and triggers UI rebuild
  /// setState() notifies Flutter that state has changed
  void increment() {
    setState(() {
      count++;
    });
  }

  /// Decrements the counter (added for better demo)
  void decrement() {
    setState(() {
      if (count > 0) count--;
    });
  }

  /// Resets the counter to zero
  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter & Dart Fundamentals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stateful Widget Demo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stateless widget example - InfoCard
              const InfoCard(
                title: 'Flutter Counter App',
                subtitle: 'Demonstrating Reactive UI',
              ),
              const SizedBox(height: 40),
              
              // Display current count with styled text
              Text(
                'Count: $count',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Conditional rendering based on state
              Text(
                count == 0 ? 'Start counting!' : 'Keep going!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 40),
              
              // Action buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrement button
                  FloatingActionButton(
                    onPressed: decrement,
                    backgroundColor: Colors.red,
                    heroTag: 'decrement',
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  
                  // Reset button
                  FloatingActionButton(
                    onPressed: reset,
                    backgroundColor: Colors.grey,
                    heroTag: 'reset',
                    child: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 20),
                  
                  // Increment button
                  FloatingActionButton(
                    onPressed: increment,
                    backgroundColor: Colors.green,
                    heroTag: 'increment',
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// InfoCard - A StatelessWidget example
/// Displays static content that doesn't change over time
/// StatelessWidgets are immutable - their properties cannot change
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
