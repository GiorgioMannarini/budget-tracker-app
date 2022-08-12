import 'dart:convert';
import 'dart:io';
import 'package:budget_tracker/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExpensesApi {
  static const String _baseURL = 'https://api.notion.com/v1';
  final http.Client _client;

  ExpensesApi({http.Client? client}) : _client = client ?? http.Client();

  /// Makes an API call to the notion database to return a list of
  /// all the transactions present in the database
  Future<List<Transaction>> getData() async {
    try {
      final url =
          '$_baseURL/databases/${dotenv.env['NOTION_DATABASE_ID_TRANSACTIONS']}/query';
      final response = await _client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Notion-Version': '2021-05-13',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return _convertJSONDataToTransactions(data);
      } else {
        throw Exception('Request failed - Status code ${response.statusCode}');
      }
    } catch (_) {
      throw Exception('Request failed');
    }
  }

  Future<http.Response> postNewTransaction(Transaction newTransaction) async {
    const url = '$_baseURL/pages';
    final http.Response response = await _client.post(Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2021-05-13',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(newTransaction));
    return response;
  }

  Future<http.Response> deleteTransaction(Transaction transactionToDelete) async {
    final url = '$_baseURL/pages/${transactionToDelete.id}';
    final http.Response response = await _client.patch(Uri.parse(url),
        headers: {
    HttpHeaders.authorizationHeader:
    'Bearer ${dotenv.env['NOTION_API_KEY']}',
    'Notion-Version': '2021-05-13',
    'Content-Type': 'application/json'
    },
        body: jsonEncode({"archived": true})
    );
    return response;
  }

  /// Converts an already fetched json dictionary of transactions to
  /// a list of Transaction items, according to the filter
  List<Transaction> _convertJSONDataToTransactions(Map<String, dynamic> map) {
    return (map['results'] as List)
        .map((transaction) => Transaction.fromMap(transaction))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
