// File: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/countdown_event.dart';
import '../widgets/countdown_card.dart';
import 'add_countdown_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _deleteCountdown(BuildContext context, CountdownEvent countdown) {
    final box = Hive.box<CountdownEvent>('countdowns');
    countdown.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${countdown.title} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            box.add(countdown);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Countdowns'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<CountdownEvent>('countdowns').listenable(),
        builder: (context, Box<CountdownEvent> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 64,
                    color: Colors.blue.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No countdowns yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first countdown by tapping the + button',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final countdown = box.getAt(index);
              return CountdownCard(
                countdown: countdown!,
                onDelete: (countdown) => _deleteCountdown(context, countdown),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCountdownScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}