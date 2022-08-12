import 'package:shared_preferences/shared_preferences.dart';

class LocalParameters {

  static Future<double> loadBudget() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('budget') ?? 1000;
  }

  static Future<void> setBudget(double newBudget) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('budget', newBudget);
  }
}