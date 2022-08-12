import 'package:flutter/material.dart';

class ChangeBudgetForm extends StatelessWidget {
  final Function setNewBudget; //from parent to set its state
  final TextEditingController _budgetController = TextEditingController();

  ChangeBudgetForm ({Key? key,
    required this.setNewBudget
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('B U D G E T')],
      ),
      content: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'New budget?',
                    ),
                    controller: _budgetController,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ])),
      actions: <Widget>[
        MaterialButton(
          color: Colors.grey[600],
          child:
          const Text('Cancel', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        MaterialButton(
          color: Colors.grey[600],
          child:
          const Text('Enter', style: TextStyle(color: Colors.white)),
          onPressed: () {
            setNewBudget(double.parse(
                double.parse(_budgetController.text)
                    .toStringAsFixed(2)));
            Navigator.of(context).pop();
          },
        )
      ],
    );;
  }
}
