import 'package:shared_preferences/shared_preferences.dart';

class LocalParameters {

  /// Load the monthly budget value or set it to 1000 if not present
  static Future<double> loadBudget() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('budget') ?? 1000;
  }

  /// Store the new monthly budget value
  static Future<void> setBudget(double newBudget) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('budget', newBudget);
  }
}