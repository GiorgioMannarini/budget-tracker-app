import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Icon icon;
  final Transaction transaction;

  TransactionCard({
    Key? key,
    required this.icon,
    required this.transaction,
  }) : super(key: key);
  late final String title = transaction.name;
  late final String subtitle =
      '${transaction.category} • ${DateFormat.yMd().format(transaction.date)}';
  late final String trailing = 'CHF ${transaction.price.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[500]),
                    child: Center(
                      child: icon,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      )),
                ],
              ),
              Text(
                trailing,
                style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
