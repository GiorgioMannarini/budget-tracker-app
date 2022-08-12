import 'package:flutter/material.dart';

class TopNeuCard extends StatefulWidget {
  final String balance;
  final String remainingBudget;
  final String spent;
  final String dateText;
  final Function setNewBudget;
  final Function changeMonth;


  const TopNeuCard({
    required this.balance,
    required this.remainingBudget,
    required this.spent,
    required this.dateText,
    required this.setNewBudget,
    required this.changeMonth
  });

  @override
  State<TopNeuCard> createState() => _TopNeuCardState();
}

class _TopNeuCardState extends State<TopNeuCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details){
        if(details.velocity.pixelsPerSecond.dx < 1) {
          widget.changeMonth(false);
        }
        else {
          widget.changeMonth(true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 250,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('B A L A N C E',
                    style: TextStyle(color: Colors.grey[500], fontSize: 24)),
                Text(
                  'CHF ' + widget.remainingBudget,
                  style: TextStyle(color: Colors.grey[800], fontSize: 40),
                ),
                Text(widget.dateText, key: ValueKey<String>(widget.dateText), style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: GestureDetector(
                              onTap: () {widget.setNewBudget();},
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Budget',
                                  style: TextStyle(color: Colors.grey[500])),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(widget.balance,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Expenses',
                                  style: TextStyle(color: Colors.grey[500])),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(widget.spent,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[300],
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade500,
                    offset: Offset(4.0, 4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0),
              ]),
        ),
      ),
    );
  }
}