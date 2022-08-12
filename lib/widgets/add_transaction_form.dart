import 'package:flutter/material.dart';

class AddTransactionForm extends StatefulWidget {
  final Function enterTransaction; // From parent, to change its state

  const AddTransactionForm({Key? key, required this.enterTransaction})
      : super(key: key);

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = "Food";
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerNAME = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('T R A N S A C T I O N')
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text('Expense'),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Amount?',
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Enter an amount';
                            }
                            return null;
                          },
                          controller: _textcontrollerAMOUNT,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'For what?',
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Enter a description';
                          }
                          return null;
                        },
                        controller: _textcontrollerNAME,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton(
                        value: _selectedCategory,
                        items: dropdownItems,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
              child: const Text('Enter', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Convert comma in dot
                  final amount = _textcontrollerAMOUNT.text.replaceFirst(',', '.');
                  widget.enterTransaction(
                      _textcontrollerNAME.text,
                      double.parse(amount),
                      _selectedCategory);
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  /// These are the accepted categories that show up in the dropdown
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Food"), value: "Food"),
      const DropdownMenuItem(
          child: Text("Entertainment"), value: "Entertainment"),
      const DropdownMenuItem(
          child: Text("Transportation"), value: "Transportation"),
      const DropdownMenuItem(
          child: Text("Personal"), value: "Personal"),
      const DropdownMenuItem(
          child: Text("Home"), value: "Home"),
      const DropdownMenuItem(child: Text("Other"), value: "Other"),
    ];
    return menuItems;
  }
}
