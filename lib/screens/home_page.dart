import 'package:budget_tracker/apis/set_local_parameters.dart';
import 'package:budget_tracker/widgets/add_transaction_form.dart';
import 'package:budget_tracker/widgets/change_budget_form.dart';
import 'package:budget_tracker/widgets/plus_button.dart';
import 'package:budget_tracker/widgets/top_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../apis/expenses_database_api.dart';
import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

class BudgetTrackerHomePage extends StatefulWidget {
  const BudgetTrackerHomePage({Key? key}) : super(key: key);

  @override
  _BudgetTrackerHomePageState createState() => _BudgetTrackerHomePageState();
}

class _BudgetTrackerHomePageState extends State<BudgetTrackerHomePage> {
  late Future<List<Transaction>> _futureItems;
  int _monthToVisualize = DateTime.now().month;
  int _yearToVisualize = DateTime.now().year;
  ExpensesApi apiClient = ExpensesApi();
  bool isLoading = false;
  late Future<double> monthlyBudget;
  double spent = 0;
  double available = 0;

  /// At the render of the component we set the monthly budget and we fetch the data
  @override
  void initState() {
    super.initState();
    monthlyBudget = LocalParameters.loadBudget();
    _futureItems = apiClient.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: RefreshIndicator(
          color: Colors.grey,
          onRefresh: () async {
            _futureItems = apiClient.getData();
            setState(() {});
          },
          child: FutureBuilder(
            future: Future.wait([_futureItems, monthlyBudget]),
            // We wait for the two futures to load, one from the web and the other from the storage
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                spent = 0;
                // Display transactions of the considered month (by default the last one)
                final transactionsToDisplay =
                    _transactionsToVisualize(snapshot.data![0]);
                for (var transaction in transactionsToDisplay) {
                  spent += transaction.price;
                }
                final monthlyBudget = snapshot.data![1];
                available = monthlyBudget - spent;
                return Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    TopNeuCard(
                      balance: monthlyBudget.toStringAsFixed(2),
                      remainingBudget: available.toStringAsFixed(2),
                      spent: spent.toStringAsFixed(2),
                      setNewBudget: _setNewBudgetForm,
                      changeMonth: _changeMonth,
                      dateText: DateFormat('MMMM')
                              .format(DateTime(0, _monthToVisualize))
                              .toString() +
                          ' ' +
                          _yearToVisualize.toString(),
                    ),
                    isLoading
                        ? Column(children: const [
                            SizedBox(
                              height: 30,
                            ),
                            CircularProgressIndicator(color: Colors.grey)
                          ])
                        : Expanded(
                            child: transactionsToDisplay.isEmpty
                                ? Center(
                                    child: Text('No transactions to display',
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 24)),
                                  )
                                : ListView.builder(
                                    itemCount: transactionsToDisplay.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final transaction =
                                          transactionsToDisplay[index];
                                      return Dismissible(
                                        key: UniqueKey(),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (_) =>
                                            _deleteTransaction(transaction),
                                        child: TransactionCard(
                                            icon: _getCategoryIcon(
                                                transaction.category),
                                            transaction: transaction),
                                        background: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 0.0, 20.0, 0.0),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                // Show failure error message.
                return const Center(child: Text('Error'));
              }
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.grey,
              ));
            },
          ),
        ),
      ),
      floatingActionButton: PlusButton(
        onPressed: _enterTransactionForm,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Filter for transactions in mont and year selected (by default the current one)
  List<Transaction> _transactionsToVisualize(
      List<Transaction> allTransactions) {
    return allTransactions
        .where((transaction) =>
            ((transaction.date.month == _monthToVisualize) &&
                (transaction.date.year == _yearToVisualize)))
        .toList();
  }

  /// Form to set a new budget, opens on tap of the green arrow in the top card
  void _setNewBudgetForm() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ChangeBudgetForm(setNewBudget: _setNewBudget);
        });
  }

  /// Logic to actually set a new budget in the local storage
  void _setNewBudget(double budget) {
    LocalParameters.setBudget(budget)
        .then((_) => {monthlyBudget = LocalParameters.loadBudget()})
        .then((_) => setState(() {}));
  }

  /// Logic that defines what to do when a new transaction is entered.
  /// In particular what happens is that the transaction is posted to the database
  /// then the new data is fetched and the transaction is displayed.
  void _enterTransaction(String name, double price, String category) {
    setState(() {
      isLoading = true;
    });
    apiClient
        .postNewTransaction(Transaction(
            name: name, price: price, category: category, date: DateTime.now()))
        .then((_) => _futureItems = apiClient.getData())
        .then((_) => setState(() {
              isLoading = false;
            }));
  }

  /// Function which shows the form to add a new transaction
  void _enterTransactionForm() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AddTransactionForm(
            enterTransaction: _enterTransaction,
          );
        });
  }

  /// Function to delete a transaction and refresh the state
  void _deleteTransaction(transaction) {
    apiClient
        .deleteTransaction(transaction)
        .then((_) => _futureItems = apiClient.getData())
        .then((_) => {setState(() {})});
  }

  /// Function to change the visualized month. In particular we can't go
  /// further than the current month and back in time more than Jan 2022
  void _changeMonth(bool toPrevious) {
    if (toPrevious &&
        DateTime(_yearToVisualize, _monthToVisualize, 01)
            .isAfter(DateTime(2022, 1, 1))) {
      setState(() {
        _monthToVisualize == 1
            ? {_monthToVisualize = 12, _yearToVisualize -= 1}
            : _monthToVisualize -= 1;
      });
    } else if (!toPrevious &&
        DateTime.now().month > _monthToVisualize &&
        DateTime.now().year >= _yearToVisualize) {
      setState(() {
        _monthToVisualize == 12
            ? {_monthToVisualize = 1, _yearToVisualize += 1}
            : _monthToVisualize += 1;
      });
    }
  }

  /// Get the icon for each category
  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Entertainment':
        return const Icon(Icons.tv, color: Colors.white);
      case 'Food':
        return const Icon(Icons.lunch_dining, color: Colors.white);
      case 'Personal':
        return const Icon(Icons.sports_esports, color: Colors.white);
      case 'Transportation':
        return const Icon(Icons.train, color: Colors.white);
      case 'Home':
        return const Icon(Icons.house, color: Colors.white);
      default:
        return const Icon(Icons.attach_money_outlined, color: Colors.white);
    }
  }
}
