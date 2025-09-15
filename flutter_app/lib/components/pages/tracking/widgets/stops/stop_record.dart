import 'package:flutter/material.dart';

class StopWidget extends StatelessWidget {
  final int stopNumber;
  final String stopName;
  final String time;
  final bool reached;

  const StopWidget({
    super.key,
    required this.stopNumber,
    required this.stopName,
    required this.time,
    this.reached = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: reached ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 40,
              color: Colors.grey.shade400, // connector line
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stop $stopNumber",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: reached ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stopName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
