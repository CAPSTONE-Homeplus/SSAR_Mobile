import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PointsDisplay extends StatelessWidget {
  final int points;
  final double borderRadius;
  final EdgeInsets padding;

  const PointsDisplay({
    Key? key,
    required this.points,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.stars,
            color: Colors.amber,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            formatPoints(points),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 8,
          ),
        ],
      ),
    );
  }

  String formatPoints(int points) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(points);
  }
}