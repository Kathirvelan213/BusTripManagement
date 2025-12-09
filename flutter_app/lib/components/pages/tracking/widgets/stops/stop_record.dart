import 'package:flutter/material.dart';

class StopWidget extends StatelessWidget {
  final int stopNumber;
  final String stopName;
  final String time;
  final bool reached;
  final bool passed;

  const StopWidget({
    super.key,
    required this.stopNumber,
    required this.stopName,
    required this.time,
    this.reached = false,
    this.passed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 30,
                    width: 2,
                    color: reached ? Colors.blue : Colors.grey.shade300,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 30,
                    width: 2,
                    color: passed ? Colors.blue : Colors.grey.shade300,
                  ),
                ],
              ),
              if (reached && !passed)
                Container(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    "assets/images/bus_front_icon.png",
                    fit: BoxFit.contain,
                  ),
                ),
            ],
          ),
        ]),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.15),
                  blurRadius: 2,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade300,
                elevation: 0,
                // shadowColor: Colors.blue.shade100,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: Container(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(0),
                // ),

                height: 55,
                margin: const EdgeInsets.only(right: 16),
                // elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 28,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 14,
                          color: reached
                              ? const Color.fromARGB(255, 40, 47, 53)
                              : Colors.grey.shade600,
                        ),
                        softWrap: true,
                      ),
                      Text(
                        stopName,
                        style: TextStyle(
                          fontSize: 14,
                          color: reached
                              ? const Color.fromARGB(255, 49, 145, 166)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
