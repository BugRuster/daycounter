import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../models/countdown_event.dart';

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
  late Duration _timeLeft;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    setState(() {
      _timeLeft = widget.countdown.targetDate.difference(DateTime.now());
    });
  }

  String _getDetailedTimeText() {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours;
    final minutes = _timeLeft.inMinutes;
    final seconds = _timeLeft.inSeconds;
    
    return '''
Total time remaining:
• $days days
• $hours total hours
• $minutes total minutes
• $seconds total seconds''';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showDetails = !_showDetails;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C23),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.countdown.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (widget.countdown.description?.isNotEmpty ?? false)
                            Text(
                              widget.countdown.description!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!_showDetails)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeUnit(_timeLeft.inDays, 'DAYS'),
                        _buildSeparator(),
                        _buildTimeUnit(_timeLeft.inHours % 24, 'HRS'),
                        _buildSeparator(),
                        _buildTimeUnit(_timeLeft.inMinutes % 60, 'MIN'),
                        _buildSeparator(),
                        _buildTimeUnit(_timeLeft.inSeconds % 60, 'SEC'),
                      ],
                    )
                  else
                    Text(
                      _getDetailedTimeText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  if (_showDetails)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Tap to show less',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Tap for more details',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: SizedBox(
                width: 32,
                height: 32,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: const Size(32, 32),
                      painter: CircularProgressPainter(
                        progress: _getProgress(),
                        backgroundColor: Colors.white.withOpacity(0.1),
                        progressColor: const Color(0xFF0A84FF),
                      ),
                    ),
                    Positioned.fill(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red.withOpacity(0.7),
                        ),
                        onPressed: () => widget.onDelete(widget.countdown),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 20,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withOpacity(0.2),
    );
  }

  double _getProgress() {
    final totalDuration = const Duration(days: 30);
    final progress = _timeLeft.inSeconds / totalDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) =>
      progress != oldDelegate.progress;
}