// File: lib/widgets/countdown_card.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/countdown_event.dart';
import '../screens/edit_countdown_screen.dart';

class CountdownCard extends StatefulWidget {
  final CountdownEvent countdown;
  final Function(CountdownEvent) onDelete;

  const CountdownCard({
    Key? key,
    required this.countdown,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Duration _timeLeft;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    setState(() {
      _timeLeft = widget.countdown.targetDate.difference(DateTime.now());
      if (_timeLeft.inSeconds % 60 == 0) {
        _animationController.forward(from: 0.0);
      }
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Event has passed';
    }
    
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    return '$days days, $hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDetailedDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Event has passed';
    }
    
    final totalHours = duration.inHours;
    final days = duration.inDays;
    
    return '''
Total time remaining:
• ${totalHours.toString()} hours
• ${days.toString()} days
• ${(totalHours * 60).toString()} minutes
• ${(duration.inSeconds).toString()} seconds''';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _showDetails = !_showDetails;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.countdown.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCountdownScreen(
                              countdown: widget.countdown,
                            ),
                          ),
                        );
                      } else if (value == 'delete') {
                        widget.onDelete(widget.countdown);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.countdown.description != null && 
                  widget.countdown.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(widget.countdown.description!),
                ),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Text(
                    _showDetails 
                      ? _formatDetailedDuration(_timeLeft)
                      : _formatDuration(_timeLeft),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: _showDetails ? 16 : 20,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Tap for ${_showDetails ? 'less' : 'more'} details',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }
}