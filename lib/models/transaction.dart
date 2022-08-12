import 'package:flutter_dotenv/flutter_dotenv.dart';

class Transaction {
  final String name;
  final String category;
  final double price;
  final DateTime date;
  final String? id;

  const Transaction(
      {required this.name,
      required this.category,
      required this.price,
      required this.date, this.id});

  factory Transaction.fromMap(Map<String, dynamic> singleTransactionMap) {
    final properties = singleTransactionMap['properties'];
    final nameList = (properties['Name']?['title'] ?? []) as List;
    final dateStr = properties['Date']?['date']?['start'];
    return Transaction(
        id: singleTransactionMap['id'],
        name: nameList.isNotEmpty ? nameList[0]['text']['content'] : '?',
        category: properties['Category']?['select']?['name'] ?? 'Any',
        price: (properties['Price']?['number'] ?? 0).toDouble(),
        date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now());
  }

  Map<String, dynamic> toJson() => {
        "parent": {
          "database_id": dotenv.env["NOTION_DATABASE_ID_TRANSACTIONS"]
        },
        "properties": {
          "Name": {
            "title": [
              {
                "text": {"content": name}
              }
            ]
          },
          "Price": {"number": price},
          "Category": {
            "select": {"name": category}
          },
          "Date": {
            "date": {"start": date.toString()}
          }
        }
      };
}
